#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

readonly SMU_PATH="$HOME/set-me-up"

LOCAL_BASH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/bash.local"
LOCAL_FISH_CONFIG_FILE="${SMU_PATH}/.dotfiles/tag-smu/fish.local"

declare -r N_DIRECTORY="$HOME/n"

declare -r N_URL="https://git.io/n-install"

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

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        execute \
            "printf '%s\n' '$BASH_CONFIGS' >> $LOCAL_BASH_CONFIG_FILE \
                && . $LOCAL_BASH_CONFIG_FILE" \
            "n (update $LOCAL_BASH_CONFIG_FILE)"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# n - Node version management.
set -xU N_PREFIX \"\$HOME/n\"
set -U fish_user_paths \"\$N_PREFIX/bin\" \$fish_user_paths
"

    if [ ! -e "$LOCAL_FISH_CONFIG_FILE" ] || ! grep -q -z "$FISH_CONFIGS" "$LOCAL_BASH_CONFIG_FILE" &> /dev/null; then    
        execute \
            "printf '%s\n' '$FISH_CONFIGS' >> $LOCAL_FISH_CONFIG_FILE" \
            "n (update $LOCAL_FISH_CONFIG_FILE)"
    fi

}

install_n() {

    # Install `n` and add the necessary
    # configs in the local shell config files.

    execute \
        "curl -sL $N_URL | N_PREFIX=$N_DIRECTORY bash -s -- -q -n" \
        "n (install)" \
        && add_n_configs

}

update_n() {

    execute \
        ". $LOCAL_BASH_CONFIG_FILE \
            && n-update -y" \
        "n (upgrade)"

}

install_latest_stable_node() {

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

    current_version="$(
        node -v | \
        cut -d "v" -f 2
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -d "$N_DIRECTORY/n/versions/node/$latest_version" ] && [ "$current_version" != "$latest_version" ]; then
        execute \
            ". $LOCAL_BASH_CONFIG_FILE && \
                n lts" \
            "n (install node v$latest_version)"
    else
        print_success "(node) is already on the latest version"
    fi

}

install_npm_packages() {

    print_in_yellow "\n   Install npm packages\n\n"

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
    npm_install "carbon-now-cli"
    npm_install "emma-cli"
    npm_install "terminalizer"
    npm_install "@rafaelrinaldi/whereami"
    npm_install "create-dmg"
    npm_install "castnow"
    npm_install "terminal-image-cli"
    npm_install "gitmoji-cli"
    npm_install "fx"
    npm_install "screenshoteer"

    # process management
    npm_install "fkill-cli"
    npm_install "gtop"
    npm_install "vtop"

    # fonts
    npm_install "google-font-installer"

    # directory management
    npm_install "empty-trash-cli"
    npm_install "spot"

    # alfred packages
    [ -f "/$HOME/Library/Preferences/com.runningwithcrayons.Alfred-Preferences-3.plist" ] && {
        npm_install "alfred-emoj"
        npm_install "alfred-npms"
        npm_install "alfred-dark-mode"
        npm_install "alfred-cdnjs"
        npm_install "alfred-packagist"
        npm_install "alfred-mdi"
        npm_install "alfred-awe"
    }

    # version control
    npm_install "ghub"
    npm_install "ghwd"
    npm_install "github-is-starred-cli"

    # wallpaper management
    npm_install "wallpaper-cli"
    npm_install "splash-cli"

    # image optimization
    npm_install "svgo"

    # linters
    npm_install "eslint"
    npm_install "eslint-plugin-prettier"
    npm_install "eslint-config-prettier"
    npm_install "eslint-config-airbnb"
    npm_install "eslint-plugin-jsx-a11y"
    npm_install "eslint-plugin-import"
    npm_install "eslint-plugin-react"
    npm_install "prettier"

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

    print_in_purple "  n & npm\n\n"

    ask_for_sudo

    if [ ! -d "$N_DIRECTORY" ] && ! cmd_exists "n"; then
        install_n
    else
        update_n
    fi

    install_latest_stable_node

    install_npm_packages

}

main
