#!/bin/bash

echo "------------------------------"
echo "Running Essentials module"
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing essential homebrew formulae and apps."
echo "This might awhile to complete because some formulae need to be installed from source."
echo "------------------------------"
echo ""

# Install `brew` dependencies

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"
