#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

readonly SMU_PATH="$HOME/set-me-up"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_bash_local() {

    declare -r FILE_PATH="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -e "$FILE_PATH" ]] || [[ -z "$FILE_PATH" ]]; then
        printf "%s\n" "#!/bin/bash" >> "$FILE_PATH"
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

    PATH_TO_FISH="$(which fish)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Add the path of the `fish` version installed through `Homebrew`
    # to the list of login shells from the `/etc/shells` file.
    #
    # This needs to be done because applications use this file to
    # determine whether a shell is valid (e.g.: `chsh` consults the
    # `/etc/shells` to determine whether an unprivileged user may
    # change the login shell for their own account).
    #
    # http://www.linuxfromscratch.org/blfs/view/7.4/postlfs/etcshells.html

    if ! grep -q "$(<<<"$PATH_TO_FISH" tr '\n' '\01')" < <(less "/etc/shells" | tr '\n' '\01'); then
        printf '%s\n' "$PATH_TO_FISH" | sudo tee -a /etc/shells &> /dev/null
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set latest version of `fish` as the default shell

    if [[ "$(getent passwd "$USER" | awk -F: '{print $NF}')" != "${PATH_TO_FISH}" ]]; then
		sudo usermod -s "$PATH_TO_FISH" "$USER" &> /dev/null
    fi

}


install_fisher() {

    if ! is_fisher_installed; then
        curl -Lo "$HOME"/.config/fish/functions/fisher.fish --create-dirs --silent https://git.io/fisher
    fi

}

install_fisher_packages() {

	cat < "$HOME/.config/fish/fishfile" | while read -r PACKAGE; do
		fisher_install "$PACKAGE"
	done

    fisher_update

}

install_oh_my_fish() {

	if ! is_omf_installed; then
		curl -L https://get.oh-my.fish > install
		fish -c "install --path=~/.local/share/omf --config=~/.config/omf"
		sudo rm -rf install
	fi

}

symlink() {

	# Get the absolute path of the .dotfiles directory.
    # This is only for aesthetic reasons to have an absolute symlink path instead of a relative one
    # <path-to-smu>/.dotfiles/somedotfile vs <path-to-smu>/.dotfiles/base/../somedotfile
    readonly dotfiles="${SMU_PATH}/.dotfiles"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Update and/or install dotfiles. These dotfiles are stored in the .dotfiles directory.
    # rcup is used to install files from the tag-specific dotfiles directory.
    # rcup is part of rcm, a management suite for dotfiles.
    # Check https://github.com/thoughtbot/rcm for more info.

    export RCRC="$dotfiles/rcrc" && \
            rcup -v -f -d "${dotfiles}"

}

install_space_vim() {

	curl -sLf https://spacevim.org/install.sh | bash

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

	apt_install_from_file "packages"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install thoughtbot/RCM for dotfile management.
    # see: https://github.com/thoughtbot/rcm#installation

    ! package_is_installed "rcm" && {
        wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
        echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
        sudo apt update
        sudo apt install -y "rcm"
    }

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# We must first create the $HOME/.bash.local configuration file
	# in order for the brew module to properly install Homebrew.
	create_bash_local

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # We must now symlink our dotfiles prior to executing any other function.
    # This is required because any further action will require our dotfiles
    # to be present in our $HOME directory.
    symlink

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    bash "${SMU_PATH}"/.dotfiles/modules/brew/brew.sh

	# Configure linuxbrew
	# see: https://docs.brew.sh/Homebrew-on-Linux#install

	test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
	test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

    brew_bundle_install "brewfile"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	create_fish_local

	change_default_shell_to_fish

    install_fisher

    install_fisher_packages

	install_oh_my_fish

	install_space_vim

}

main
