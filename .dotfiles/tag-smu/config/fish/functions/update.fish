function update --description "Updates MacOS apps, brew, npm, fisher, omf update, pip, pip3 and their installed packages"
    sudo softwareupdate --install --all
    mas upgrade

    brew update
    brew upgrade
    brew cu --all --yes --cleanup --quiet
    brew cleanup

    fisher
    fisher self-update
    omf update
    fish_update_completions

    sudo npm install npm@latest -g
    npm-check --global --update-all

    pip install --quiet --user --upgrade pip
    pip install --quiet --user --upgrade setuptools
    pip-review -a
end
