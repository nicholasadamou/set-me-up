# -*- coding: utf-8 -*-
import DictToFile
import FuzzyDict
import sys
import string
import subprocess
import unicodedata
reload(sys)
sys.setdefaultencoding('utf-8')

#Variables
buddyList = []
name = sys.argv[1]
name = unicode(name)
name = unicodedata.normalize('NFC',name)

try:
  w = DictToFile.Writer()
  contactsFuzzyDictionary = w.reading('ContactNumbers.txt')
except Exception, e:
  print """
      <items>
          <item uid="NoContacts" arg="None" valid="YES" autocomplete="imu">
              <title>Your contact list is empty or broken</title>
              <subtitle>You might need to run keyword 'imu'</subtitle>
              <icon>icon.png</icon>
           </item>
      </items>
      """

#creates a list of phone numbers from the iMessage buddy list
def createBuddyList():
  delchars = ''.join(c for c in map(chr, range(256)) if not (c.isalnum() or c == ","))
  cmd = ["osascript",  "buddyList.scpt"]
  global buddyList
  buddyList = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
  scrunchedNumbers = buddyList.translate(None, delchars)
  buddyList = string.strip(scrunchedNumbers).split(',')

def findBestiMessageArguement(name, phone_number_list):
  if not buddyList:
    createBuddyList()
  for phone_number in phone_number_list:
    num = string.strip(phone_number)
    if len(num) == 10:
      num = "1" + num
    if num in buddyList:
      return num
  else:
    return name

class XMLTemplateCreator:

    
    cmd = ["osascript",  "buddyList.scpt"]
    buddyList = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]

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

    def createXMLfromPhoneNumber(self, name, phone_type, phone_number, iMessageArg):
      title = str(name) + ": " + str(phone_type)
      arg = iMessageArg
      data = {
          'uid': phone_number, 'arg': arg, 'valid': 'YES',
          'autocomplete': name, 'title': title, 'subtitle': phone_number, 'icon': "icon.png"}
      return self.xmlTemplate % data

# check if it returns no key, then return a 'none' xml
if str(contactsFuzzyDictionary[name][0:5]) == "Sorry":
  print XMLTemplateCreator().createXMLfromVerse("None", "None")

  
# test
x = XMLTemplateCreator()
XMLString = ""
names_and_phone_numbers = contactsFuzzyDictionary[name]
# print names_and_phone_numbers[0:3]
count = 0
for name_and_phone_number in names_and_phone_numbers:
  name = name_and_phone_number[0]
  numbers = name_and_phone_number[1]
  iMessageArg = findBestiMessageArguement(name, numbers)
  XMLString = XMLString + x.createXMLfromPhoneNumber(name, 'mobile', iMessageArg, iMessageArg)
  count += 1
  if count == 11: break
  
# print "<items> \n" + XMLString + " \n </items>"
print [name]




# print contactsFuzzyDictionary['Bryan']
