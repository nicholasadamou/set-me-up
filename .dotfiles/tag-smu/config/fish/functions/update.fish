function update --description "Updates Linux apps, brew, npm, fisher, omf update, pip, pip3 and their installed packages"
    if type -q brew
        brew update
        brew upgrade
        brew tap buo/cask-upgrade
        brew cu --all --yes --cleanup --quiet
        brew cleanup
    end

    if type -q fisher
        fisher
        fisher self-update
    end

    if type -q omf
        omf update
    end

    fish_update_completions

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
