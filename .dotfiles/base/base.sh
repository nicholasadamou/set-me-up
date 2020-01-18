#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

readonly SMU_PATH="$HOME/set-me-up"

declare LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"

declare -r VUNDLE_DIR="$HOME/.vim/plugins/Vundle.vim"
declare -r VUNDLE_GIT_REPO_URL="https://github.com/VundleVim/Vundle.vim.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Overrides `utils.sh` -> print_question()
# in order to add a few more spaces b/w '[?]'
# & the left-most edge of the terminal window.
print_question() {

    print_in_yellow "     [?] $1"

}

create_bash_local() {

    declare -r FILE_PATH="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
        printf "%s\n" "#!/bin/bash" >> "$FILE_PATH"

        print_result $? "$FILE_PATH"
    else
        print_success "($FILE_PATH) already exists."
    fi

}


create_fish_local() {

    declare -r FILE_PATH="$HOME/.fish.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
        touch "$FILE_PATH"

        print_result $? "$FILE_PATH"
    else
        print_success "($FILE_PATH) already exists."
    fi

}

create_gitconfig_local() {

    declare -r FILE_PATH="$HOME/.gitconfig.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then

        if [ "$(git -C "$SMU_PATH" config --global --get user.name)" = "" ] && [ "$(git -C "$SMU_PATH" config --global --get user.email)" = "" ]; then
            print_in_yellow "\n   Git Configuration\n\n"

            ask "What is your name? [e.g. John Smith]: "; NAME="$(get_answer)"
            ask "What is your email address? [e.g. johnsmith@gmail.com]: "; EMAIL="$(get_answer)"

            printf "\n"
        fi

        printf "%s\n" \
"[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/
    # gpgsign = true
[user]

    name = $NAME
    email = $EMAIL
    # signingkey =" \
        >> "$FILE_PATH"

        print_result $? "$FILE_PATH"
    else
        print_success "($FILE_PATH) already exists."
    fi

}

create_vimrc_local() {

    declare -r FILE_PATH="$HOME/.vimrc.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
        touch "$FILE_PATH"

        print_result $? "$FILE_PATH"
    else
        print_success "($FILE_PATH) already exists."
    fi

}


install_homebrew() {

    printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
    #       └─ simulate the ENTER keypress

    print_result $? "Homebrew (install)" && \
        add_brew_configs

}

add_brew_configs() {

    declare -r BASH_CONFIGS="
# Homebrew - The missing package manager for macOS.
export PATH=\"/usr/local/bin:\$PATH\"
export PATH=\"/usr/local/sbin:\$PATH\"
"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If needed, add the necessary configs in the
    # local shell configuration file.

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
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
    readonly dotfiles="${SMU_PATH}/.dotfiles"

    execute \
        "export RCRC=\"$dotfiles/rcrc\" && \
            rcup -v -f -d \"${dotfiles}\"" \
        "symlink (${dotfiles})"

}

install_plugins() {

    # Make sure 'backups', 'swaps' & 'undos' directories exist.
    # If not, create them.

    [ ! -d "$HOME/.vim/backups" ] && \
        mkdir -p "$HOME/.vim/backups"

    [ ! -d "$HOME/.vim/swaps" ] && \
        mkdir -p "$HOME/.vim/swaps"

    [ ! -d "$HOME/.vim/undos" ] && \
        mkdir -p "$HOME/.vim/undos"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install plugins.

    execute \
        "git clone --quiet '$VUNDLE_GIT_REPO_URL' '$VUNDLE_DIR' \
            && printf '\n' | vim +PluginInstall +qall" \
        "vim (install plugins)" \
        || return 1

}

update_plugins() {

    execute \
        "vim +PluginUpdate +qall" \
        "vim (update plugins)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  Base\n"

    print_in_yellow "\n   Create local config files\n\n"

    create_bash_local
    create_fish_local
    create_gitconfig_local
    create_vimrc_local

    print_in_yellow "\n   Homebrew\n\n"

    ask_for_sudo

    if ! cmd_exists "brew"; then
        install_homebrew
        opt_out_of_analytics
    else
        brew_upgrade
        brew_update
    fi

    printf "\n"

    brew_bundle_install "brewfile"

    print_in_yellow "\n   Cleanup\n\n"

    brew_cleanup

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_yellow "\n   Symlink dotfiles\n\n"

    symlink

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_yellow "\n   Vim\n\n"

    if [ ! -d "$VUNDLE_DIR" ]; then
        install_plugins
    else
        update_plugins
    fi

}

main
