function update --description "Updates Linux apps, brew, npm, fisher, omf update, pip, pip3 and their installed packages"
   sudo apt update
   sudo apt upgrade -y
   sudo apt dist-upgrade -y
   sudo apt full-upgrade -y
   sudo apt autoremove -y
   sudo apt clean

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

    if type -q pip3
        python3 -m pip install --quiet --user --upgrade pip
        python3 -m pip install --upgrade setuptools pip
    end
end
