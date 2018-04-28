#!/bin/bash

readonly python2="2.7.14"
readonly python3="3.6.5"

echo "------------------------------"
echo "Running python module"
echo "------------------------------"
echo ""

brew bundle install --file="./brewfile"

echo "------------------------------"
pyenv init

if [[ -z "${SMU_ZSH_DIR+x}" ]]; then
    echo "It looks like you are not using the set-me-up terminal module."
    echo "Please follow the pyenv instructions above (generated by the command 'pyenv init') to complete the installation."
    read -n 1 -s -r -p "Press any key to continue."
    echo ""
fi


echo "------------------------------"
echo "Installing python ${python2}"

pyenv install "${python2}" -s

echo "------------------------------"
echo "Installing python ${python3} and setting as global version"

pyenv install "${python3}" -s
pyenv global "${python3}"

pyenv rehash