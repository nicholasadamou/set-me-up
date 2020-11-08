#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r N_DIRECTORY="$HOME/n"
declare -r NVM_DIRECTORY="$HOME/.nvm"

declare -r N_URL="https://git.io/n-install"
declare -r NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If needed, add the necessary configs in the
# local shell configuration files.
add_n_configs() {

    # bash

    declare -r BASH_CONFIGS="
# n - Node version management.
export N_PREFIX=\"\$HOME/n\";
[[ :\$PATH: == *\":\$N_PREFIX/bin:\"* ]] || PATH+=\":\$N_PREFIX/bin\"
"

    if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# n - Node version management.
set -xU N_PREFIX \"\$HOME/n\"
set -U fish_user_paths \"\$N_PREFIX/bin\" \$fish_user_paths
"

    if [[ ! -e "$LOCAL_FISH_CONFIG_FILE" ]] || ! grep -q -z "$FISH_CONFIGS" "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then
        printf '%s\n' "$FISH_CONFIGS" >> "$LOCAL_FISH_CONFIG_FILE"
    fi

}

# If needed, add the necessary configs in the
# local shell configuration files.
add_nvm_configs() {

    # bash

    declare -r BASH_CONFIGS="
# nvm - Node version management.
export NVM_DIR=\"$HOME/.nvm\"
[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"  # This loads nvm
[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"  # This loads nvm bash_completion
"

    if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi

}

install_n() {

    # Install `n` and add the necessary
    # configs in the local shell config files.

    curl -sL "$N_URL" | N_PREFIX="$N_DIRECTORY" bash -s -- -q -n\
        && add_n_configs

}

install_nvm() {

    # Install `nvm` and add the necessary
    # configs in the local shell config files.

    curl -o- "$NVM_URL" | bash -s -- -q \
        && add_nvm_configs

}


update_n() {

    . "$LOCAL_BASH_CONFIG_FILE" \
            && n-update -y

}

update_nvm() {

    . "$LOCAL_BASH_CONFIG_FILE" && \
		(
			git -C "$NVM_DIR" fetch --tags origin && \
			git -C "$NVM_DIR" checkout \
				"$(git -C "$NVM_DIR" describe --abbrev=0 --tags --match \"v[0-9]*\" "$(git -C "$NVM_DIR" rev-list --tags --max-count=1)")" \
		) && \
	. "$NVM_DIR/nvm.sh" -q

}

install_latest_stable_node_with_n() {

    # Install the latest stable version of Node
    # (this will also set it as the default).

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `n` is installed

    if ! cmd_exists "n"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    latest_version="$(
     . "$LOCAL_BASH_CONFIG_FILE" && \
        n --lts
    )"

	if cmd_exists "node"; then
		current_version="$(
			node -v | \
			cut -d "v" -f 2
		)"
	fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -d "$N_DIRECTORY/n/versions/node/$latest_version" ]] && [[ "$current_version" != "$latest_version" ]]; then
        . "$LOCAL_BASH_CONFIG_FILE" && \
                sudo n lts
    fi

}

install_latest_stable_node_with_nvm() {

    # Install the latest stable version of Node
    # (this will also set it as the default).

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `n` is installed

    if ! cmd_exists "nvm"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    latest_version="$(
     . "$LOCAL_BASH_CONFIG_FILE" && \
        nvm ls stable | xargs | cut -d ' ' -f 2
    )"

    current_version="$(
        node -v
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -d "$NVM_DIRECTORY/versions/node/$latest_version" ]] && [[ "$current_version" != "$latest_version" ]]; then
        . "$LOCAL_BASH_CONFIG_FILE" && \
                sudo nvm install --lts
    fi

}

install_npm_packages() {

    # working with npm
    npx_install "npm-check"
    npx_install "yarn-check"
    npx_install "np"
    npx_install "npm-name-cli"

    # package managers
    npx_install "yarn"
    npx_install "bower"
    npx_install "pnpm"
    npx_install "parcel-bundler"

    # useful binaries
    npx_install "md-to-pdf"
    npx_install "favicon-emoji"
    npx_install "tldr"
    npx_install "emma-cli"
    npx_install "@rafaelrinaldi/whereami"
    npx_install "create-dmg"
    npx_install "castnow"
    npx_install "gitmoji-cli"
    npx_install "fx"
    npx_install "screenshoteer"
    npx_install "how-2"
    npx_install "undollar"

    # process management
    npx_install "fkill-cli"
    npx_install "gtop"
    npx_install "vtop"

    # fonts
    npx_install "google-font-installer"

    # directory management
    npx_install "empty-trash-cli"
    npx_install "spot"

    # version control
    npx_install "ghub"
    npx_install "ghwd"
    npx_install "github-is-starred-cli"

    # wallpaper management
    npx_install "wallpaper-cli"
    npx_install "splash-cli"

    # linters
    npx_install "eslint"
    npx_install "eslint-config-standard"

    # deployment
    npx_install "netlify-cli"
    npx_install "surge"
    npx_install "now"

    # task runneries
    npx_install "gulp-cli"

    # networking
    npx_install "wt-cli"
    npx_install "speed-test"
    npx_install "is-up-cli"
    npx_install "localtunnel"
    npx_install "spoof"
    npx_install "http-server"

    # javascript packages
    npx_install "next"
    npx_install "nodemon"

    # vue packages
    npx_install "@vue/cli"

    # react packages
    npx_install "create-react-app"
    npx_install "create-react-library"
    npx_install "react-native-cli"

    # database packages
    npx_install "prisma"
    npx_install "graphql-cli"
    npx_install "firebase-tools"

    # continuous integration (CI) bots
    npx_install "snyk"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # if [[ ! -d "$N_DIRECTORY" ]] && ! cmd_exists "n"; then
    #     install_n
    # else
    #     update_n
    # fi

	# if [[ ! -d "$NVM_DIRECTORY" ]] && ! cmd_exists "nvm"; then
    #     install_nvm
    # else
    #     update_nvm
    # fi

    brew_bundle_install "brewfile"

    install_latest_stable_node_with_n

	# install_latest_stable_node_with_nvm

    # install_npm_packages

}

main
