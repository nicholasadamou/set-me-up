#!/bin/bash

readonly fish_executable=${fish_executable:-"/usr/local/bin/fish"}
readonly iterm2_settings=${iterm2_settings:-"${HOME}/Library/Preferences/com.googlecode.iterm2.plist"}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# fish-shell helper functions

fish_cmd_exists() {

    fish -c "$1 -v" &> /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Oh-My-Fish helper functions

is_omf_installed() {

    if ! fish_cmd_exists "omf" && [ ! -d "$HOME/.local/share/omf" ] && [ ! -d "$HOME/.config/omf" ]; then
        return 1
    fi

}

is_omf_pkg_installed() {

   fish -c "omf list | grep $1" &> /dev/null

}

omf_install() {

    declare -r PACKAGE="$1"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `omf` is installed.

    is_omf_installed || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install the specified package.

    if ! is_omf_pkg_installed "$PACKAGE"; then
        fish -c "omf install $PACKAGE"
    fi

}

omf_update() {

    # Check if `omf` is installed.

    is_omf_installed || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Update package(s)

    fish -c "omf update"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Fisherman helper functions

is_fisher_installed() {

    if ! fish_cmd_exists "fisher"; then
        return 1
    fi

}

is_fisher_pkg_installed() {

    fish -c "fisher ls | grep $1" &> /dev/null

}

fisher_install() {

    declare -r PACKAGE

    PACKAGE="$(echo "$1" | cut -d '/' -f 2)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `fisher` is installed.

    is_fisher_installed || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install the specified package.

    if ! is_fisher_pkg_installed "$PACKAGE"; then
        fish -c "fisher $PACKAGE"
    fi

}

fisher_update() {

    # Check if `fisher` is installed.

    is_fisher_installed || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Update package(s)

    fish -c "fisher up"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Tacklebox helper functions

is_tacklebox_installed() {

    if ! [ -d "$HOME/.tacklebox" ] && ! [ -d "$HOME/.tackle" ]; then
        return 1
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "------------------------------"
echo "Setting up fish-shell."
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install fish-shell

if ! grep -q "${fish_executable}" "/etc/shells"; then
    echo "${fish_executable}" | sudo tee -a /etc/shells
fi

if [[ $SHELL != "${fish_executable}" ]]; then
    echo "------------------------------"
    echo "Setting fish as default shell..."
    chsh -s "${fish_executable}"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Oh-My-Fish

echo "------------------------------"
echo "Installing Oh-My-Fish"

is_omf_installed || {

    curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > install \
        && chmod +x install \
        && ./install --noninteractive --path="$HOME"/.local/share/omf --config="$HOME"/.config/omf \
        && rm -rf install

}

# Install Oh-My-Fish packages

echo "------------------------------"
echo "Installing Oh-My-Fish packages"

omf_install "z"
omf_install "simple-ass-prompt"


# Update Oh-My-Fish

echo "------------------------------"
echo "Updating Oh-My-Fish"

omf_update

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Fisherman

echo "------------------------------"
echo "Installing Fisherman"

is_fisher_installed || {

    curl -Lo "$HOME"/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

}

# Install Fisherman packages

echo "------------------------------"
echo "Installing Fisherman packages"

fisher_install "edc/bass"
fisher_install "fzf"
fisher_install "fzy"
fisher_install "z"
fisher_install "fnm"
fisher_install "gitignore"
fisher_install "joseluisq/gitnow"
fisher_install "laughedelic/brew-completions"
fisher_install "rbenv"
fisher_install "pyenv"
fisher_install "yamadayuki/goenv"
fisher_install "nodenv"

# Update Fisherman

echo "------------------------------"
echo "Updating Fisherman"

fisher_update

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Tacklebox

echo "------------------------------"
echo "Installing Tacklebox"

is_tacklebox_installed || {

    git clone https://github.com/justinmayer/tacklebox "$HOME"/.tacklebox \
        && git clone https://github.com/justinmayer/tackle "$HOME"/.tackle

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Update fish-shell

echo "------------------------------"
echo "Updating fish-shell"

fish -c "fish_update_completions"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "------------------------------"
echo "Configuring iTerm2"

sudo ln -sf iTerm2/com.googlecode.iterm2.plist "${iterm2_settings}"