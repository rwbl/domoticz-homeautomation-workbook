# -*- coding: cp1252 -*-
## File:    wastecalicstocsv.py (Python 2)
## Project: atHome
## Purpuse: Create a CSV file with waste dates from an ICS iCal file Pinneberg and empty entries for Hohenfelde
## Author:  Robert W.B. Linn
## Version: 20181209

## Notes:
## The generated csv file wastecal.csv must be placed in /home/pi/domoticz/scripts/dzVents/scripts
## Domoticz Device Idx and Interval
## Biotonne Pi=98,16
## Papier Pi=99,32
## Restmuell Pi=100,16
## Gelber Sack Pi=101,16
## Schadstoff Pi=102,32
## Biotonne Ho=103,16
## Papier Ho =104,32
## Restmuell Ho=105,16
## Gelber Sack Ho=106,16

## The generated file has to be merged with the wastecal.csv file located on the Domoticz server:
## /home/pi/domoticz/scripts/dzVents/scripts

import csv, io, sys
import datetime
from datetime import date

wastecalendarics = 'wastecal-pi-2019.ics'

# Define the wastecalender csv file located in the same folder as the python script.
# CSV Format: wastetype, date1, date2 ...
# Date format dd-mm-YYYY, i.e. 09-08-2018
wastecalendarcsv = 'wastecal-2019.csv'

# Check the python version to set the file open arguments
if sys.version_info[0] == 2:  # Not named on 2.6
    icsaccess = 'rb'
    icskwargs = {}
    csvaccess = 'wb'
    csvkwargs = {}
else:
    icsaccess = 'rt'
    icskwargs = {'newline':''}
    csvaccess = 'a'
    csvkwargs = {}
    #csvkwargs = {'newline':''}

# Define the ics tokens
TOKEN_EVENT_BEGIN = "BEGIN:VEVENT"
TOKEN_EVENT_END = "END:VEVENT"
TOKEN_EVENT_DESCRIPTION = "DESCRIPTION:"
TOKEN_EVENT_START = "DTSTART:"
TOKEN_REST = "Restabfall 2"
TOKEN_BIO = "Bio"
TOKEN_SCHAD = "Schad"
TOKEN_GELB = "Gelb"
TOKEN_PAPIER = "Papier"

# Define the lists holding the dates per waste types. The lists are used to create the csv file
pirestlist = [] 
pibiolist = [] 
pischadlist = [] 
pigelblist = [] 
pipapierlist = [] 
horestlist = [] 
hobiolist = [] 
hogelblist = [] 
hopapierlist = [] 

# Define helpers
eventfound = 0
eventdescription = ""
eventstart = 0
eventyear = 0
eventmonth = 0
eventday = 0

def csv2string(data):
    si = io.BytesIO()
    cw = csv.writer(si)
    cw.writerow(data)
    return si.getvalue().strip('\r\n')

# Get the actual year month day
s = datetime.date.today().strftime("%d-%m-%Y")
# Get the date now in format i.e. 09-08-2018
datenow = datetime.datetime.strptime(s, "%d-%m-%Y")

# Set the waste type as the first entry in the waste lists 
## Biotonne Pi=98,16
## Papier Pi=99,32
## Restmuell Pi=100,16
## Gelber Sack Pi=101,16
## Schadstoff Pi=102,32
## Biotonne Ho=103,16
## Papier Ho =104,32
## Restmuell Ho=105,16
## Gelber Sack Ho=106,16

pibiolist.append('98,16')
pipapierlist.append('99,32')
pirestlist.append('100,16')
pigelblist.append('101,16')
pischadlist.append('102,32')
hobiolist.append('103,16')
hopapierlist.append('104,32')
horestlist.append('105,16')
hogelblist.append('106,16')

# Open the wastecalendar ics file in read access
with open(wastecalendarics, icsaccess, **icskwargs) as icsfile:
    # lines = icsfile.readlines()
    # Loop thru the file line by line
    for line in icsfile:
        # Strip the CRLF from the line
        linet = line.strip()
        # Print the line for tests
        # print linet
        # Check the entries

        # If token event end is found and an event has been build then add a waste entry date to the list.
        if linet.startswith(TOKEN_EVENT_END):
            if eventfound == 1 and len(eventdescription)> 0 and eventstart > 0:
                wastedate = "%s-%s-%s" % (eventday,eventmonth,eventyear)
                # print "Adding the line ", eventdescription, eventstart, eventyear, eventmonth, eventday

                # Workout the waste types and add the date
                if eventdescription.startswith(TOKEN_REST):
                    pirestlist.append(wastedate)
                    # print "Adding ", eventdescription, "-", wastedate

                if eventdescription.startswith(TOKEN_BIO):
                    pibiolist.append(wastedate)

                if eventdescription.startswith(TOKEN_PAPIER):
                    pipapierlist.append(wastedate)

                if eventdescription.startswith(TOKEN_GELB):
                    pigelblist.append(wastedate)

                if eventdescription.startswith(TOKEN_SCHAD):
                    pischadlist.append(wastedate)

                # Reset the globals which are used for the next event
                eventdescription = ""
                eventstart = 0
                eventyear = 0
                eventmonth = 0
                eventday = 0
                eventfound = 0

        # Set the flag if an new event is found
        if linet.startswith(TOKEN_EVENT_BEGIN):
            eventfound = 1

        # Event was found and now the description
        if eventfound and linet.startswith(TOKEN_EVENT_DESCRIPTION):
            eventdescription = linet.replace(TOKEN_EVENT_DESCRIPTION, "")

        # Event was found and now the start date
        # Extract from the date, the year, month, day
        if eventfound and linet.startswith(TOKEN_EVENT_START):
            # Example = DTSTART:20180105T053000Z
            eventstartstr = linet.replace(TOKEN_EVENT_START, "")
	    # Get the date in format 20180105
            index = eventstartstr.index('T')
            eventstartstr = eventstartstr[0:index]
            eventstart = int(eventstartstr)
	    # Get the year, month, day
            eventyear = eventstartstr[0:4]
            eventmonth = eventstartstr[4:6]
            eventday = eventstartstr[6:8]
            # print eventyear, eventmonth, eventday

    # Example to show the content of a list
    #print len(biolist)
    #for wastedate in biolist:
    #    print wastedate
    #print csv2string(biolist)

    # Write the lists to the CSV file. Each row contains a waste type with dates.
    # Sample: 98,16,12-01-2018,09-02-2018, ...
    with open(wastecalendarcsv, csvaccess, **csvkwargs) as csvfile:
        # Pinneberg
        csvfile.write(",".join(pipapierlist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(pirestlist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(pibiolist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(pigelblist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(pischadlist)) 
        csvfile.write("\n") 
        # Hohenfelde - the dates needs tobe added manually
        csvfile.write(",".join(hopapierlist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(horestlist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(hobiolist)) 
        csvfile.write("\n") 
        csvfile.write(",".join(hogelblist)) 
        csvfile.write("\n") 
        # Close with message    
        csvfile.close()
        print "Created CSV file", wastecalendarcsv

    # Exit the script
    icsfile.close()
    sys.exit()
