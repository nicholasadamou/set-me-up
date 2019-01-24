#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Launchpad\n\n"

command -v "lporg" &> /dev/null && [ -f "$HOME/.launchpad.yaml" ] && {
	execute "lporg load $HOME/.launchpad.yaml" \
		"Restore launchpad layout using ($HOME/.launchpad.yaml)"
}
