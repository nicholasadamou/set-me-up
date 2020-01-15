(* #ver 2.1 *)
on run argv
	set partialNameSought to item 1 of argv
	set user to item 1 of argv
	set msg to item 2 of argv
	set isAppRunning to false

	(* from antonellopasella's github *)
	tell application "Messages"
		tell application "System Events"
			if (exists process "Messages") then
				set isAppRunning to true
			end if
		end tell

		if isAppRunning is false then
			activate
			delay 3
		end if
		try 
		 	tell application "Messages"
	        	set iMessageService to name of 1st service whose name starts with "E:"
	        	set theBuddy to buddy user of service iMessageService
	        	send msg to theBuddy
			end tell
		on error errorMessage
			send msg to buddy user
		end try
	end tell
	(*end*)

	(*tell application "System Events"
		set visible of process "Messages" to false
	end tell*)
end run
