# fish variables

set -g -x PATH /usr/local/bin $PATH

# Paths to your tackle
set tacklebox_path "$HOME/.tackle" "$HOME/.tacklebox"

# Theme
# set tacklebox_theme entropy

# Which modules would you like to load? (modules can be found in $HOME/.tackle/modules/*)
# Custom modules may be added to $HOME/.tacklebox/modules/
# Example format: set tacklebox_modules virtualfish virtualhooks

# Which plugins would you like to enable? (plugins can be found in $HOME/.tackle/plugins/*)
# Custom plugins may be added to $HOME/.tacklebox/plugins/
# Example format: set tacklebox_plugins python extract

# Paths to your sdkman
set SDKMAN_DIR "$HOME/.sdkman"