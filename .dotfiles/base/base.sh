#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    . "$(readlink -f "${current_dir}/../utilities/utils.sh")"

readonly SMU_PATH="$HOME/set-me-up"
readonly SMU_URL="https://github.com/nicholasadamou/set-me-up"

readonly LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_homebrew() {

    printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
    #       └─ simulate the ENTER keypress

    print_result $? "Homebrew (install)"

}

add_brew_configs() {

    declare -r BASH_CONFIGS="
# Homebrew - The missing package manager for macOS.
export PATH=\"/usr/local/bin:\$PATH\"
export PATH=\"/usr/local/sbin:\$PATH\"
"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! grep "$BASH_CONFIGS" < "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
            && . $LOCAL_BASH_CONFIG_FILE" \
            "brew (update $LOCAL_BASH_CONFIG_FILE)"
    fi

}

get_homebrew_git_config_file_path() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if path="$(brew --repository 2> /dev/null)/.git/config"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Homebrew (get config file path)"
        return 1
    fi

}

opt_out_of_analytics() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Try to get the path of the `Homebrew` git config file.

    path="$(get_homebrew_git_config_file_path)" \
        || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Opt-out of Homebrew's analytics.
    # https://github.com/Homebrew/brew/blob/0c95c60511cc4d85d28f66b58d51d85f8186d941/share/doc/homebrew/Analytics.md#opting-out

    if [ "$(git config --file="$path" --get homebrew.analyticsdisabled)" != "true" ]; then
        git config --file="$path" --replace-all homebrew.analyticsdisabled true &> /dev/null
    fi

    print_result $? "Homebrew (opt-out of analytics)"

}

symlink() {

    # Update and/or install dotfiles. These dotfiles are stored in the .dotfiles directory.
    # rcup is used to install files from the tag-specific dotfiles directory.
    # rcup is part of rcm, a management suite for dotfiles.
    # Check https://github.com/thoughtbot/rcm for more info.

    # Get the absolute path of the .dotfiles directory.
    # This is only for aesthetic reasons to have an absolute symlink path instead of a relative one
    # <path-to-smu>/.dotfiles/somedotfile vs <path-to-smu>/.dotfiles/base/../somedotfile
    readonly dotfiles="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"

    export RCRC="../rcrc"
    rcup -v -d "${dotfiles}"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n  Base\n\n"

    if ! cmd_exists "brew"; then
        install_homebrew
        add_brew_configs
        opt_out_of_analytics
    else
        brew_upgrade
        brew_update
    fi

    print_in_yellow "\n   Cleanup\n\n"

    brew_cleanup

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n  Symlink dotfiles\n\n"

    symlink

}

main