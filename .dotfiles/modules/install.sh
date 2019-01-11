#!/bin/bash

# GitHub user/repo & branch value of your set-me-up blueprint (e.g.: nicholasadamou/set-me-up-blueprint/master).
# Set this value when the installer should additionally obtain your blueprint.
readonly SMU_BLUEPRINT=${SMU_BLUEPRINT:-""}
readonly SMU_BLUEPRINT_BRANCH=${SMU_BLUEPRINT_BRANCH:-""}

# The set-me-up version to download
readonly SMU_VERSION=${SMU_VERSION:-"debian"}

# Where to install set-me-up
SMU_HOME_DIR=${SMU_HOME_DIR:-"${HOME}/set-me-up"}

readonly smu_download="https://github.com/nicholasadamou/set-me-up/tarball/${SMU_VERSION}"
readonly smu_blueprint_download="https://github.com/${SMU_BLUEPRINT}/tarball/${SMU_BLUEPRINT_BRANCH}"

function mkcd() {
    local -r dir="${1}"

    if [[ ! -d "${dir}" ]]; then
        mkdir "${dir}"
    fi

    cd "${dir}" || return
}

function is_git_repo() {
   [[ $(git -C "${SMU_HOME_DIR}" rev-parse --is-inside-work-tree 2> /dev/null) ]]
}

function has_remote_origin() {
	[[ $(git -C "${SMU_HOME_DIR}" config --list | grep -q remote.origin.url 2> /dev/null) ]]
}

function has_submodules() {
    [ -f "$SMU_HOME_DIR"/.gitmodules ]
}

function has_active_submodules() {
    [[ $(git -C "${SMU_HOME_DIR}" config --list | grep -qE ^submodule 2> /dev/null) ]]
}

function has_untracked_changes() {
   [[ $(git -C "${SMU_HOME_DIR}" diff-index HEAD -- 2> /dev/null) ]]
}

function install_submodules() {
    git -C "${SMU_HOME_DIR}" config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
        while read -r KEY MODULE_PATH
        do
            has_active_submodules && \
                git -C "${SMU_HOME_DIR}" rm -r --cached "${MODULE_PATH}"

            ! has_active_submodules && [ -d "${MODULE_PATH}" ] && \
                rm -rf "${MODULE_PATH}"

            NAME="$(echo "$KEY" | sed -e 's/submodule.//g' | sed -e 's/.path//g')"

            URL_KEY="$(echo "${KEY}" | sed 's/\.path$/.url/')"
            BRANCH_KEY="$(echo "${KEY}" | sed 's/\.path$/.branch/')"

            URL="$(git -C "${SMU_HOME_DIR}" config -f .gitmodules --get "${URL_KEY}")"
            BRANCH="$(git -C "${SMU_HOME_DIR}" config -f .gitmodules --get "${BRANCH_KEY}" || echo "master")"

            git -C "${SMU_HOME_DIR}" submodule add --force -b "${BRANCH}" --name "${NAME}" "${URL}" "${MODULE_PATH}" || continue
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

	curl --progress-bar -L "${download_url}" | tar -xz --strip-components 1 --exclude={README.md,LICENSE,.gitignore,.dotfiles/rcrc}
}

function use_curl() {
    confirm
    mkcd "${SMU_HOME_DIR}"

    echo -e "\n➜ Obtaining 'set-me-up'."
    obtain "${smu_download}"
    printf "\n"

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
    printf "\n"

	if ! is_git_repo; then
		git -C "${SMU_HOME_DIR}" init &> /dev/null

		# If (nicholasadamou/set-me-up) has submodules
		# make sure to install them prior to installing
		# (nicholasadamou/dotfiles) submodules.

		if has_submodules; then
			echo "➜ Installing 'set-me-up' submodules."

			install_submodules
		fi
	fi

	printf "\n"

    if [[ "${SMU_BLUEPRINT}" != "" ]]; then
        if is_git_repo && has_remote_origin; then
            echo "➜ Updating your 'set-me-up' blueprint."

            if has_untracked_changes; then
				git -C "${SMU_HOME_DIR}" reset --hard HEAD
            fi

            git -C "${SMU_HOME_DIR}" pull --ff

            if has_submodules; then
				echo -e "\n➜ Updating 'set-me-up' blueprint submodules."

                git -C "${SMU_HOME_DIR}" submodule foreach git pull
            fi
        else
            echo "➜ Cloning your 'set-me-up' blueprint."
            git -C "${SMU_HOME_DIR}" remote add origin "https://github.com/${SMU_BLUEPRINT}.git"
            git -C "${SMU_HOME_DIR}" fetch
			git -C "${SMU_HOME_DIR}" checkout -f "${SMU_BLUEPRINT_BRANCH}"

            if has_submodules; then
				echo -e "\n➜ Installing 'set-me-up' blueprint submodules."

                install_submodules
            fi
        fi
    fi


    echo -e "\n✔︎ Done. Enjoy."
}

function main() {
    method="curl"

    echo -e "Welcome to the 'set-me-up' installer.\nPlease follow the on-screen instructions.\n"

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
                SMU_VERSION="debian"
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
