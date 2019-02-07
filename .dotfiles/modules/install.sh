#!/bin/bash

# GitHub user/repo & branch value of your set-me-up blueprint (e.g.: nicholasadamou/set-me-up-blueprint/master).
# Set this value when the installer should additionally obtain your blueprint.
readonly SMU_BLUEPRINT=${SMU_BLUEPRINT:-""}
readonly SMU_BLUEPRINT_BRANCH=${SMU_BLUEPRINT_BRANCH:-""}

# The set-me-up version to download
# Available versions:
# 1. 'master' (MacOS)
# 2. 'debian'
readonly SMU_VERSION=${SMU_VERSION:-"debian"}

# A set of ignored paths that 'git' will ignore
# syntax: '<path>|<path>'
readonly SMU_IGNORED_PATHS="${SMU_IGNORED_PATHS:-""}"

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
	[ -d "${SMU_HOME_DIR}/.git" ] || [[ $(git -C "${SMU_HOME_DIR}" rev-parse --is-inside-work-tree 2> /dev/null) ]]
}

function has_remote_origin() {
	git -C "${SMU_HOME_DIR}" config --list | grep -qE 'remote.origin.url' 2> /dev/null
}

function has_submodules() {
    [ -f "${SMU_HOME_DIR}"/.gitmodules ]
}

function has_active_submodules() {
    git -C "${SMU_HOME_DIR}" config --list | grep -qE '^submodule' 2> /dev/null
}

function has_untracked_changes() {
   [[ $(git -C "${SMU_HOME_DIR}" diff-index HEAD -- 2> /dev/null) ]]
}

function does_repo_contain() {
	git -C "${SMU_HOME_DIR}" ls-files | grep -qE "$1" &> /dev/null
}

function is_git_repo_out_of_date() {
	UPSTREAM=${1:-'@{u}'}
	LOCAL=$(git -C "${SMU_HOME_DIR}" rev-parse @)
	REMOTE=$(git -C "${SMU_HOME_DIR}" rev-parse "$UPSTREAM")
	BASE=$(git -C "${SMU_HOME_DIR}" merge-base @ "$UPSTREAM")

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	[ "$LOCAL" = "$BASE" ] && [ "$LOCAL" != "$REMOTE" ]
}

function is_dir_empty() {
	ls -A "${SMU_HOME_DIR:?}/$1" &> /dev/null
}

function install_submodules() {
    git -C "${SMU_HOME_DIR}" config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
        while read -r KEY MODULE_PATH
        do
			if [ -d "${SMU_HOME_DIR:?}/${MODULE_PATH}" ] && ! is_dir_empty "${MODULE_PATH}" && does_repo_contain "${MODULE_PATH}"; then
				continue
			else
				[ -d "${SMU_HOME_DIR:?}/${MODULE_PATH}" ] && is_dir_empty "${MODULE_PATH}" && {
					rm -rf "${SMU_HOME_DIR:?}/${MODULE_PATH}"
				}

				NAME="$(echo "$KEY" | sed -e 's/submodule.//g' | sed -e 's/.path//g')"

				URL_KEY="$(echo "${KEY}" | sed 's/\.path$/.url/')"
				BRANCH_KEY="$(echo "${KEY}" | sed 's/\.path$/.branch/')"

				URL="$(git -C "${SMU_HOME_DIR}" config -f .gitmodules --get "${URL_KEY}")"
				BRANCH="$(git -C "${SMU_HOME_DIR}" config -f .gitmodules --get "${BRANCH_KEY}" || echo "master")"

				git -C "${SMU_HOME_DIR}" submodule add --force -b "${BRANCH}" --name "${NAME}" "${URL}" "${MODULE_PATH}" || continue
			fi
		done

	git -C "${SMU_HOME_DIR}" submodule update --init --recursive
}

function confirm() {
	if [ -n "$SMU_BLUEPRINT" ] && [ -n "$SMU_BLUEPRINT_BRANCH" ]; then
		echo "➜ This script will download '$SMU_BLUEPRINT' on branch '$SMU_BLUEPRINT_BRANCH' to ${SMU_HOME_DIR}"
	else
		echo "➜ This script will download 'set-me-up' to ${SMU_HOME_DIR}"
	fi

	read -r -p "Would you like 'set-me-up' to configure in that directory? (y/n) " -n 1;
    echo "";

    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
}

function obtain() {
	local -r download_url="${1}"

	curl --progress-bar -L "${download_url}" | \
		tar -xz --warning=no-timestamp --strip-components 1 \
		--exclude={README.md,LICENSE,.gitignore,.dotfiles/rcrc}
}

function setup() {
    confirm
    mkcd "${SMU_HOME_DIR}"

    echo -e "\n➜ Obtaining 'set-me-up'."
    obtain "${smu_download}"
    printf "\n"

	if ! is_git_repo; then
		git -C "${SMU_HOME_DIR}" init &> /dev/null

		# If (nicholasadamou/set-me-up) has submodules
		# make sure to install them prior to installing
		# set-me-up-blueprint submodules.

		if has_submodules; then
			# Store contents of (nicholasadamou/set-me-up) '.gitmodules' in variable
			# to later append to 'set-me-up-blueprint .gitmodules' if it exists.

			submodules="$(cat "${SMU_HOME_DIR}/.gitmodules")"

			# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

			echo "➜ Installing 'set-me-up' submodules."

			install_submodules

			printf "\n"
		fi
	fi

    if [[ "${SMU_BLUEPRINT}" != "" ]]; then
        if is_git_repo && has_remote_origin; then
			if has_untracked_changes; then
				files="$(git -C "${SMU_HOME_DIR}" status -s | \
					grep -v '?' | \
					sed 's/[AMCDRTUX]//g' | \
					xargs printf -- "${SMU_HOME_DIR}/%s\n" | \
					xargs | \
					grep -v "${SMU_IGNORED_PATHS}")"

				# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

				if [ -n "$files" ]; then
					git -C "${SMU_HOME_DIR}" \
						add "$files"

					git -C "${SMU_HOME_DIR}" \
						-c user.name="set-me-up" \
						-c user.email="set-me-up@gmail.com" \
						commit -m "✅ UPDATED: '$files'" &> /dev/null
				fi

				# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

				git -C "${SMU_HOME_DIR}" reset --hard HEAD &> /dev/null
			fi

			if is_git_repo_out_of_date "$SMU_BLUEPRINT_BRANCH"; then
				echo "➜ Updating your 'set-me-up' blueprint."

				git -C "${SMU_HOME_DIR}" pull --ff
			else
				echo "Already up-to-date"
			fi

			if has_submodules; then
				echo -e "\n➜ Updating your 'set-me-up' blueprint submodules."

				install_submodules

				git -C "${SMU_HOME_DIR}" submodule foreach git pull
			fi
        else
            echo "➜ Cloning your 'set-me-up' blueprint."

            git -C "${SMU_HOME_DIR}" remote add origin "https://github.com/${SMU_BLUEPRINT}.git"
            git -C "${SMU_HOME_DIR}" fetch
			git -C "${SMU_HOME_DIR}" checkout -f "${SMU_BLUEPRINT_BRANCH}"

			# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            if has_submodules; then
				echo -e "\n➜ Installing your 'set-me-up' blueprint submodules."

				# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

				# If '$submodules' is not empty, meaning,
				# (nicholasadamou/set-me-up) has submodules
				# append its contents to the set-me-up-blueprint
				#'.gitmodules' file.

				if [ -n "$submodules" ]; then
					if ! grep -q "$(<<<"$submodules" tr '\n' '\01')" < <(less "${SMU_HOME_DIR}/.gitmodules" | tr '\n' '\01'); then
						echo "$submodules" >> "${SMU_HOME_DIR}"/.gitmodules
						git -C "${SMU_HOME_DIR}" \
							-c user.name="set-me-up" \
							-c user.email="set-me-up@gmail.com" \
							commit -a -m "✅ UPDATED: '.gitmodules'" &> /dev/null
					fi
				fi

				# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

                install_submodules
            fi
        fi
    fi

    echo -e "\n✔︎ Done. Enjoy."
}

function main() {
    echo -e "Welcome to the 'set-me-up' installer.\nPlease follow the on-screen instructions.\n"

    setup
}

main "$@"
