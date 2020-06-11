function update --description "Updates MacOS apps, brew, npm, fisher, omf update, pip, pip3 and their installed packages"
    sudo softwareupdate --install --all

    if type -q mas
        mas upgrade
    end

    if type -q brew
        sudo rm -rf /usr/local/var/homebrew/locks/*
        brew update
        brew upgrade
        brew tap buo/cask-upgrade
        brew cu --all --yes --cleanup --quiet
        brew cleanup
    end

    if type -q npm
        sudo npm install npm@latest -g

        if type -q npm-check
            npm-check --global --update-all
        end
    end

    if type -q pip3
        python3 -m pip install --quiet --user --upgrade pip
        python3 -m pip install --upgrade setuptools pip
    end
end
