# fish variables

# NOTE: There is probably a sexier nicer way to do this, but until I figure that out I am manually unset PATH
set -gx PATH

# Sets necessary PATH defaults
set -gx PATH $PATH /usr/local/bin /usr/bin /bin /sbin /usr/sbin /usr/local/sbin /sbin $HOME/.local/bin $HOME/"set-me-up"

# Paths to your tackle
set tacklebox_path ~/.tackle ~/.tacklebox

# Homebrew configurations
# Make all homebrew casks and fonts be installed to a
# specific directory
set -gx HOMEBREW_CASK_OPTS "--appdir=/Applications --fontdir=/Library/Fonts"

# Ruby configurations
# Adds "GEMS_PATH" to "$PATH"
# Fixes "I INSTALLED GEMS WITH --user-install AND THEIR COMMANDS ARE NOT AVAILABLE"
# see: https://guides.rubygems.org/faqs/#user-install
if test -d (gem environment gemdir)/bin
    set -gx PATH $PATH (gem environment gemdir)/bin
end

# iTerm2 integration
# Adds ~/.iterm2 to "$PATH"
if test -d ~/.iterm2
    set -gx PATH $PATH ~/.iterm2
end

# Dotfiles directory
set DOTFILES $HOME/"set-me-up"

# linuxbrew configurations

set -l linuxbrew_bin_path "$HOME/.linuxbrew/bin"
set -l linuxbrew_sbin_path "$HOME/.linuxbrew/sbin"
set -l linuxbrew_manpath "$HOME/.linuxbrew/share/man"
set -l linuxbrew_infopath "$HOME/.linuxbrew/share/info"

contains -- $linuxbrew_bin_path $PATH
	or set -gx PATH $linuxbrew_bin_path $PATH

contains -- $linuxbrew_sbin_path $PATH
	or set -gx PATH $linuxbrew_sbin_path $PATH

contains -- $linuxbrew_manpath $MANPATH
	or set -gx MANPATH $linuxbrew_manpath $MANPATH

contains -- $linuxbrew_infopath $INFOPATH
	or set -gx INFOPATH $linuxbrew_infopath $INFOPATH

# Theme
# set tacklebox_theme entropy

# Which modules would you like to load? (modules can be found in ~/.tackle/modules/*)
# Custom modules may be added to ~/.tacklebox/modules/
# Example format: set tacklebox_modules virtualfish virtualhooks

# Which plugins would you like to enable? (plugins can be found in ~/.tackle/plugins/*)
# Custom plugins may be added to ~/.tacklebox/plugins/
# Example format: set tacklebox_plugins python extract

# Change spacefish char
# see: https://spacefish.matchai.me/docs/Options.html#char
set SPACEFISH_CHAR_SYMBOL "\$"
