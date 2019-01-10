# -*- coding: utf-8 -*-
import string
import unicodedata
import subprocess
from sets import Set
import sys
import DictToFile
import difflib

reload(sys)
sys.setdefaultencoding('utf-8')

def is_not_ascii(s):
    return not all(ord(c) < 128 for c in s)

try: 
	delchars = ''.join(c for c in map(chr, range(256)) if not (c.isalnum() or c == "," or c == "~"))
	nameDelChars = ''.join(c for c in map(chr, range(256)) if not (c.isalnum() or c == " " or c == "~" or c =="\\" or is_not_ascii(c)))
	names_and_numbers_set = Set([])
	names_and_numbers_tuples = []
	allContacts = {}
	i = 0

	cmd = ["osascript",  "AllContactsAndAllNumbers.scpt"]
	names_and_numbers = " " + subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0][:-4]
	# Applescript adds a space after every comma in their array representation, but the first element doesn't have a space or comma in front

	if names_and_numbers:
		# first half of array is names, second half is numbers
		names_and_numbers_array = names_and_numbers.split('%^&')
		names = names_and_numbers_array[:len(names_and_numbers_array)/2]
		numbers = names_and_numbers_array[len(names_and_numbers_array)/2:]

		if not len(names) == len(numbers):
			raise Exception()

		# removing all superflourous characters like () or - or spaces
		numbers = "~".join(numbers)
		scrunchedNumbers = numbers.translate(None, delchars)
		numbers = string.strip(scrunchedNumbers).split('~')

		# removing commas between names
		names = "~".join(names)
		scrunchedNames = names.translate(None, nameDelChars)
		names = string.strip(scrunchedNames).split('~')
		
		for i in range(0, len(names)):
			name = string.strip(names[i])
			name = unicodedata.normalize('NFC', unicode(name))
			if allContacts.get(name) == None: 
				numbersSet = []
			else:
				numbersSet = allContacts.get(name)[1]
			for num in numbers[i].split(','):
				if num:
					numbersSet.append(num)

			allContacts[name] = (name, numbersSet)

		# while i < len(names_and_numbers_array):
		# 	name = names_and_numbers_array[i][1:] 
		# 	number = ''.join(ch for ch in names_and_numbers_array[i+1] if ch.isalnum())
		# 	names_and_numbers_set.add((name, number))
		# 	i+=2

		w = DictToFile.Writer()
		w.writing('ContactNumbers.txt', allContacts)

	if not allContacts:
		print "Contacts Update Failed. Please check forum post for possible reason(s)"
	else:
		print "Contacts Updated Successfully"

except:
	print "Contacts Update Failed. Please check forum post for possible reason(s)"
		 


