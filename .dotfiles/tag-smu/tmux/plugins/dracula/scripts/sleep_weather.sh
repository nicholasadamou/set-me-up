#!/usr/bin bash

# A wrapper script for running weather on an interval

main()
{
	current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	"$current_dir"/weather.sh > "$current_dir"/../data/weather.txt

	while tmux has-session &> /dev/null
	do
		"$current_dir"/weather.sh > "$current_dir"/../data/weather.txt
		if tmux has-session &> /dev/null
		then
			sleep 1200
		else
			break
		fi
	done
}

main
