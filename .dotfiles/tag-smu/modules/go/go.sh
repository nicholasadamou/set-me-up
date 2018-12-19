#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    . "$(readlink -f "${current_dir}/../utilities/utils.sh")"

LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"
LOCAL_FISH_CONFIG_FILE="$HOME/.fish.local"

declare -r GOENV_DIRECTORY="$HOME/.goenv"
declare -r GOENV_GIT_REPO_URL="https://github.com/syndbg/goenv.git"

declare -r GO_DIRECTORY="$HOME/go"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_goenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# GoEnv - Like pyenv and rbenv, but for Go.
export GOENV_ROOT=\"$GOENV_DIRECTORY\"
export PATH=\"\$GOENV_ROOT/bin:\$PATH\"
eval \"\$(goenv init -)\""

    if ! grep "$BASH_CONFIGS" < "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
            && . $LOCAL_BASH_CONFIG_FILE" \
            "goenv (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# GoEnv - Like pyenv and rbenv, but for Go.
set -gx GOENV_ROOT $GOENV_DIRECTORY
set -gx PATH \$PATH \$GOENV_ROOT/bin"

    if ! grep "$FISH_CONFIGS" < "$LOCAL_FISH_CONFIG_FILE" &> /dev/null; then
         execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "goenv (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

add_go_configs() {

    if [ ! -d "$GO_DIRECTORY" ] && [ ! -d "$GO_DIRECTORY"/bin ]; then
        mkdir -p "$GO_DIRECTORY"/bin
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # bash

    declare -r BASH_CONFIGS="
# Go Configurations
export GOPATH=\"$GO_DIRECTORY\"
export GOBIN=\"\$GOPATH/bin\"
export PATH=\"\$GOPATH/bin:\$PATH\""


    if ! grep "$BASH_CONFIGS" < "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
            && . $LOCAL_BASH_CONFIG_FILE" \
            "go (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# Go Configurations
set -gx GOPATH $GO_DIRECTORY
set -gx GOBIN \$GOPATH/bin
set -gx PATH \$PATH \$GOPATH/bin"

    if ! grep "$FISH_CONFIGS" < "$LOCAL_FISH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "go (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_goenv() {

    # Install `goenv` and add the necessary
    # configs in the local shell config file.

    execute \
        "git clone --quiet $GOENV_GIT_REPO_URL $GOENV_DIRECTORY" \
        "goenv (install)" \
    && add_goenv_configs

}

update_goenv() {

    execute \
        "cd $GOENV_DIRECTORY \
            && git pull --quiet" \
        "goenv (upgrade)"

}

install_latest_stable_go() {

    # Install `go` and add the necessary
    # configs in the local shell config file.

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `go` is installed

    if ! cmd_exists "go"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    local release_list="https://golang.org/doc/devel/release.html"

    latest_version="$(
        curl --silent $release_list | \
        grep -E -o 'go[0-9\.]+' | \
        grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | \
        sort -V | \
        uniq | \
        tail -1
    )"

    current_version="$(
        go version | \
        cut -d " " -f3 | \
        sed "s/go//g"
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! [ -d "$GOENV_DIRECTORY/versions/$latest_version" ]; then
        if [ "$current_version" != "$latest_version" ]; then
            execute \
                ". $LOCAL_BASH_CONFIG_FILE \
                    && goenv install $latest_version \
                    && goenv global $latest_version" \
                "goenv (install go v$latest_version)" \
                && add_go_configs
        else
            print_success "(go) is already on the latest version"
        fi
    fi

}

install_go_packages() {

    print_in_yellow "\n   Install go packages\n\n"

    go_install "github.com/jesseduffield/lazygit"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   goenv & Go\n\n"

    print_in_yellow "   Install brew packages\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    ask_for_sudo

    if [ ! -d "$GOENV_DIRECTORY" ]; then
        install_goenv
    else
        update_goenv
    fi

    install_latest_stable_go

    install_go_packages

}

main