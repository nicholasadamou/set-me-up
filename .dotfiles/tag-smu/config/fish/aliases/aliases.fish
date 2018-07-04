alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias cd.. "cd .."

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias :q "exit"
alias c "clear"
alias e "vim --"
alias myip "curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+'"
alias whois "whois -h whois-servers.net"
alias ll "ls -l"
alias m "man"
alias map "xargs -n1"
alias q "exit"
alias rm "rm -i -rf --"
alias t "tmux"
alias fs "stat -f \"%z bytes\""

function randpw --description "generate a random password"
  dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64 | rev | cut -b 2- | rev
end

function cd --description "auto ls for each cd"
  if [ -n $argv[1] ]
    builtin cd $argv[1]
    and ls -AF
  else
    builtin cd ~
    and ls -AF
  end
end

function pkill --description "pkill a process interactively"
  ps aux | peco | awk '{ print $2 }' | xargs kill
end

function ppkill --description "kill -9 a process interactively"
  ps aux | peco | awk '{ print $2 }' | xargs kill -KILL
end

function pgrep --description "pgrep a process interactively"
  ps aux | peco | awk '{ print $2 }'
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Lock screen.

alias afk "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `git` aliases

alias git "hub"

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

alias n "npm"
alias npmi "sudo (which npm) i -g"
alias npmr "sudo (which npm) uninstall"
alias npmls "sudo (which npm) list -g --depth 0"
alias npms "sudo (which npm) s"
alias npmu "sudo (which npm) i -g npm@latest"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `asdf`
# see: https://github.com/asdf-vm/asdf#usage

alias asdfi "asdf plugin-add"
# e.g. asdf plugin-add <name> <git-url>
alias asdfr "asdf plugin-remove"
# e.g. asdf plugin-remove <name>
alias asdfls "asdf plugin-list"
# e.g. asdf plugin-list || asdf list <name>
alias asdfu "asdf plugin-update --all"
# e.g. asdf plugin-update --all || asdf plugin-update <name>

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

# Shorter commands for `mas`

alias mi "mas install"
alias mr "mas uninstall"
alias mls "mas list"
alias ms "mas search"
alias mu "sudo mas upgrade"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clear DNS cache.

alias clear-dns-cache "sudo dscacheutil -flushcache and sudo killall -HUP mDNSResponder"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Empty the trash, the main HDD and on all mounted volumes,
# and clear Apple’s system logs to improve shell startup speed.

function empty-trash
    sudo rm -frv /Volumes/*/.Trashes
    sudo rm -frv ~/.Trash
    sudo rm -frv /private/var/log/asl/*.asl
    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* "delete from LSQuarantineEvent"
end

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
