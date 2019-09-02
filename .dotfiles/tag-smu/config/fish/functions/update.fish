function update --description "Updates debian, fisher, omf, brew, npm, pip, and their installed packages"
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-upgrade -y
    sudo apt full-upgrade -y
    sudo apt autoremove -y --purge
    sudo apt clean
    sudo apt autoclean

    if type -q brew
        brew update
        brew upgrade
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
