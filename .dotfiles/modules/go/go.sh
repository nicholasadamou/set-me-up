#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r GOENV_DIRECTORY="$HOME/.goenv"
declare -r GOENV_GIT_REPO_URL="https://github.com/syndbg/goenv.git"

declare -r GO_DIRECTORY="$HOME/go"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If needed, add the necessary configs in the
# local shell configuration files.
add_goenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# GoEnv - Like pyenv and rbenv, but for Go.
export GOENV_ROOT=\"$GOENV_DIRECTORY\"
export PATH=\"\$GOENV_ROOT/bin:\$PATH\"
eval \"\$(goenv init -)\""

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# GoEnv - Like pyenv and rbenv, but for Go.
set -gx GOENV_ROOT $GOENV_DIRECTORY
set -gx PATH \$PATH \$GOENV_ROOT/bin"

    if [ ! -e "$LOCAL_FISH_CONFIG_FILE" ] || ! grep -q "$(<<<"$FISH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_FISH_CONFIG_FILE" | tr '\n' '\01'); then
		printf '%s\n' "$FISH_CONFIGS" >> "$LOCAL_FISH_CONFIG_FILE"
    fi

}

# If needed, add the necessary configs in the
# local shell configuration files.
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


    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# Go Configurations
set -gx GOPATH $GO_DIRECTORY
set -gx GOBIN \$GOPATH/bin
set -gx PATH \$PATH \$GOPATH/bin"

    if [ ! -e "$LOCAL_FISH_CONFIG_FILE" ] || ! grep -q "$(<<<"$FISH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_FISH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$FISH_CONFIGS" >> "$LOCAL_FISH_CONFIG_FILE"
    fi

}

install_goenv() {

    # Install `goenv` and add the necessary
    # configs in the local shell config files.

    git clone --quiet "$GOENV_GIT_REPO_URL" "$GOENV_DIRECTORY" \
    && add_goenv_configs

}

update_goenv() {

    git -C"$GOENV_DIRECTORY" pull --quiet

}

install_latest_stable_go() {

    # Install `go` and add the necessary
    # configs in the local shell config file.

    local latest_version
    local current_version
    local go_is_not_installed

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `go` is installed

    if ! cmd_exists "go"; then
        go_is_not_installed=true
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
        ! "$go_is_not_installed" && {
            go version | \
            cut -d " " -f3 | \
            sed "s/go//g"
        }
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -d "$GOENV_DIRECTORY/versions/$latest_version" ] && [ "$current_version" != "$latest_version" ]; then
        . "$LOCAL_BASH_CONFIG_FILE" \
                && goenv install "$latest_version" \
                && goenv global "$latest_version" \
            && add_go_configs
    fi

}

install_go_packages() {

	go_install "github.com/jesseduffield/lazygit"
    go_install "go.coder.com/sshcode"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
