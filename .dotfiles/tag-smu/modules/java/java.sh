#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

LOCAL_BASH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/bash.local"
LOCAL_FISH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/fish.local"

declare -r JENV_DIRECTORY="$HOME/.jenv"
declare -r JENV_GIT_REPO_URL="https://github.com/gcuisinier/jenv.git"

readonly java11=${java11:-"11.0.1-open"}

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

# If needed, add the necessary configs in the
# local shell configuration files.
add_jenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# JEnv - Manage your Java environment.
export PATH=\"$JENV_DIRECTORY/bin:\$PATH\"
eval \"\$(jenv  init -)\""

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
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

    if [ ! -e "$LOCAL_FISH_CONFIG_FILE" ] || ! grep -q "$(<<<"$FISH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_FISH_CONFIG_FILE" | tr '\n' '\01'); then
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "jenv (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_jenv() {

    # Install `jenv` and add the necessary
    # configs in the local shell config files.

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

    print_in_purple "  jenv & Java\n\n"

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

    printf "\n"

    sdk_install "java" "${java11}"

    set_default_sdk "java" "${java11}"

}

main
