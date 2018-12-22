#!/bin/bash

# GitHub user/repo & branch value of your set-me-up blueprint (e.g.: nicholasadamou/set-me-up-blueprint/master).
# Set this value when the installer should additionally obtain your blueprint.
readonly SMU_BLUEPRINT=${SMU_BLUEPRINT:-""}
readonly SMU_BLUEPRINT_BRANCH=${SMU_BLUEPRINT_BRANCH:-""}

# The set-me-up version to download
readonly SMU_VERSION=${SMU_VERSION:-"master"}

# Where to install set-me-up
SMU_HOME_DIR=${SMU_HOME_DIR:-"${HOME}/set-me-up"}

readonly smu_download="https://github.com/nicholasadamou/set-me-up/archive/${SMU_VERSION}.zip"
readonly smu_blueprint_download="https://github.com/${SMU_BLUEPRINT}/tarball/${SMU_BLUEPRINT_BRANCH}"

function mkcd() {
    local -r dir="${1}"

    if [[ ! -d "${dir}" ]]; then
        mkdir "${dir}"
    fi

    cd "${dir}" || return
}

function is_git_repo() {
   [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) ]]
}

function has_submodules() {
    [ -f "$SMU_HOME_DIR"/.gitmodules ]
}

function are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}

install_xcode_command_line_tools() {
    # If necessary, prompt user to install
    # the `Xcode Command Line Tools`.

    echo "➜ Installing 'Xcode Command Line Tools'" 

    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the `Xcode Command Line Tools` are installed.

    until are_xcode_command_line_tools_installed; do
        sleep 5;
    done

    are_xcode_command_line_tools_installed && \
        echo "✔︎ 'Xcode Command Line Tools' is installed"
}

    install_submodules() {
        git -C "${SMU_HOME_DIR}" config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
            while read -r KEY MODULE_PATH
            do
                [ -d "$MODULE_PATH" ] && sudo rm -rf "$MODULE_PATH"

                NAME="$(echo "$KEY" | sed 's/\submodule\.\(.*\)\.path/\1/')"

                url_key="$(echo "$KEY" | sed 's/\.path/.url/')"
                branch_key="$(echo "$KEY" | sed 's/\.path/.branch/')"

                URL="$(git config -f .gitmodules --get "$url_key")"
                BRANCH="$(git config -f .gitmodules --get "$branch_key" || echo "master")"

                git -C "${SMU_HOME_DIR}" submodule add --force -b "$BRANCH" --name "$NAME" "$URL" "$MODULE_PATH" || continue
            done

        git -C "${SMU_HOME_DIR}" submodule update --init --recursive
    }

function confirm() {
    echo "➜ This script will download 'set-me-up' to ${SMU_HOME_DIR}"
    read -r -p "Would you like 'set-me-up' to configure in that directory? (y/n) " -n 1;
    echo "";

    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
}

function obtain() {
    local -r download_url="${1}"

    curl --progress-bar -L "${download_url}" | tar -x --strip-components 1 --exclude={README.md,LICENSE,.gitignore}
}

function use_curl() {
    confirm
    mkcd "${SMU_HOME_DIR}"

    echo -e "\n➜ Obtaining 'set-me-up'."
    obtain "${smu_download}"

    if [[ "${SMU_BLUEPRINT}" != "" ]]; then
        echo "➜ Obtaining your 'set-me-up' blueprint."
        obtain "${smu_blueprint_download}"
    fi

    echo -e "\n✔︎ Done. Enjoy."
}

function use_git() {
    confirm
    mkcd "${SMU_HOME_DIR}"

    echo -e "\n➜ Obtaining 'set-me-up'."
    obtain "${smu_download}"

    if [[ "${SMU_BLUEPRINT}" != "" ]]; then
        if is_git_repo; then
            echo "➜ Updating your 'set-me-up' blueprint."
            git pull --ff

            if has_submodules; then 
                git -C "${SMU_HOME_DIR}" submodule update --quiet --recursive
            fi
        else
            echo "➜ Cloning your 'set-me-up' blueprint."
            git init
            git remote add origin "https://github.com/${SMU_BLUEPRINT}.git"
            git fetch
            git checkout -f "${SMU_BLUEPRINT_BRANCH}"

            if has_submodules; then 
                install_submodules
            fi
        fi
    fi


    echo -e "\n✔︎ Done. Enjoy."
}

function main() {
    method="curl"

    if ! are_xcode_command_line_tools_installed; then 
        install_xcode_command_line_tools
    else
        echo "✔︎ (Xcode Command Line Tools) is already installed"
    fi

    while [[ $# -gt 0 ]]; do
        arguments="$1"
        case "$arguments" in
            --git)
                method="git"
                ;;
            --detect)
                if is_git_repo; then method="git"; fi
                ;;
            --latest)
                SMU_VERSION="master"
                ;;

        esac

        shift
    done

    case "${method}" in
        curl)
            ( use_curl )
            exit
            ;;
        git)
            ( use_git )
            exit
            ;;
    esac
}

main "$@"