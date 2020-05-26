--[[
    waste_calendar_notifier.lua
    The notifier informs via email 
    (receipients defined in the Domoticz Settings Email and Notification) 
    if the waste target date is 1 days from actual date.
    Project: mysmarthome
    Interpreter: dzVents, Timer
    See: mysmarthome.pdf
    Author: Robert W.B. Linn
    Version: 20180912
]]--

-- Check if the difference between now and the targetdate is 1
function checknotify(domoticz,device,threshold)
	-- domoticz.log('Device ' .. device.name .. ', Text:' .. device.text, domoticz.LOG_INFO)
    -- split the device text holding the wastecal date in format DD-MM-YYYY
	targetdate = domoticz.helpers.split(device.text, '-')
	-- calculate the remaining days
    daysremaining = domoticz.helpers.datediffnow(tonumber(targetdate[1]), tonumber(targetdate[2]), tonumber(targetdate[3]))
    -- check against threshold and notify
    if (daysremaining == threshold) then
        message = '[ACHTUNG] ' .. device.name .. ' ' .. device.text
        -- update alert message
        domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_RED, message)
    	domoticz.log(message, domoticz.LOG_INFO)
        domoticz.notify(message)
    end
end

-- Idx of the devices
local IDX_BIOTONNEPI = 98
local IDX_PAPIERPI = 99
local IDX_RESTMUELLPI = 100
local IDX_GELBERSACKPI = 101
local IDX_SCHADSTOFFPI = 102
local IDX_BIOTONNEHO = 103
local IDX_PAPIERHO = 104
local IDX_RESTMUELLHO = 105
local IDX_GELBERSACKHO = 106

-- threshold in days to notify
-- if the difference of the current day to a wastecalendarday equals threshold
-- then notify
local TH_WASTECAL = 1

return {
	on = {
	    timer = {
            'at 01:00'
            -- 'every minute'
	    },
	},
	execute = function(domoticz)
	    
	    checknotify(domoticz,domoticz.devices(IDX_BIOTONNEPI),TH_WASTECAL)
	    checknotify(domoticz,domoticz.devices(IDX_PAPIERPI),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_RESTMUELLPI),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_GELBERSACKPI),TH_WASTECAL)
        -- checknotify(domoticz,domoticz.devices(IDX_SCHADSTOFFPI),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_BIOTONNEHO),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_PAPIERHO),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_RESTMUELLHO),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_GELBERSACKHO),TH_WASTECAL)

    end
}

