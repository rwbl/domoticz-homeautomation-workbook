--[[
    keydates_update.lua
    Read a csv file with keydates per device.
    The keydates file "keydates.csv" is located in the dzVents scripts folder.
    (keydatesfile = '/home/pi/domoticz/scripts/dzVents/scripts/keydates.csv')
    Line entry csv file: idx,date1,dateN.
    Example: 232,23-03-2020,22-06-2020,21-09-2020,16-12-2020

    Action:
    Update the device text with the date if the first datediff in days >= 0

    Note: 
    if a device is not used, ensure to take out the line in the keydates.csv file
    OR place -1, prior idx. If the idx is used, remove the -1, entry. Example:
    -1;232,23-03-2020,22-06-2020,21-09-2020,16-12-2020
    232,23-03-2020,22-06-2020,21-09-2020,16-12-2020
    
    Project: domoticz-homeautomation-workbook
    Interpreter: dzVents
    Author: Robert W.B. Linn
    Version: 20200127
]]--

-- threshold in days to notify
-- if the difference of the current day to a keydates day equals threshold
-- then notify
local TH_KEYDATES = 1

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

-- the keydatescalendar file is updated once per year
local keydatesfile = '/home/pi/domoticz/scripts/dzVents/scripts/keydates.csv'
local sep = ","

-- read the csv file
function readandupdate(domoticz)
    -- read the file line by line.
    -- each line contains an array with device[1], dates[2...]
    for line in io.lines(keydatesfile) do
	    -- split the line by comma , (sep) and assign to a table
	    local keydatestable = line:split(sep)
	    local idx = tonumber(keydatestable[1])
	    -- flag to check if a keydate has been found
	    local datefound = 0
        -- the idx must be > 0 else not used	    
        if idx > 0 then
            -- check the dates, start at 2 because 1=idx
            for i = 2, #keydatestable do
                -- get the keydatesdate array entry
                local keydate = keydatestable[i]
                -- split the keydate into an array with 3 entries day, month, year (D,M,Y)
                local keydatesplit = keydate:split("-")
                -- calculate the daysdiff between now and the keydate
                local daysdiff = domoticz.helpers.datediffnow(keydatesplit[1], keydatesplit[2], keydatesplit[3])
                -- get he month which is array entry index 2
                local month = tonumber(keydatesplit[2])
                -- check if daysdiff => 0 and the date is not found
                if daysdiff >= 0 and datefound == 0 then
                    datefound = 1
                    print (domoticz.devices(idx).name .. '(' .. idx .. ')=' .. keydate .. ', days=' .. daysdiff)
                    -- update the device text with the new date
                    domoticz.devices(idx).updateText(keydate)
                    -- check number of days left compared to the threshold
                    -- i.e. if 1 day left, then notify using device name & text.
                    -- the device text contains the date
                    -- NOT USED = handled by the dzVents script keydates_calendar_notifier
                    if daysdiff == TH_KEYDATE then
		                -- print ('Device ' .. idx .. ' notifying...')
                        message = '[ACHTUNG] ' .. domoticz.devices(idx).name .. ' ' .. domoticz.devices(idx).text
                        -- update alert message
                        -- msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_RED, message)
                        domoticz.log(message, domoticz.LOG_INFO)
                        domoticz.notify(message)
                    end 
                end
            
                -- check if for the last entry daysdiff less 0, then no new date available
                -- this is used f.e. for hohenfelde as last keydate is sep or oct
                if i == #keydatestable and daysdiff < 0 then
                    datefound = 1
                    print (idx .. '=' .. keydate .. ', days=' .. daysdiff .. ', KEIN TERMIN')
                    -- update the device text with the info that there is no date (yet) available
                    domoticz.devices(idx).updateText('Kein neuer Termin')
                end
                
            end -- for
            
            -- check if a keydate has been found, if not then set Kein termin message
            if datefound == 0 then
                print (idx .. '=' .. 'KEIN TERMIN')
                -- update the device text with the info that there is no date (yet) available
                domoticz.devices(idx).updateText('Kein neuer Termin')
            end

            -- JUST SOME LEARNERS
            -- print the content
            -- for i = 1, #keydatestable do
            --  print( keydatestable[i] )
            -- end
            -- print device idx and length of the csv string
            -- print (keydatestable[1] .. "Length:" .. #keydatestable)
        end -- if idx > 0
    end
end

return {
	on = {
        timer = {
            -- for tests use every minute
            -- 'every minute'
	        'at 00:30'
        }
    },
	execute = function(domoticz)
        readandupdate(domoticz)
	end
}
