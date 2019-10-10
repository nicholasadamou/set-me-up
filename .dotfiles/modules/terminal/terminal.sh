#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# see: https://github.com/oh-my-fish/oh-my-fish/issues/189
install_omf() {

    if ! is_omf_installed; then
		# Make sure '$HOME/.local/share/omf' does not exist prior
		# to 'omf' installation.

		if [ -d "$HOME/.local/share/omf" ]; then
			sudo rm -rf "$HOME/.local/share/omf"
		fi

		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        execute \
            "fish -c\"
                curl -Ls https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o install && \
                sudo chmod +x install && \
                ./install --noninteractive --yes --path=$HOME/.local/share/omf --config=$HOME/.config/omf && \
                rm -rf install\"" \
            "omf (install)"
    else
        print_success "(omf) is already installed."
    fi

}

install_omf_packages() {

    print_in_yellow "\n  Install omf packages\n\n"

    omf_install "thefuck"

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

    does_fishfile_exist && {
        cat < "fishfile" | while read -r PACKAGE; do
            fisher_install "$PACKAGE"
        done
    }

    printf "\n"

    fisher_update

}

main() {

    print_in_purple "  Terminal\n\n"

    apt_install_from_file "packages"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    install_omf

    install_omf_packages

    printf "\n"

    install_fisher

    install_fisher_packages

}

main
