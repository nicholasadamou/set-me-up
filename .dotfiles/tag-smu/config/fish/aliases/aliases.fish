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

if type -q exa
    alias ls "exa"

    # List all files colorized in long format
    alias l "exa -l"
end

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

# Lock screen.

alias afk "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `git` aliases

if type -q hub
    alias git "hub"
end

alias acp "git add -A ;and git commit -v ;and git push"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `lazygit` aliases

if type -q lazygit
    alias lg "lazygit"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `wttr` alias

alias wttr "curl wttr.in"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `Homebrew`.

if type -q brew
    alias brewd "brew doctor"
    alias brewi "brew install"
    alias brewr "brew uninstall"
    alias brews "brew search"

    function brewu --description "updates and upgrades brew"
        brew upgrade
        brew cleanup
        brew cask cleanup
    end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `Node Package Manager`

# alias n "npm" # Do not use if using 'n' for Node version control

if type -q npm
    alias npmi "npm i -g"
    alias npmr "npm uninstall"
    alias npmls "npm list -g --depth 0"
    alias npms "npm s"
    alias npmu "npm i -g npm@latest"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for the `Yarn Package Manager`

if type -q yarn
    alias yr "yarn remove"
    alias ya "yarn add"
    alias yu "yarn self-update ;and yarn upgrade ;and yarn upgrade-interactive"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `pip`

if type -q pip
    alias pipi "pip install"
    alias pipr "pip uninstall"
    alias pipls "pip list"
    alias pips "pip search"
    alias pipu "sudo pip install --upgrade pip and sudo pip install --upgrade setuptools"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `pip3`

if type -q pip3
    alias pip3i "pip3 install"
    alias pip3r "pip3 uninstall"
    alias pip3ls "pip3 list"
    alias pip3s "pip3 search"
    alias pip3u "pip3 install -U pip and sudo -H pip3 install -U pip"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shorter commands for `Composer`

if type -q composer
    alias ci "composer install"
    alias cr "composer remove"
    alias cls "composer list"
    alias cs "composer search"
    alias cu "composer self-update"
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

alias lip "ipconfig getifaddr en0"

# Get external IP.

alias xip "curl -s checkip.dyndns.org | grep -Eo "[0-9\.]+""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Open from the terminal.

function o --description "Open from the terminal"
    open $argv
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# piknik - Copy/paste anything over the network!
# see: https://github.com/jedisct1/piknik#suggested-shell-aliases

if type -q piknik
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
end
