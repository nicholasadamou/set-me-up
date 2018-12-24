(*
on findLast(str, findString)
	local str, findString, len, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		set AppleScript's text item delimiters to findString as string
		considering case
			set len to str's last text item's length
		end considering
		set AppleScript's text item delimiters to oldTIDs
		if len is str's length then
			return 0
		else
			return -(findString's length) - len
		end if
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't findLast: " & eMsg number eNum
	end try
end findLast

set listOfFolks to {}
set partialNumberSought to "714261"


tell application "Address Book" to set {phoneNumbers, peoplesNames} to {value of phones, name} of people
repeat with p from 1 to (count peoplesNames)
   set aName to item p of peoplesNames
   if (aName contains "Nolan") then
       set end of listOfFolks to item p of peoplesNames & " ! " & item 1 of item p of phoneNumbers
   end if
end repeat

if (listOfFolks is {}) then
   display dialog "No one has a phone number that contains " & partialNumberSought
else
   return listOfFolks
end if

*)

tell application "Address Book"
   set {allNames, {allPhoneLabels, allPhoneNumbers}} to {name, {label, value} of phones} of people
end tell

set nameList to {}
set numberList to {}
repeat with i from 1 to (count allNames)
	if (item i of allNames contains ",") then
	  set end of nameList to item i of allNames
	  exit repeat
	end if
end repeat

if (nameList is {}) then
   return "No names with commas were found"
else
   (* choose from list flatList with prompt "Mobile number(s) found for “" & fullname & "”:"  *)
   return nameList
end if