--[[
    days_to_go_update.lua
    Update days-to-go once per day for virtual devices: idx=29,57,97
    For testing, add 'every minute' to the timer and check the log file.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190213
]]--

-- Idx of the devices
local IDX_DAYSPHASE = 29; 
local IDX_DAYSLOUIS = 57;
local IDX_DAYSFELIX = 97; 
local IDX_DAYSLANZAROTE = 142; 

-- Event
return {
    on = {
        timer = {
            'at 01:00'
            -- 'every minute'
        }       
    },
    execute = function(domoticz, timer)
        -- domoticz.log('Event triggerd by rule: ' .. timer.trigger)

		-- For each days-to-go device:
		-- calculate the days difference between target date and now, 
		-- define the text to display and update the device

		-- Phase4 days left
		domoticz.devices(IDX_DAYSPHASE).updateText(tostring(domoticz.helpers.datediffnow2(1,9,2021)) .. ' T')
		-- Louis days since birth
		domoticz.devices(IDX_DAYSLOUIS).updateText(domoticz.helpers.ageyearsdays(domoticz,7,9,2016))
		-- FELIX days since birth
		domoticz.devices(IDX_DAYSFELIX).updateText(domoticz.helpers.ageyearsdays(domoticz,13,2,2019))
		-- Lanzarote Urlaub days till
		domoticz.devices(IDX_DAYSLANZAROTE).updateText(tostring(domoticz.helpers.datediffnow2(12,3,2019)) .. ' T')

end
}

