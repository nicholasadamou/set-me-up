# load aliases
source "$HOME/.config/fish/aliases/aliases.fish"

# load fish variables
source "$HOME/.config/fish/variables/variables.fish"

# load local fish configurations
source ~/.fish.local

# thefuck - Magnificent app which corrects your previous console command.
# see: https://github.com/nvbn/thefuck/wiki/Shell-aliases#fish
if type -q thefuck
    thefuck --alias | source
end

# load Tacklebox configuration
# see: https://github.com/justinmayer/tacklebox
if test -e $HOME/.tacklebox/tacklebox.fish
    source $HOME/.tacklebox/tacklebox.fish
end

# init sdkman
if test -e "$HOME/.sdkman/bin/sdkman-init.sh"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
end

# Clear system messages (system copyright notice, the date
# and time of the last login, the message of the day, etc.).

clear

