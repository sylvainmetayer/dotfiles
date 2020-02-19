#!/usr/bin/env bash

# Will delete old kernel on Fedora by keeping only the 2 most recent one.
# - Require `yum-utils`


cleanOldKernel() {
    sudo package-cleanup --oldkernels --count=2 || sudo dnf erase "$(dnf repoquery --installonly --latest-limit=-2)"
}
