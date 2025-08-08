#!/bin/sh

rm -rf /home/vscode/.local/bin/hol-light-multivariate.ckpt
rm -rf /home/vscode/.local/bin/hol-light-multivariate
cd "${HOLLIGHT_DIR}"
exec ./make-checkpoint.sh ~/.local/bin/hol-light-multivariate "loadt \"/workspaces/hol-light-devcontainer/.devcontainer/mk_multivariate.ml\""