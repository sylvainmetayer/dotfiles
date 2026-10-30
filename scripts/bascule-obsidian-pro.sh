#!/usr/bin/env bash
# One-shot, à lancer sur GOP : prépare la bascule du coffre Obsidian pro de S3 vers kDrive WebDAV.
# Sauvegarde le coffre, archive les anciens coffres, copie les PDF à transférer, installe Obsidian
# par Ansible. Ne lit jamais le contenu des notes et n'affiche aucun secret. À supprimer après usage.
set -euo pipefail

JOUR=2026-10-30
DOCUMENTS="$HOME/Documents"
COFFRE="$DOCUMENTS/onepoint"
SAUVEGARDE="$HOME/obsidian-onepoint-avant-webdav-$JOUR.tar.zst"
TRANSFERT="$HOME/a-transferer-home"
ANCIENS="$TRANSFERT/obsidian-anciens-coffres-gop-$JOUR.tar.zst"
DOTFILES="$HOME/dotfiles"
VAULT_PASS="$HOME/.ansible_vault.txt"
JOURNAL="$HOME/bascule-obsidian-pro-$JOUR.log"

exec > >(tee -a "$JOURNAL") 2>&1

etape() { printf '\n=== %s ===\n' "$*"; }
arret() { printf '\nARRÊT : %s\n' "$*"; exit 1; }

etape "1/6 Contrôles"
if pgrep -x -i obsidian >/dev/null; then
  arret "Obsidian est ouvert : le fermer complètement, puis relancer le script"
fi
[[ -d "$COFFRE/.obsidian" ]] || arret "coffre introuvable : $COFFRE"
command -v zstd >/dev/null || arret "zstd absent : sudo dnf install zstd"
[[ -f "$VAULT_PASS" ]] || arret "$VAULT_PASS absent : lancer scripts/extract-secrets.sh avant"
md_coffre=$(find "$COFFRE" -type f -name '*.md' | wc -l)
md_hors_corbeille=$(find "$COFFRE" -path "$COFFRE/.trash" -prune -o -type f -name '*.md' -print | wc -l)
md_corbeille=$((md_coffre - md_hors_corbeille))
md_souligne=$(find "$COFFRE" -path "$COFFRE/.obsidian" -prune -o -path '*/_*' -type f -name '*.md' -print | wc -l)
printf 'Notes : %s au total, dont %s dans .trash et %s sous un dossier ou fichier commençant par _\n' \
  "$md_coffre" "$md_corbeille" "$md_souligne"

etape "2/6 Sauvegarde du coffre"
if [[ -f "$SAUVEGARDE" ]]; then
  echo "Sauvegarde déjà présente, elle est seulement vérifiée"
else
  tar --zstd -cf "$SAUVEGARDE.partiel" -C "$DOCUMENTS" onepoint
  mv "$SAUVEGARDE.partiel" "$SAUVEGARDE"
fi
md_archive=$(tar --zstd -tf "$SAUVEGARDE" | grep -c '\.md$' || true)
[[ "$md_archive" -eq "$md_coffre" ]] || arret "l'archive contient $md_archive notes au lieu de $md_coffre"
printf 'OK : %s (%s notes, %s)\n' "$SAUVEGARDE" "$md_archive" "$(du -h "$SAUVEGARDE" | cut -f1)"

etape "3/6 Anciens coffres Perso et test"
mkdir -p "$TRANSFERT"
anciens=()
for nom in Perso test; do
  if [[ -d "$DOCUMENTS/$nom" ]]; then
    anciens+=("$nom")
  fi
done
if [[ ${#anciens[@]} -eq 0 ]]; then
  echo "Déjà retirés, rien à faire"
else
  tar --zstd -cf "$ANCIENS" -C "$DOCUMENTS" "${anciens[@]}"
  tar --zstd -tf "$ANCIENS" >/dev/null
  for nom in "${anciens[@]}"; do
    gio trash "$DOCUMENTS/$nom"
  done
  printf 'OK : %s archivés dans %s puis mis à la corbeille\n' "${anciens[*]}" "$ANCIENS"
fi

etape "4/6 Fichiers de l'ancien ~/kDrive"
if [[ -d "$HOME/kDrive" ]]; then
  find "$HOME/kDrive" -maxdepth 3 -type f \
    \( -name 'Avenant Revalorisation*.pdf' -o -name 'Puy-Du-Fou-*.pdf' \) \
    -exec cp -p --update=none -t "$TRANSFERT" {} +
  # mistral.txt contient probablement une clé : on donne seulement son emplacement.
  find "$HOME/kDrive" -maxdepth 3 -type f -name 'mistral.txt' -printf 'À mettre dans KeePassXC puis shred -u : %p (%s octets)\n'
else
  echo "Pas de ~/kDrive, rien à copier"
fi
echo "Contenu de $TRANSFERT :"
ls -1 "$TRANSFERT"

etape "5/6 Installation d'Obsidian par Ansible"
cd "$DOTFILES"
git pull --ff-only
grep -q 'tags: \[obsidian\]' playbook/setup-gop.yaml || arret "le tag obsidian manque dans playbook/setup-gop.yaml"
playbook=ansible-playbook
if [[ -x .venv/bin/ansible-playbook ]]; then
  playbook=.venv/bin/ansible-playbook
fi
echo "Le mot de passe sudo va être demandé (BECOME password)"
ANSIBLE_VAULT_PASSWORD_FILE="$VAULT_PASS" "$playbook" playbook/setup-gop.yaml -K --tags obsidian
[[ -e "$HOME/.local/bin/obsidian" ]] || arret "Obsidian n'est pas dans ~/.local/bin après Ansible"
echo "OK : Obsidian installé"

etape "6/6 Bilan"
printf 'Notes du coffre : %s (S3 en avait 791)\n' "$md_coffre"
printf 'Sauvegarde : %s\n' "$SAUVEGARDE"
printf 'Journal : %s\n' "$JOURNAL"
echo "Reste à faire à la main : voir les étapes remotely-save données par Claude"
