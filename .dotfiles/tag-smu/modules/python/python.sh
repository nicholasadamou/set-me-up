#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

readonly SMU_PATH="$HOME/set-me-up"

LOCAL_BASH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/bash.local"
LOCAL_FISH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/fish.local"

declare -r PYENV_DIRECTORY="$HOME/.pyenv"
declare -r PYENV_INSTALLER_URL="https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_pyenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# PyEnv - Simple Python version management.
export PYENV_ROOT=\"$PYENV_DIRECTORY\"
export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
export PATH=\"\$PYENV_ROOT/shims:\$PATH\"
export PATH=\"$HOME/.local/bin:\$PATH\"
eval \"\$(pyenv init -)\""

    if ! grep "$BASH_CONFIGS" < "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
            && . $LOCAL_BASH_CONFIG_FILE" \
            "pyenv (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# PyEnv - Simple Python version management.
set -gx PYENV_ROOT $PYENV_DIRECTORY
set -gx PATH \$PATH \$PYENV_ROOT/bin
set -gx PATH \$PATH \$PYENV_ROOT/shims
set -gx PATH \$PATH $HOME/.local/bin"

    if ! grep "$FISH_CONFIGS" < "$LOCAL_FISH_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "pyenv (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_pyenv() {

    # Install `pyenv` and add the necessary
    # configs in the local shell config file.

    execute \
        "curl -sL $PYENV_INSTALLER_URL | bash" \
        "pyenv (install)" \
    && add_pyenv_configs

}

update_pyenv() {

    execute \
        ". $LOCAL_BASH_CONFIG_FILE \
            && pyenv update" \
        "pyenv (upgrade)"

}

install_pyenv_plugin() {

    print_in_yellow "\n   Install pyenv plugins\n\n"

    pyenv_install "https://github.com/momo-lab/pyenv-install-latest.git"

}

install_latest_stable_python() {

    # Install the latest stable version of Python
    # (this will also set it as the default).

    # Determine which version is the LTS version of Python
    # see: https://stackoverflow.com/a/33423958/5290011

    # Determine the current version of Python installed
    # see: https://stackoverflow.com/a/30261215/5290011

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `pyenv` is installed

    if ! cmd_exists "pyenv"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # shellcheck source=/dev/null
    latest_version="$(
        . "$LOCAL_BASH_CONFIG_FILE" \
        && pyenv install --list | \
        grep -v - | \
        grep -v b | \
        tail -1 | \
        tr -d '[:space:]'
    )"

    current_version="$(
        python -V 2>&1 | cut -d " " -f2
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ "$current_version" != "$latest_version" ] && [ ! -d "$PYENV_DIRECTORY/versions/$latest_version" ]; then
        execute \
            "sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target / \
                && . $LOCAL_BASH_CONFIG_FILE \
                && pyenv install $latest_version \
                && pyenv global $latest_version" \
            "pyenv (install python v$latest_version)"
    else
         print_success "(python) is already on the latest version"
    fi

}

install_pip() {

    print_in_yellow "\n   Install pip\n\n"

    if ! cmd_exists "pip"; then
        execute \
            "sudo easy_install pip" \
            "pip (install)"
    else
        print_success "(pip) is already installed"
    fi

}

install_pip_packages() {

    print_in_yellow "\n   Install pip packages\n\n"

    pip_install "cheat"
    pip_install "pip-review"
    pip_install "haxor-news"
    pip_install "howdoi"
    pip_install "glances"

}

install_pip3_packages() {

    print_in_yellow "\n   Install pip3 packages\n\n"

    pip3_install "pip-review"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  pyenv & Python\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    ask_for_sudo

    if [ ! -d "$PYENV_DIRECTORY" ]; then
        install_pyenv
    else
        update_pyenv
    fi

    install_pyenv_plugin

    printf "\n"

    install_latest_stable_python

    install_pip

    install_pip_packages

    install_pip3_packages

}

main
