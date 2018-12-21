#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# see: https://github.com/oh-my-fish/oh-my-fish/issues/189
install_omf() {

    if ! is_omf_installed; then
        execute \
            "curl -Ls github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > install && \
            chmod +x install && \
            ./install --noninteractive --path=$HOME/.local/share/omf --config=$HOME/.config/omf && \
            rm -rf install" \
            "omf (install)"
    else
        print_success "(omf) is already installed."
    fi

}

install_omf_packages() {

    print_in_yellow "\n  Install omf packages\n\n"

    omf_install "z"
    omf_install "thefuck"
    omf_install "spacefish"

    printf "\n"

    omf_update

}

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

    [ -f "${current_dir}/fishfile" ] && {
        cat < "${current_dir}/fishfile" | while read -r PACKAGE; do
            fisher_install "$PACKAGE"
        done
    }

    printf "\n"

    fisher_update

}

install_tacklebox() {

    if ! is_tacklebox_installed; then
        execute \
            "git clone https://github.com/justinmayer/tacklebox ~/.tacklebox \
            && git clone https://github.com/justinmayer/tackle ~/.tackle" \
            "tacklebox (install)"
    else
        print_success "(tacklebox) is already installed."
    fi

}

main() {

    print_in_purple "   Terminal\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    ask_for_sudo

    install_omf

    install_omf_packages

    printf "\n"

    install_fisher

    install_fisher_packages

    printf "\n"

    install_tacklebox

}

main
