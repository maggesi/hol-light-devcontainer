#!/bin/sh

# Usage: restart-ocaml-checkpoint.sh <restart-script> <message>

set -e -u

# Command arguments.
RESTART_SCRIPT="$1"
MESSSAGE_STRING="$2"

# Build the banner string.
DATE_CREATED="$(stat --format="%w" /home/vscode/checkpoints/hol-light-core)"
START_BANNER="HOL Light checkpoint of ${DATE_CREATED}"
PROMPT_STRING="\n# "
BANNER_STRING="${START_BANNER}\n${MESSSAGE_STRING}\n${PROMPT_STRING}"

(sleep 2; echo -n "${BANNER_STRING}") & exec "${RESTART_SCRIPT}"
