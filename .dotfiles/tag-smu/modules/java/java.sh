#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "../utilities/utils.sh"

LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"
LOCAL_FISH_CONFIG_FILE="$HOME/.fish.local"

declare -r JENV_DIRECTORY="$HOME/.jenv"
declare -r JENV_GIT_REPO_URL="https://github.com/gcuisinier/jenv.git"

readonly java8=${java8:-"8.0.171-oracle"}
readonly java10=${java10:-"10.0.1-oracle"}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_sdkman() {

    # Install `sdkman` and source the necessary shell scripts.

    execute \
        "curl -s \"https://get.sdkman.io\" | bash" \
        "sdkman (install)" \
        && [ -d "$HOME"/.sdkman ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

}

update_sdkman() {

    execute \
        "sdk selfupdate force" \
        "sdkman (update)"

}

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

    print_in_yellow "   Install brew packages\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    

    ask_for_sudo

    if [ ! -d "$JENV_DIRECTORY" ]; then
        install_jenv
    else
        update_jenv
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n  sdkman\n\n"

    if ! is_sdkman_installed; then
        install_sdkman
    else
        update_sdkman
    fi

    sdk_install "java" "${java8}"
    sdk_install "java" "${java10}"

    set_default_sdk "java" "${java8}"
 
}

main
