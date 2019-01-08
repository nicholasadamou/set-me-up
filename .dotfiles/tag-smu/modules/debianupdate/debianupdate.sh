#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  Debian Update\n\n"

    ask_for_sudo

    execute \
        "sudo apt update \
			&& sudo apt upgrade -y \
			&& sudo apt full-upgrade -y \
			&& sudo apt autoremove -y \
			&& sudo apt clean" \
        "Debian (Install all available updates)"

}

main
