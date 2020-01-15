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


   set iMessageService to name of 1st service whose name starts with "E:"
   set buddyList to handle of buddies
   return buddyList
   tell application "System Events"
   	set visible of process "Messages" to false
   end tell

end tell