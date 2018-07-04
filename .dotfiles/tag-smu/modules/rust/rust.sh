#!/bin/bash

echo "------------------------------"
echo "Running Rust module"
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing Rust with Cargo"

if ! command -v "cargo" &>/dev/null; then
    curl https://sh.rustup.rs -sSf | sh
fi

echo "------------------------------"
echo "Installing Cargo packages"

cargo install topgrade
