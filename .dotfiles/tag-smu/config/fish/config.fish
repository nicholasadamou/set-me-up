# load aliases
source "$HOME/.config/fish/aliases/aliases.fish"

# load fish variables
source "$HOME/.config/fish/variables/variables.fish"

# load local fish configurations
source "$HOME/.fish.local"

# load 'thefuck' configurations
# see: https://github.com/nvbn/thefuck/wiki/Shell-aliases#fish
if type -q thefuck
    thefuck --alias | source
end

# load 'Tacklebox' configuration
# see: https://github.com/justinmayer/tacklebox
if test -e $HOME/.tacklebox/tacklebox.fish
    source $HOME/.tacklebox/tacklebox.fish
end

# load 'sdkman' configurations
# see: https://sdkman.io/install
if test -e "$HOME/.sdkman/bin/sdkman-init.sh"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
end

# load 'autojump' configurations
# see: https://github.com/wting/autojump
if test -e "/usr/local/share/autojump/autojump.fish"
    source "/usr/local/share/autojump/autojump.fish"
end

# load 'z.lua' configs.
# see: https://github.com/skywind3000/z.lua#install
if test -e "$HOME"/.z.lua
    source (lua "$HOME"/.z.lua/z.lua --init fish | psub)
end

# load local fish configs.
if test -e "$HOME"/.config.fish.local
    source "$HOME"/.config.fish.local
end

# Clear system messages (system copyright notice, the date
# and time of the last login, the message of the day, etc.).

clear

