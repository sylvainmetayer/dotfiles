#!/usr/bin/env bash

# Point Docker clients (docker CLI, docker-compose, Testcontainers, IDEs)
# at the rootless podman socket enabled by the commons role.
DOCKER_HOST="unix:///run/user/$(id -u)/podman/podman.sock"
export DOCKER_HOST

# Ryuk needs a privileged container, which rootless podman does not allow.
TESTCONTAINERS_RYUK_DISABLED=true
export TESTCONTAINERS_RYUK_DISABLED
