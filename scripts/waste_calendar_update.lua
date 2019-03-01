--[[
    waste_calendar_update.lua
    Read a csv file with wastecalendar dates per device.
    Update the device text with the date if the date is within interval specified.
    The wastecalender file "wastecal.csv" is located in the dzVents scripts folder.
    Line entry csv file: idx,interval,date1,dateN.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20180930
]]--

-- External modules: /home/pi/domoticz/scripts/dzVents/scripts
local utils = require('utils')
local msgbox = require('msgbox')

-- threshold in days to notify
-- if the difference of the current day to a wastecalendarday equals threshold
-- then notify
local TH_WASTECAL = 1

-- Helpers
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

-- the wastecalendar file is updated once per year
local wastecalfile = '/home/pi/domoticz/scripts/dzVents/scripts/wastecal.csv'
local sep = ","

-- read the csv file
function readandupdate(domoticz)
    -- read the file line by line.
    -- each line contains an array with device[1], wasteinterval[2], dates[2...]
    for line in io.lines(wastecalfile) do
	    -- split the line by , and assign to a table
	    local wastetable = line:split(sep)
	    local idx = tonumber(wastetable[1])
	    local interval = tonumber(wastetable[2])
	    -- flag to check if a wastedate has been found
	    local datefound = 0
	    
	    -- check the dates, start at 3 because 1=idx, 2=interval and number of table entries
	    for i = 3, #wastetable do

            -- get the wastedate array entry
		    local wastedate = wastetable[i]
		    -- split the wastedate into an array with 3 entries day, month, year
		    local wastedatesplit = wastedate:split("-")
		    -- calculate the daysdiff between now and the wastedate
		    local daysdiff = utils.datediffnow(wastedatesplit[1], wastedatesplit[2], wastedatesplit[3])
		    -- 
		    local month = tonumber(wastedatesplit[2])

		    -- check if daysdiff within interval
		    -- if daysdiff >= 0 and daysdiff < interval then
		    if daysdiff >= 0 and datefound == 0 then
                datefound = 1
			    print (domoticz.devices(idx).name .. '(' .. idx .. ')=' .. wastedate .. ', days=' .. daysdiff .. ', interval=' .. interval)

			    -- update the device text with the new date
                domoticz.devices(idx).updateText(wastedate)
			
			    -- check number of days left compared to the threshold
			    -- i.e. if 1 day left, then notify using device name & text.
			    -- the device text contains the date
			    -- NOT USED = handled by the dzVents script waste_calendar_notifier
			    if daysdiff == TH_WASTECAL then
				    -- print ('Device ' .. idx .. ' notifying...')
                    message = '[ACHTUNG] ' .. domoticz.devices(idx).name .. ' ' .. domoticz.devices(idx).text
                    -- update alert message
                    -- msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_RED, message)
    	            domoticz.log(message, domoticz.LOG_INFO)
                    domoticz.notify(message)
    		    end 
		    end

	        -- check if for the last entry daysdiff less 0, then no new date available
	        -- this is used f.e. for hohenfelde as last wastedate is sep or oct
		    if i == #wastetable and daysdiff < 0 then
                datefound = 1
			    print (idx .. '=' .. wastedate .. ', days=' .. daysdiff .. ', interval=' .. interval .. ', KEIN TERMIN')

			    -- update the device text with the info that there is no date (yet) available
                domoticz.devices(idx).updateText('Kein neuer Termin')
		    end

        end

	    -- check if a wastedate has been found, if not then set Kein termin message
	    if datefound == 0 then
		    print (idx .. '=' .. 'KEIN TERMIN')
			-- update the device text with the info that there is no date (yet) available
            domoticz.devices(idx).updateText('Kein neuer Termin')
        end

        -- JUST SOME LEARNERS
	    -- print the content
	    -- for i = 1, #wastetable do
	    -- 	print( wastetable[i] )
    	-- end
	
	    -- print device idx and length of the csv string
	    -- print (wastetable[1] .. "Length:" .. #wastetable)

    end
end

return {
	on = {
        timer = {
            -- for tests use every minute
            -- 'every minute',
	        'at 00:30'
        }
    },
	execute = function(domoticz)
        readandupdate(domoticz)
	end
}

