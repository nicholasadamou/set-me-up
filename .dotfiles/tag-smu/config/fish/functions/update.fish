function update --description "Updates Kali, fisher, omf, and their installed packages"
    apt update
    apt upgrade -y
    apt full-upgrade -y
    apt autoremove -y
    apt clean

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
            sudo npm-check --global --update-all
        end
    end

    if type -q pip
        pip install --quiet --user --upgrade pip
        pip install --quiet --user --upgrade setuptools

        if type -q pip-review
            pip-review -a
        end
    end

    if test -f $HOME/.vim/plugins/Vundle.vim
        vim +PluginUpdate +qall
    end
end
