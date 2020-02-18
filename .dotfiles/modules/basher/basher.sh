#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r BASHER_DIRECTORY="$HOME/.basher"
declare -r BASHER_GIT_REPO_URL="https://github.com/basherpm/basher"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_basher() {

    # Install `basher` and add the necessary
    # configs in the local shell config files.

    git clone --quiet "$BASHER_GIT_REPO_URL" "$BASHER_DIRECTORY" \
        && add_basher_configs

}

# If needed, add the necessary configs in the
# local shell configuration files.
add_basher_configs() {

    # bash

    declare -r BASH_CONFIGS="
# basher - A package manager for shell scripts.
export PATH=\"$HOME/.basher/bin:\$PATH\"
eval \"\$(basher init -)\""

    if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi

}

basher_upgrade() {

    git -C "$BASHER_DIRECTORY" fetch --quiet origin

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    if ! cmd_exists "basher"; then
        install_basher
    else
        basher_upgrade
    fi

}

main
