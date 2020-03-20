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
declare -r NVM_URL="https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh"

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
    npm_install "npm-check"
    npm_install "yarn-check"
    npm_install "np"
    npm_install "npm-name-cli"

    # package managers
    npm_install "yarn"
    npm_install "bower"
    npm_install "pnpm"
    npm_install "parcel-bundler"

    # useful binaries
    npm_install "md-to-pdf"
    npm_install "favicon-emoji"
    npm_install "tldr"
    npm_install "emma-cli"
    npm_install "@rafaelrinaldi/whereami"
    npm_install "castnow"
    npm_install "gitmoji-cli"
    npm_install "fx"
    npm_install "screenshoteer"
    npm_install "how-2"
    npm_install "undollar"

    # process management
    npm_install "fkill-cli"
    npm_install "gtop"
    npm_install "vtop"

    # fonts
    npm_install "google-font-installer"

    # directory management
    npm_install "empty-trash-cli"
    npm_install "spot"

    # version control
    npm_install "ghub"
    npm_install "ghwd"
    npm_install "github-is-starred-cli"

    # wallpaper management
    npm_install "wallpaper-cli"
    npm_install "splash-cli"

    # linters
    npm_install "eslint"
    npm_install "eslint-config-standard"

    # deployment
    npm_install "netlify-cli"
    npm_install "surge"
    npm_install "now"

    # task runneries
    npm_install "gulp-cli"

    # networking
    npm_install "wt-cli"
    npm_install "speed-test"
    npm_install "is-up-cli"
    npm_install "localtunnel"
    npm_install "spoof"
    npm_install "http-server"

    # javascript packages
    npm_install "next"
    npm_install "nodemon"

    # vue packages
    npm_install "@vue/cli"

    # react packages
    npm_install "create-react-app"
    npm_install "create-react-library"
    npm_install "react-native-cli"

    # database packages
    npm_install "prisma"
    npm_install "graphql-cli"
    npm_install "firebase-tools"

    # continuous integration (CI) bots
    npm_install "snyk"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    apt_install_from_file "packages"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

     if [[ ! -d "$N_DIRECTORY" ]] && ! cmd_exists "n"; then
         install_n
     else
         update_n
     fi

    install_latest_stable_node_with_n

    install_npm_packages

}

main
