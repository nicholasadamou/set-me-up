#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

readonly SMU_PATH="$HOME/set-me-up"

LOCAL_BASH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/bash.local"
LOCAL_FISH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/fish.local"

declare -r RBENV_DIRECTORY="$HOME/.rbenv"
declare -r RBENV_GIT_REPO_URL="https://github.com/rbenv/rbenv.git"
declare -r RUBY_BUILD_DIRECTORY="$RBENV_DIRECTORY/plugins/ruby-build"
declare -r RUBY_BUILD_GIT_REPO_URL="https://github.com/rbenv/ruby-build.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If needed, add the necessary configs in the
# local shell configuration files.
add_rbenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# Rbenv - Groom your app’s Ruby environment.
export RBENV_ROOT=\"$RBENV_DIRECTORY\"
export PATH=\"\$RBENV_ROOT/bin:\$PATH\"
eval \"\$(rbenv init -)\""

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
                && . $LOCAL_BASH_CONFIG_FILE" \
            "rbenv (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# Rbenv - Groom your app’s Ruby environment.
set -gx RBENV_ROOT $RBENV_DIRECTORY
set -gx PATH \$PATH \$RBENV_ROOT/bin"

    if [ ! -e "$LOCAL_FISH_CONFIG_FILE" ] || ! grep -q "$(<<<"$FISH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_FISH_CONFIG_FILE" | tr '\n' '\01'); then
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "rbenv (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_rbenv() {

    # Install `rbenv` and add the necessary
    # configs in the local shell config files.

    execute \
        "git clone --quiet $RBENV_GIT_REPO_URL $RBENV_DIRECTORY" \
        "rbenv (install)" \
    && add_rbenv_configs

}

update_rbenv() {

    if [ -d "$RBENV_DIRECTORY" ]; then
        execute \
            "cd $RBENV_DIRECTORY \
                && git fetch --quiet origin" \
            "rbenv (upgrade)"
    else
        upgrade_package "rbenv" "rbenv"
    fi

}

install_ruby_build() {

    # Install `ruby-build`

    execute \
        "git clone --quiet $RUBY_BUILD_GIT_REPO_URL $RUBY_BUILD_DIRECTORY" \
        "ruby-build (install)"

}

install_latest_stable_ruby() {

    # Install the latest stable version of Ruby
    # (this will also set it as the default).

    # Determine which version is the LTS version of ruby
    # see: https://stackoverflow.com/a/30191850/5290011

    # Determine the current version of Ruby installed
    # see: https://stackoverflow.com/a/51285042/5290011

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `rbenv` is installed

    if ! cmd_exists "rbenv"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    latest_version="$(
        . "$LOCAL_BASH_CONFIG_FILE" \
        && rbenv install -l | \
        grep -v - | \
        tail -1 | \
        tr -d '[:space:]'
    )"

    current_version="$(
        ruby -e "puts RUBY_VERSION"
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ "$current_version" != "$latest_version" ]; then
        execute \
            ". $LOCAL_BASH_CONFIG_FILE \
                && rbenv install $latest_version \
                && rbenv global $latest_version" \
            "rbenv (install ruby v$latest_version)"
    else
         print_success "(ruby) is already on the latest version"
    fi

}

install_ruby_gems() {

    print_in_yellow "\n   Install ruby gems\n\n"

    gem_install "bundler"
    gem_install "tmuxinator"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  rbenv & Ruby\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    ask_for_sudo

    if [ ! -d "$RBENV_DIRECTORY" ] && ! cmd_exists "rbenv"; then
        install_rbenv
        install_ruby_build
    else
        update_rbenv
    fi

    install_latest_stable_ruby

    install_ruby_gems

}

main
