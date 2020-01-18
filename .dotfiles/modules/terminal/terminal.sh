#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

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
        execute \
            "printf '%s\n' '$newShellPath' | sudo tee -a /etc/shells" \
            "Bash (add '$newShellPath' in '/etc/shells')"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set latest version of `Bash` as the default
    # (macOS uses by default an older version of `Bash`).

    if [ "$(dscl . -read /Users/"${USER}"/ UserShell | cut -d ' ' -f2)" != "${newShellPath}" ]; then
        chsh -s "$newShellPath" &> /dev/null
        print_result $? "Bash (use latest version)"
    else
        print_success "(bash) is already on the latest version"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If needed, add the necessary configs in the
    # local shell configuration file.

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$configs" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        execute \
            "printf '%s\n' '$configs' >> $LOCAL_BASH_CONFIG_FILE \
                && . $LOCAL_BASH_CONFIG_FILE" \
            "Bash (update $LOCAL_BASH_CONFIG_FILE)"
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

        execute \
            "fish <(curl -Ls https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install) \
				--noninteractive --yes --path=$HOME/.local/share/omf --config=$HOME/.config/omf" \
            "omf (install)"
    else
        print_success "(omf) is already installed."
    fi

}

install_omf_packages() {

    print_in_yellow "\n  Install omf packages\n\n"

	omf_install "z"
    omf_install "thefuck"

    printf "\n"

    omf_update

}

install_fisher() {

    if ! is_fisher_installed; then
        execute \
            "curl -Lo $HOME/.config/fish/functions/fisher.fish --create-dirs --silent https://git.io/fisher" \
            "fisher (install)"
    else
        print_success "(fisher) is already installed."
    fi

}

install_fisher_packages() {

    print_in_yellow "\n   Install fisher packages\n\n"

    does_fishfile_exist && {
        cat < "$HOME/.config/fish/fishfile" | while read -r PACKAGE; do
            fisher_install "$PACKAGE"
        done
    }

    printf "\n"

    fisher_update

}

main() {

    print_in_purple "  Terminal\n\n"

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_yellow "\n   Upgrade bash\n\n"

    change_default_bash

	printf "\n"

    install_omf

    install_omf_packages

    printf "\n"

    install_fisher

    install_fisher_packages

}

main
