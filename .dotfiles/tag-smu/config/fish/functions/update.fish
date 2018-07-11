function update --description "Updates MacOS apps, brew, npm, fisher, omf update, pip, pip3 and their installed packages"
    sudo softwareupdate --install --all
    mas upgrade

    brew update
    brew upgrade
    brew cleanup

    fisher up
    omf update
    fish_update_completions

    sudo npm install npm@latest -g
    sudo npm update -g

    pip install --quiet --upgrade pip
    pip install --quiet --upgrade setuptools
    python -m pip_review -a
    python -3 -m pip_review -a
end
