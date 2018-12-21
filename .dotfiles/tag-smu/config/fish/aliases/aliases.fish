alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias cd.. "cd .."

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias :q "exit"
alias c "clear"
alias e "vim --"
alias myip "curl -s checkip.dyndns.org | grep -Eo "[0-9\.]+""
alias whois "whois -h whois-servers.net"
alias m "man"
alias map "xargs -n1"
alias q "exit"
alias rm "rm -i -rf --"
alias fs "stat -f \"%z bytes\""

function du --description "Updates the dotfiles directory"
    ./$DOTFILES/smu --selfupdate
end

function randpw --description "generate a random password"
  dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64 | rev | cut -b 2- | rev
end

function cd --description "auto exa for each cd"
  if [ -n $argv[1] ]
    builtin cd $argv[1]
    and exa
  else
    builtin cd ~
    and exa
  end
end

function pkill --description "pkill a process interactively"
  ps aux | peco | awk "{ print $2 }" | xargs kill
end

function ppkill --description "kill -9 a process interactively"
  ps aux | peco | awk "{ print $2 }" | xargs kill -KILL
end

function pgrep --description "pgrep a process interactively"
  ps aux | peco | awk "{ print $2 }"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# 'ls' aliases

alias ls "exa"

# List all files colorized in long format
alias l "exa -l"
# List only directories
alias lsd "ls -lF --color | grep --color=never '^d'"
# List only hidden files
alias lsh "ls -ld .?*"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Lock screen.

alias afk "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shortcuts

alias dev "cd $HOME/dev"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `git` aliases

alias git "hub"
alias acp "git add -A ;and git commit -v ;and git push"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `lazygit` aliases

alias lg "lazygit"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `wttr` alias

alias wttr "curl wttr.in"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `Homebrew`.

alias brewd "brew doctor"
alias brewi "brew install"
alias brewr "brew uninstall"
alias brews "brew search"

function brewu --description "updates and upgrades brew"
    brew upgrade
    brew cleanup
    brew cask cleanup
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `tacklebox`.

function tackleu --description "Upgrades and updates tacklebox"
    cd ~/.tacklebox; git pull
    cd ~/.tackle; git pull
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `Node Package Manager`

# alias n "npm" # Do not use if using 'n' for Node version control
alias npmi "npm i -g"
alias npmr "npm uninstall"
alias npmls "npm list -g --depth 0"
alias npms "npm s"
alias npmu "npm i -g npm@latest"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for the `Yarn Package Manager`

alias yr "yarn remove"
alias ya "yarn add"
alias yu "yarn self-update ;and yarn upgrade ;and yarn upgrade-interactive"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `pip`

alias pipi "pip install"
alias pipr "pip uninstall"
alias pipls "pip list"
alias pips "pip search"
alias pipu "sudo pip install --upgrade pip and sudo pip install --upgrade setuptools"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `pip3`

alias pip3i "pip3 install"
alias pip3r "pip3 uninstall"
alias pip3ls "pip3 list"
alias pip3s "pip3 search"
alias pip3u "pip3 install -U pip and sudo -H pip3 install -U pip"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `Composer`

alias ci "composer install"
alias cr "composer remove"
alias cls "composer list"
alias cs "composer search"
alias cu "composer self-update"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clear DNS cache.

alias clear-dns-cache "sudo dscacheutil -flushcache and sudo killall -HUP mDNSResponder"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Hide/Show desktop icons.

alias hide-desktop-icons "defaults write com.apple.finder CreateDesktop -bool false; killall Finder"

alias show-desktop-icons "defaults write com.apple.finder CreateDesktop -bool true; killall Finder"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Get local IP.

alias local-ip "ipconfig getifaddr en1"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Open from the terminal.

function o --description "Open from the terminal"
    open $argv
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# piknik - Copy/paste anything over the network!
# see: https://github.com/jedisct1/piknik#suggested-shell-aliases

# pkc : read the content to copy to the clipboard from STDIN
alias pkc "piknik -copy"

# pkp : paste the clipboard content
alias pkp "piknik -paste"

# pkm : move the clipboard content
alias pkm "piknik -move"

# pkz : delete the clipboard content
alias pkz "piknik -copy < /dev/null"

# pkpr : extract clipboard content sent using the pkfr command
alias pkpr "piknik -paste | tar xzhpvf -"
