function update --description "Updates Kali, fisher, omf, and their installed packages"
    apt update
    apt upgrade -y
    apt full-upgrade -y
    apt autoremove -y
    apt clean

    if type -q fisher
        fisher
        fisher self-update
    end

    if type -q omf
        omf update
    end

    fish_update_completions
end
