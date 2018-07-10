#!/bin/bash

readonly SMU_PATH="$HOME/set-me-up"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [[ $(command -v brew) == "" ]]; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating homebrew..."
    brew update
fi

echo "------------------------------"
echo "Updating and/or installing submodules"
echo "------------------------------"

cd "${SMU_PATH}" \
    && git submodule update --quiet --init --recursive \
    && git submodule foreach git pull origin master

if [[ $(command -v rcup) == "" ]]; then

    echo "------------------------------"
    echo "Installing rcm suite"

    brew bundle install -v --file="./brewfile"
fi

echo "------------------------------"
echo "Updating and/or installing dotfiles"
echo "------------------------------"

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
