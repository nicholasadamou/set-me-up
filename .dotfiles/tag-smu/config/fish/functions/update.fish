function update --description "Updates MacOS apps, brew, npm, fisher, omf update, pip, pip3 and their installed packages"
    sudo softwareupdate --install --all

    if type -q mas
        mas upgrade
    end

    if type -q brew
        brew update
        brew upgrade
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
        pip3 install -U pip
    end

    if type -q pip
        pip install --quiet --user --upgrade pip
        pip install --quiet --user --upgrade setuptools

        if type -q pip-review
            pip-review -a
        end
    end

    if test -d $HOME/.vim/plugins/Vundle.vim
        vim +PluginUpdate +qall
    end
end
