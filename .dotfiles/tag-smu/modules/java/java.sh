#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    . "$(readlink -f "${current_dir}/../utilities/utils.sh")"

LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"
LOCAL_FISH_CONFIG_FILE="$HOME/.fish.local"

declare -r JENV_DIRECTORY="$HOME/.jenv"
declare -r JENV_GIT_REPO_URL="https://github.com/gcuisinier/jenv.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_jenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# JEnv - Manage your Java environment.
export PATH=\"$JENV_DIRECTORY/bin:\$PATH\"
eval \"\$(jenv  init -)\""

    if ! grep "$BASH_CONFIGS" < "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
            && . $LOCAL_BASH_CONFIG_FILE" \
            "jenv (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# JEnv - Manage your Java environment.
set -gx PATH \$PATH $JENV_DIRECTORY/bin"

    if ! grep "$FISH_CONFIGS" < "$LOCAL_FISH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "jenv (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_jenv() {

    # Install `jenv` and add the necessary
    # configs in the local shell config file.

    execute \
        "git clone --quiet $JENV_GIT_REPO_URL $JENV_DIRECTORY" \
        "jenv (install)" \
    && add_jenv_configs

}

update_jenv() {

    execute \
        "cd $JENV_DIRECTORY \
            && git fetch --quiet origin" \
        "jenv (upgrade)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n  jenv & Java\n\n"

    ask_for_sudo

    if [ ! -d "$JENV_DIRECTORY" ]; then
        install_jenv
    else
        update_jenv
    fi

}

main
