#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

LOCAL_BASH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/bash.local"
LOCAL_FISH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/fish.local"

declare -r CARGO_DIRECTORY="$HOME/.cargo"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_cargo_configs() {

    # bash

    declare -r BASH_CONFIGS="
# Cargo - Rust package manager.
export PATH=\"$CARGO_DIRECTORY/bin:\$PATH\""

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q -z "$BASH_CONFIGS" "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
            && . $LOCAL_BASH_CONFIG_FILE" \
            "cargo (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# Cargo - Rust package manager.
set -gx PATH \$PATH $CARGO_DIRECTORY/bin"

    if [ ! -e "$LOCAL_FISH_CONFIG_FILE" ] || ! grep -q -z "$FISH_CONFIGS" "$LOCAL_FISH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "cargo (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_cargo_packages() {

    print_in_yellow "\n   Install cargo packages\n\n"

    cargo_install "topgrade"
    cargo_install "diskus"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  Rust & Cargo\n\n"
    
    ask_for_sudo

    if [ ! -d "$CARGO_DIRECTORY" ]; then
        brew_bundle_install "Brewfile" \
            && add_cargo_configs
    fi

    install_cargo_packages

}

main
