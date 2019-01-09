alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias cd.. "cd .."

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias :q "exit"
alias c "clear"
alias e "vim --"
alias whois "whois -h whois-servers.net"
alias m "man"
alias map "xargs -n1"
alias q "exit"
alias rm "rm -i -rf --"
alias fs "stat -f \"%z bytes\""
alias +x "chmod +x"

function du --description "Updates the dotfiles directory"
    if test -d $DOTFILES
      eval $DOTFILES/smu --selfupdate
    else
      echo "($DOTFILES) does not exist"
    end
end

function randpw --description "generate a random password"
  dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64 | rev | cut -b 2- | rev
end

function cd --description "auto exa for each cd"
  if type -q exa
    if [ -n $argv[1] ]
      builtin cd $argv[1]
      and exa
    else
      builtin cd ~
      and exa
    end
  else
    if [ -n $argv[1] ]
      builtin cd $argv[1]
    else
      builtin cd ~
    end
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

# List only directories
alias lsd "ls -lF --color | grep --color=never '^d'"
# List only hidden files
alias lsh "ls -ld .?*"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# 'fzy' aliases

if type -q fzy
  alias fzyf "find . -type f | fzy"
  alias fzyd "find . -type d | fzy"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `tacklebox`.

if test -d ~/.tacklebox -a -d ~/.tackle
  function tackleu --description "Upgrades and updates tacklebox"
      cd ~/.tacklebox; git pull
      cd ~/.tackle; git pull
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clear DNS cache.

alias clear-dns-cache "sudo dscacheutil -flushcache and sudo killall -HUP mDNSResponder"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Hide/Show desktop icons.

alias hide-desktop-icons "defaults write com.apple.finder CreateDesktop -bool false; killall Finder"

alias show-desktop-icons "defaults write com.apple.finder CreateDesktop -bool true; killall Finder"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Get local IP.

alias lip "ifconfig \
                    | grep 'inet addr' \
                    | grep -v '127.0.0.1' \
                    | cut -d: -f2 \
                    | cut -d' ' -f1"

# Get external IP.

alias xip "curl -s checkip.dyndns.org | grep -Eo "[0-9\.]+""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Open from the terminal.

function o --description "Open from the terminal"
    open $argv
end
