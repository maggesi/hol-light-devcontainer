#!/bin/sh

cd "${HOLLIGHT_DIR}"
rm -rf ~/.local/bin/hol-light-core
rm -rf ~/.local/bin/hol-light-core.ckpt
exec ./make-checkpoint.sh ~/.local/bin/hol-light-core "loadt \"/workspaces/hol-light-devcontainer/.devcontainer/core_load.ml\""