# load aliases
source "$HOME/.config/fish/aliases/aliases.fish"

# load fish variables
source "$HOME/.config/fish/variables/variables.fish"

# load local fish configurations
source "$HOME/.fish.local"

# load thefuck configurations
# see: https://github.com/nvbn/thefuck/wiki/Shell-aliases#fish
if type -q thefuck
    thefuck --alias | source
end

# load Tacklebox configuration
# see: https://github.com/justinmayer/tacklebox
if test -e $HOME/.tacklebox/tacklebox.fish
    source $HOME/.tacklebox/tacklebox.fish
end

# load sdkman configurations
# see: https://sdkman.io/install
if test -e "$HOME/.sdkman/bin/sdkman-init.sh"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
end

# load autoenv_fish configurations
# see: https://github.com/loopbit/autoenv_fish#installation
if test -e (brew --prefix autoenv_fish)/activate.fish
    source (brew --prefix autoenv_fish)/activate.fish
end

# load autojump configurations
# see: https://github.com/wting/autojump#os-x
if test -e /usr/local/share/autojump/autojump.fish
    source /usr/local/share/autojump/autojump.fish
end

# load jump configurations
# see: https://github.com/gsamokovarov/jump#integration
if test -e (brew --prefix jump)
    status --is-interactive; and source (jump shell | psub)
end

# Clear system messages (system copyright notice, the date
# and time of the last login, the message of the day, etc.).

clear

