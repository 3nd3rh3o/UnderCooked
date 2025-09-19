#!/bin/sh
printf '\033c\033]0;%s\a' undercooked
base_path="$(dirname "$(realpath "$0")")"
"$base_path/undercooked.x86_64" "$@"
