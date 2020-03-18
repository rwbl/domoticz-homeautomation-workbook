-- Domoticz Home Automation Workbook - Function Time Control
-- dzVents Automation Script: time_control
-- This solution uses a switch device to start & stop time tracking and a text device to provide information on time spent per block and day.
-- The switch device bar chart log provides a nice overview on the time spent.
-- A dzVents Lua Automation Script runs every minute and updates the text device with the time spent on the current block, day total and daily limit in hours.
-- The daiy limit can be set via a user variable. if not defined the daily limit is not used or if defined but value is 0, then also not used.
-- VirtualDevices
-- Type: Light/Switch, SubType:Switch,SwitchType: On/Off, Name: Time Control, Idx: 101, Add to dashboard.
-- Type: General, SubType:Text, Name: Time Control Status, Idx: 106, Add to dashboard.
-- 20200220 by rwbL

-- Idx of the devices used
IDXTRACK = 101          -- switch on/off
IDXSTATUS = 106         -- text status
IDXTHTIMECONTROL = 2    -- user var threshold time control (TH_TIMECONTROL)

-- The value to increment on every timer update: minutes/60 to get an hour.
-- Examples: timer every minute: 1/60, every 5 minutes = 5/60 
INCREMENTVALUE = (1/60)

--
-- Helpers
--
-- Returns rounded number
function roundNumber(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

function roundsValue(svalue)
    return roundNumber(tonumber(svalue),2)
end
-- split a string by delimiter
-- return array, i.e. array[1], array[2]
function splitstring(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- get the current time from the domoticz instance with time object
-- return time now, i.e. 09:09
function isnowhhmm(domoticz)
    local timearray = splitstring(domoticz.time.rawTime, ':')
    return timearray[1] .. ':' .. timearray[2]
end

--
-- Check daily limit (threshold)
--
function checkLimit(domoticz)
    local msg
    -- get the latest value of the user var because it might have changed
    domoticz.data.daylimit = domoticz.variables(IDXTHTIMECONTROL).value
	if (domoticz.data.daylimit == 0) or 
	   (domoticz.variables(IDXTHTIMECONTROL).value == nil) then 
	    return
    end
    -- check if dayvalue beyond daily limit and if not already notified
	if (domoticz.data.dayvalue > domoticz.data.daylimit) and 
	   (domoticz.data.notified == 0) then 
	    msg = string.format('%s: Day=%.4f, Daily threshold reached %.2f hrs', 
            isnowhhmm(domoticz),
	        domoticz.data.dayvalue, 
	        domoticz.data.daylimit)
	    domoticz.notify('Time Control', msg, domoticz.PRIORITY_LOW)
	    domoticz.log(msg, domoticz.LOG_INFO)
	    domoticz.data.notified = 1
	    return
	end
    -- check if the daylimit has increased, i.e made a change whilst already notified. if so, reset notified
	if (domoticz.data.dayvalue < domoticz.data.daylimit) and 
	   (domoticz.data.notified == 1) then 
	    domoticz.data.notified = 0
	    msg = string.format('%s: Day=%.4f, Daily threshold reset %.2f hrs', 
            isnowhhmm(domoticz),
	        domoticz.data.dayvalue, 
	        domoticz.data.daylimit)
	    domoticz.log(msg, domoticz.LOG_INFO)
	end
end

-- update the text status device
-- parameter:
-- action - Start, Update, Stop, Reset
-- note: the number of digits displayed is set by %.Nf.
-- for detailed info use 4 else 2.
function updateStatus(domoticz, action)
    checkLimit(domoticz)
	local msg = string.format('%s %s: Block=%.2f, Day=%.2f, Limit=%.2f hrs',
            isnowhhmm(domoticz),
            action,
	        domoticz.data.blockvalue,
	        domoticz.data.dayvalue,
	        domoticz.data.daylimit)
    domoticz.devices(IDXSTATUS).updateText(msg)
	domoticz.log(msg, domoticz.LOG_INFO)
end

-- update tracking data
-- increment value for block & day and update the text status device
function updateData(domoticz)
    domoticz.data.blockvalue = domoticz.data.blockvalue + INCREMENTVALUE
	domoticz.data.dayvalue = domoticz.data.dayvalue + INCREMENTVALUE
    updateStatus(domoticz, 'Update')
end

-- start or stop time tracking
function setTrack(domoticz)
    if (domoticz.devices(IDXTRACK).state == 'Off') then
        updateStatus(domoticz, 'Stopped')
    else
	    domoticz.data.blockvalue = 0
        updateStatus(domoticz, 'Started')
    end
end

-- reset at the beginning of a day the block & day values
function resetDay(domoticz)
	domoticz.data.blockvalue = 0
	updateStatus(domoticz, 'Day Reset')
	domoticz.data.dayvalue = 0
	domoticz.data.notified = 0
end    

return {
    -- handle timer and swith device change on or off
    on = {
        timer = { 'every minute', 'at 00:15' }, 
        devices = { IDXTRACK }
    },

    -- data used to keep track    
    data = {
        blockvalue = { initial = 0 },
        dayvalue = { initial = 0 },
        daylimit = { initial = 0 },
        notified = { initial = 0 }
    },
	
	execute = function(domoticz, item)
	    -- timer to update the data reguraly if switch is on
	    if (item.isTimer) and
	       (domoticz.time.matchesRule('every minute')) and 
           (domoticz.devices(IDXTRACK).state == 'On') then
           updateData(domoticz)
           return
        end
        -- reset the day after midnight
        if (item.isTimer) and
           (domoticz.time.matchesRule('at 00:15')) then
           resetDay(domoticz)
           return
        end
        -- handle switch change on or off
        if (item.isDevice) and 
           (item.idx == IDXTRACK) then
           setTrack(domoticz)
           return
        end

    end
}
