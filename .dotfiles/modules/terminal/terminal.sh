#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

declare LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

change_default_bash() {

    local configs=""
    local pathConfig=""

    local newShellPath=""
    local brewPrefix=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Try to get the path of the `Bash`
    # version installed through `Homebrew`.

    brewPrefix="$(brew --prefix)"

    pathConfig="PATH=\"$brewPrefix/bin:\$PATH\""
    configs="# Homebrew bash configurations
$pathConfig
export PATH"

    newShellPath="$brewPrefix/bin/bash"

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

    if ! grep -q "$(<<<"$newShellPath" tr '\n' '\01')" < <(less "/etc/shells" | tr '\n' '\01'); then
        printf '%s\n' "$newShellPath" | sudo tee -a /etc/shells
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set latest version of `Bash` as the default
    # (macOS uses by default an older version of `Bash`).

    if [ "$(dscl . -read /Users/"${USER}"/ UserShell | cut -d ' ' -f2)" != "${newShellPath}" ]; then
        chsh -s "$newShellPath" &> /dev/null
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If needed, add the necessary configs in the
    # local shell configuration file.

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$configs" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$configs" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi

}

# see: https://github.com/oh-my-fish/oh-my-fish/issues/189
install_omf() {

    if ! is_omf_installed; then
		# Make sure '$HOME/.local/share/omf' does not exist prior
		# to 'omf' installation.

		if [ -d "$HOME/.local/share/omf" ]; then
			sudo rm -rf "$HOME/.local/share/omf"
		fi

		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        fish <(curl -Ls https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install) \
				--noninteractive --yes --path="$HOME"/.local/share/omf --config="$HOME"/.config/omf
    fi

}

install_omf_packages() {

	omf_install "z"
    omf_install "thefuck"

    omf_update

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

main() {

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    change_default_bash

    install_omf

    install_omf_packages

    install_fisher

    install_fisher_packages

}

main
