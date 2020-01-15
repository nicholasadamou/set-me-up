tell application "Messages"
   activate
   set iMessageService to name of 1st service whose name starts with "E:"
   set buddyList to handle of buddies
   return buddyList
end tell