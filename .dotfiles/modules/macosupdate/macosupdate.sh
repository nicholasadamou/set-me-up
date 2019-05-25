#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  MacOS Update\n\n"

    ask_for_sudo

	if command -v u &>/dev/null; then
		execute \
			"u" \
			"MacOS (Install all available updates)"
	else
		execute \
			"sudo softwareupdate -i -a" \
			"MacOS (Install all available updates)"
	fi

}

main
