#!/usr/bin/env python3
"""Vérifie que les URL de téléchargement modifiées par une PR répondent.

Relève toutes les URL http(s) des valeurs YAML (playbooks, rôles, host_vars,
group_vars), après rendu Jinja avec les variables du rôle, de group_vars/all et
de chaque hôte : une montée de version dans defaults/ change ainsi l'URL rendue
dans tasks/ (xremap). Les URL présentes dans la tête et absentes de la base
passent par `curl -fsIL --retry 3` ; une seule en échec fait échouer le script.

Une URL qui dépend d'un fait Ansible (ansible_facts) ne se rend pas hors d'un
hôte : elle est signalée et ignorée.

    check_download_urls.py --base <checkout de la base> [--head .]
    check_download_urls.py --all [--head .]   # toutes les URL, en local
"""

from __future__ import annotations

import argparse
import re
import subprocess  # nosec B404 : curl seul, liste d'arguments sans shell
import sys
from pathlib import Path

import jinja2
import yaml

URL_RE = re.compile(r"https?://[^\s\"'<>]+")
SCAN_DIRS = ("playbook", "roles", "host_vars", "group_vars")
SCAN_FILES = ("inventory.yml",)
MAX_PASSES = 5


class _Loader(yaml.SafeLoader):
    """SafeLoader qui accepte les balises Ansible (!vault, !unsafe…)."""


_Loader.add_multi_constructor("!", lambda loader, suffix, node: None)

_ENV = jinja2.Environment(undefined=jinja2.StrictUndefined, autoescape=False)  # nosec B701 : URL, pas de HTML


def _load(path: Path):
    try:
        return yaml.load(path.read_text(encoding="utf-8"), Loader=_Loader)  # nosec B506 : SafeLoader
    except (yaml.YAMLError, UnicodeDecodeError):
        return None


def _strings(node):
    if isinstance(node, str):
        yield node
    elif isinstance(node, dict):
        for value in node.values():
            yield from _strings(value)
    elif isinstance(node, list):
        for value in node:
            yield from _strings(value)


def _yaml_files(root: Path):
    for name in SCAN_DIRS:
        base = root / name
        if base.is_dir():
            for path in sorted(base.rglob("*")):
                if path.suffix in (".yml", ".yaml") and not path.name.endswith(".sops.yaml"):
                    yield path
    for name in SCAN_FILES:
        if (root / name).is_file():
            yield root / name


def _vars_of(paths) -> dict:
    merged: dict = {}
    for path in paths:
        data = _load(path)
        if isinstance(data, dict):
            merged.update(data)
    return merged


def _contexts(root: Path, path: Path) -> list[dict]:
    """Un contexte de variables par hôte (au moins un), pour le fichier donné."""
    base: dict = {}
    rel = path.relative_to(root)
    if rel.parts[0] == "roles" and len(rel.parts) > 2:
        role = root / "roles" / rel.parts[1]
        base.update(_vars_of(sorted((role / "defaults").glob("*.y*ml"))))
        base.update(_vars_of(sorted((role / "vars").glob("*.y*ml"))))
    base.update(_vars_of(sorted((root / "group_vars").glob("all.y*ml"))))
    hosts = [
        p for p in sorted((root / "host_vars").glob("*"))
        if not p.name.endswith(".sops.yaml") and (p.is_dir() or p.suffix in (".yml", ".yaml"))
    ]
    contexts = []
    for host in hosts:
        files = sorted(host.glob("*.y*ml")) if host.is_dir() else [host]
        contexts.append({**base, **_vars_of(files)})
    return contexts or [base]


def _render(text: str, context: dict) -> str | None:
    for _ in range(MAX_PASSES):
        if "{{" not in text and "{%" not in text:
            return text
        try:
            text = _ENV.from_string(text).render(context)
        except Exception:  # noqa: BLE001 : toute erreur de rendu = URL non résolue
            return None
    return None


def collect_urls(root: Path) -> tuple[set[str], set[str]]:
    """(URL rendues, chaînes à URL non rendues) du dépôt `root`."""
    urls: set[str] = set()
    unresolved: set[str] = set()
    for path in _yaml_files(root):
        data = _load(path)
        candidates = [s for s in _strings(data) if "://" in s]
        if not candidates:
            continue
        contexts = None
        for text in candidates:
            if "{{" not in text and "{%" not in text:
                urls.update(URL_RE.findall(text))
                continue
            contexts = contexts or _contexts(root, path)
            rendered = {_render(text, ctx) for ctx in contexts}
            if None in rendered:
                unresolved.add(text.strip())
            for value in rendered - {None}:
                urls.update(URL_RE.findall(value))
    return urls, unresolved


def check(url: str) -> bool:
    result = subprocess.run(  # nosec B603 B607 : curl, arguments fixes
        ["curl", "-fsIL", "--retry", "3", "--max-time", "60", "-o", "/dev/null", "-w", "%{http_code}", url],
        capture_output=True,
        text=True,
        check=False,
    )
    ok = result.returncode == 0
    print(f"{'OK ' if ok else 'KO '} {result.stdout or '---'} {url}")
    if not ok:
        print(f"::error::URL injoignable (curl {result.returncode}) : {url}")
    return ok


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--head", type=Path, default=Path("."))
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--base", type=Path, help="checkout de la branche cible")
    group.add_argument("--all", action="store_true", help="vérifie toutes les URL")
    args = parser.parse_args(argv)

    head_urls, unresolved = collect_urls(args.head.resolve())
    if args.all:
        changed = head_urls
    else:
        base_urls, base_unresolved = collect_urls(args.base.resolve())
        changed = head_urls - base_urls
        unresolved -= base_unresolved

    for text in sorted(unresolved):
        print(f"::notice::URL non rendue hors d'un hôte, ignorée : {text}")
    if not changed:
        print("Aucune URL modifiée.")
        return 0
    results = [check(url) for url in sorted(changed)]
    return 0 if all(results) else 1


if __name__ == "__main__":
    sys.exit(main())
