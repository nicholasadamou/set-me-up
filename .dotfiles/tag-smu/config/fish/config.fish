# load aliases
. "$HOME/.config/fish/aliases/aliases.fish"

# load fish variables
. "$HOME/.config/fish/variables/variables.fish"

# load fish keybindings
. ~/.config/fish/keybindings/keybindings.fish

# load local fish configurations
. ~/.fish.local

# asdf - Extendable version manager with support for Ruby, Node.js, Elixir, Erlang & more.
# see: https://github.com/asdf-vm/asdf#setup
. "$HOME/.asdf/asdf.fish"

# thefuck - Magnificent app which corrects your previous console command.
# see: https://github.com/nvbn/thefuck/wiki/Shell-aliases#fish
thefuck --alias | source

# load Tacklebox configuration
# see: https://github.com/justinmayer/tacklebox
if test -e $HOME/.tacklebox/tacklebox.fish
    . $HOME/.tacklebox/tacklebox.fish
end

# init sdkman
if test -e "$HOME/.sdkman/bin/sdkman-init.sh"
    . "$SDKMAN_DIR/bin/sdkman-init.sh"
end

# add android platform tools to path
if test -d "$HOME/Library/Android/sdk/platform-tools"
    set PATH "$HOME/Library/Android/sdk/platform-tools:$PATH"
end

if test -e "$HOME/.base16-manager/chriskempson/base16-shell/base16-shell.plugin.fish";
    . "$HOME/.base16-manager/chriskempson/base16-shell/base16-shell.plugin.fish"
end

# Clear system messages (system copyright notice, the date
# and time of the last login, the message of the day, etc.).

clear

