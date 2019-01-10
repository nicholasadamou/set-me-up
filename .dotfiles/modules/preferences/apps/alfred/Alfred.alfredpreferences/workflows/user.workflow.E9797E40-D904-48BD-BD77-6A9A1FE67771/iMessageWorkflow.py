import string
import subprocess
from sets import Set
import sys

class XMLTemplateCreator:

    def __init__(self):
        self.xmlTemplate = """
      <items>
          <item uid="%(uid)s" arg="%(arg)s" valid="%(valid)s" autocomplete="%(autocomplete)s">
              <title>%(title)s</title>
              <subtitle>%(subtitle)s</subtitle>
              <icon>%(icon)s</icon>
           </item>
      </items>
      """

    def createXMLfromVerse(self, passageNumber, passage):
        data = {'uid': passageNumber, 'arg': passageNumber, 'valid': 'YES', 'autocomplete':
                passageNumber, 'title': passageNumber, 'subtitle': passage, 'icon': "icon.png"}
        return self.xmlTemplate % data

    def createXMLfromPhoneNumber(self, name, phone_type, phone_number):
    	title = str(name) + ": " + str(phone_type)
    	arg = "growlvoice:" + phone_number + "?text"
        data = {
            'uid': phone_number, 'arg': arg, 'valid': 'YES',
            'autocomplete': name, 'title': title, 'subtitle': phone_number, 'icon': "icon.png"}
        return self.xmlTemplate % data


#from stackoverflow http://stackoverflow.com/questions/1276764/stripping-everything-but-alphanumeric-chars-from-a-string-in-python
delchars = ''.join(c for c in map(chr, range(256)) if not (c.isalnum() or c == ","))
namesSet = Set([])
switcher = True
i = 0
partialName = sys.argv[1]

cmd = ["osascript",  "apple.scpt", partialName]
names_and_numbers = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]



if names_and_numbers:
	names_and_numbers_array = names_and_numbers.split(',')	
	names = names_and_numbers_array[:len(names_and_numbers_array)/2]
	numbers = names_and_numbers_array[len(names_and_numbers_array)/2:]
	numbers = ",".join(numbers)
	scrunchedNumbers = numbers.translate(None, delchars)
	numbers = string.strip(scrunchedNumbers).split(',')
	while i < len(names):
		namesSet.add((names[i], numbers[i]))
		i+=1

	x = XMLTemplateCreator()
	XMLString = ""
	for name_and_phone_number in namesSet:
	    name = name_and_phone_number[0]
	    number = name_and_phone_number[1]
	    XMLString = XMLString + x.createXMLfromPhoneNumber(name, "Mobile",number)

	print "<items> \n" + XMLString + " \n </items>"

else:
	print(
	"""<items> 

      <items>
          <item uid="None" arg="None" valid="YES" autocomplete="None">
              <title> "There is no person with that name</title>
              <subtitle>""</subtitle>
              <icon>icon.png</icon>
           </item>
      </items>
      """)