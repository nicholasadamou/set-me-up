#!/bin/bash

LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"
LOCAL_FISH_CONFIG_FILE="$HOME/.fish.local"

declare -r N_DIRECTORY="$HOME/n"

declare -r N_URL="https://git.io/n-install"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_n_configs() {

    # bash

    declare -r BASH_CONFIGS="
# n - Node version management.
export N_PREFIX=\"\$HOME/n\";
[[ :\$PATH: == *\":\$N_PREFIX/bin:\"* ]] || PATH+=\":\$N_PREFIX/bin\"
"

    printf '%s\n' "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
        && . "$LOCAL_BASH_CONFIG_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# n - Node version management.
set -xU N_PREFIX \"\$HOME/n\"
set -U fish_user_paths \"\$N_PREFIX/bin\" \$fish_user_paths
"

    printf '%s\n' "$FISH_CONFIGS" >> "$LOCAL_FISH_CONFIG_FILE"

}

install_n() {

    curl -L "$N_URL" | N_PREFIX="$N_DIRECTORY" bash -s -- -q -n \
        && add_n_configs

}

update_n() {

    . "$LOCAL_BASH_CONFIG_FILE" \
        && n-update -y
    
}

install_latest_stable_node() {

    # Install the latest stable version of Node
    # (this will also set it as the default).

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `n` is installed

    if ! command -v "n"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    latest_version="$(
        . $LOCAL_BASH_CONFIG_FILE \
        && n --lts
    )"

    current_version="$(
        node -v | \
        cut -d "v" -f 2
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ "$current_version" != "$latest_version" ] && [ ! -d "$N_DIRECTORY/n/versions/node/$latest_version" ]; then
            . "$LOCAL_BASH_CONFIG_FILE" \
                && n lts
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "------------------------------"
echo "Running web module"
echo "------------------------------"
echo ""

# Install `n` to manage Node versions

if [ ! -d "$N_DIRECTORY" ] && ! command -v "n"; then
    install_n
else
    update_n
fi

# Install Node & NPM LTS using `n`

echo "------------------------------"
echo "Installing node & npm LTS using (n)"

install_latest_stable_node

# Install NPM packages

echo "------------------------------"
echo "Installing npm packages"

sudo npm install -g \
# working with npm
npm-check \
yarn-check \
np \
npm-name-cli \
# package managers
yarn \
bower \
pnpm \
parcel-bundler \
# useful binaries
md-to-pdf \
favicon-emoji \
tldr \
carbon-now-cli \
emma-cli \
terminalizer \
@rafaelrinaldi/whereami \
create-dmg \
castnow \
terminal-image-cli \
gitmoji-cli \
fx \
screenshoteer \
# process management
fkill-cli \
gtop \
vtop \
# fonts
google-font-installer \
# directory management
empty-trash-cli \
spot \
# alfred packages
alfred-emoj \
alfred-npms \
alfred-dark-mode \
alfred-cdnjs \
alfred-packagist \
alfred-mdi \
alfred-awe \
# version control
ghub \
ghwd \
github-is-starred-cli \
# wallpaper management
wallpaper-cli \
splash-cli \
# image optimization
svgo \
# linters
eslint \
eslint-plugin-prettier \
eslint-config-prettier \
eslint-config-airbnb \
eslint-plugin-jsx-a11y \
eslint-plugin-import \
eslint-plugin-react \
prettier \
# deployment
netlify-cli \
surge \
now \
# task runneries
gulp-cli \
gulp@next \
# networking
wt-cli \
speed-test \
is-up-cli \
localtunnel \
spoof \
http-server \
# javascript packages
next \
nodemon \
# vue packages
@vue/cli \
# react packages
create-react-app \
create-react-library \
react-native-cli \
# database packages
prisma \
graphql-cli \
firebase-tools \
# continuous integration (CI) bots
snyk

