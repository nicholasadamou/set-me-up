function update --description "Updates MacOS apps, brew, npm, fisher, omf update, asdf, pip, pip3 and their installed packages"
    sudo softwareupdate --install --all
    mas upgrade
    
    brew update
    brew upgrade
    brew cleanup
    
    fisher up
    omf update
    fish_update_completions
    
    if not ls -A $HOME/.asdf/plugins 
        asdf plugin-update --all 
    end
    
    sudo npm install npm@latest -g
    sudo npm update -g
    
    python -m pip install -U pip
    pip3 install --upgrade setuptools pip
end
