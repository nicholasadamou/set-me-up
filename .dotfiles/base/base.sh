#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

readonly SMU_PATH="$HOME/set-me-up"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_homebrew() {

    printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

}

get_homebrew_git_config_file_path() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if path="$(brew --repository 2> /dev/null)/.git/config"; then
        printf "%s" "$path"
        return 0
    else
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

    if [[ "$(git config --file="$path" --get homebrew.analyticsdisabled)" != "true" ]]; then
        git config --file="$path" --replace-all homebrew.analyticsdisabled true &> /dev/null
    fi

}

create_bash_local() {

    declare -r FILE_PATH="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -e "$FILE_PATH" ]] || [[ -z "$FILE_PATH" ]]; then
        printf "%s\n" "#!/bin/bash" >> "$FILE_PATH"
	fi

}

change_default_bash_version() {

    local PATH_TO_HOMEBREW_BASH=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Get the path of the `Bash` version installed through `Homebrew`.

    PATH_TO_HOMEBREW_BASH="$(brew --prefix)/bin/bash"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Add the path of the `Bash` version installed through `Homebrew`
    # to the list of login shells from the `/etc/shells` file.
    #
    # This needs to be done because applications use this file to
    # determine whether a shell is valid (e.g.: `chsh` consults the
    # `/etc/shells` to determine whether an unprivileged user may
    # change the login shell for their own account).
    #
    # http://www.linuxfromscratch.org/blfs/view/7.4/postlfs/etcshells.html

    if ! grep -q "$(<<<"$PATH_TO_HOMEBREW_BASH" tr '\n' '\01')" < <(less "/etc/shells" | tr '\n' '\01'); then
        printf '%s\n' "$PATH_TO_HOMEBREW_BASH" | sudo tee -a /etc/shells
    fi

}

create_fish_local() {

    declare -r FILE_PATH="$HOME/.fish.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -e "$FILE_PATH" ]] || [[ -z "$FILE_PATH" ]]; then
        touch "$FILE_PATH"
	fi

}

change_default_shell_to_fish() {

    local PATH_TO_FISH=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Get the path of `fish` which was installed through `Homebrew`.

    PATH_TO_FISH="$(brew --prefix)/bin/fish"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set latest version of `fish` as the default shell

    if [[ "$(dscl . -read /Users/"${USER}"/ UserShell | cut -d ' ' -f2)" != "${$PATH_TO_FISH}" ]]; then
        chsh -s "$PATH_TO_FISH" &> /dev/null
    fi

}


install_fisher() {

    if ! is_fisher_installed; then
        curl -Lo "$HOME"/.config/fish/functions/fisher.fish --create-dirs --silent https://git.io/fisher
    fi

}

install_fisher_packages() {

	does_fishfile_exist && {
        cat < "$HOME/.config/fish/fishfile" | while read -r PACKAGE; do
            fisher_install "$PACKAGE"
        done
    }

    fisher_update

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

    export RCRC="$dotfiles/rcrc" && \
            rcup -v -f -d "${dotfiles}"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    bash ${SMU_PATH}/.dotfiles/modules/brew/brew.sh

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	create_bash_local

	change_default_bash_version

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	create_fish_local

	change_default_shell_to_fish

    install_fisher

    install_fisher_packages

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    symlink

}

main
