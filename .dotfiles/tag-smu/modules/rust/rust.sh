#!/bin/bash

echo "------------------------------"
echo "Running Rust module"
echo "------------------------------"
echo ""

# Install Rust with Cargo

echo "------------------------------"
echo "Installing Rust with Cargo"

if ! command -v "cargo" &>/dev/null; then
    curl https://sh.rustup.rs -sSf | sh
fi

# Install `cargo` packages

echo "------------------------------"
echo "Installing Cargo packages"

cargo install \
topgrade \
exa