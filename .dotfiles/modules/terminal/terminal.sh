#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_fisher() {

    if ! is_fisher_installed; then
        execute \
            "curl -Lo $HOME/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher" \
            "fisher (install)"
    else
        print_success "(fisher) is already installed."
    fi

}

install_fisher_packages() {

    print_in_yellow "\n   Install fisher packages\n\n"

    does_fishfile_exist && {
        cat < "fishfile" | while read -r PACKAGE; do
            fisher_install "$PACKAGE"
        done
    }

    printf "\n"

    fisher_update

}

main() {

    print_in_purple "   Terminal\n\n"

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    install_fisher

    install_fisher_packages

}

main
