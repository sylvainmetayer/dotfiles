#!/bin/sh
set -e

# In theory, we should use machine-readable output `--with-colons`.
# This will work OK, until it doesn't.

gpg --show-keys --with-fingerprint "$1" |
	sed -E -n -e 's/.*(([0-9A-F]{4}[ ]*){10,}).*/\1/ p' |
	sort

# Fingerprints are sorted, for easy comparison
