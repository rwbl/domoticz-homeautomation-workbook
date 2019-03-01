--[[
    coffee_machine_monitor.lua
    Monitors the electric usage between 07:00-08:30.
    If > 1500 (Threshold) then the cofee machine is turned oh.
    The machine stays on for 2 hours, then switches off.
    Update the alert message with switch off time.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20180926
]]--

-- Module msgbox: /home/pi/domoticz/scripts/dzVents/scripts
local msgbox = require('msgbox')

-- Idx of the devices
local IDX_STROMVERBRAUCH = 44
local TH_STROMVERBRAUCH = 1100

local MONITOR_START_END = 'at 07:00-09:00'

return {
	on = {
	    timer = {
    	    MONITOR_START_END
	    },
	},
	data = {
       notified = { initial = 0 }
    },
	execute = function(domoticz)

        -- Check if below threshold and notified flag set
        -- Action: reset notified flag
        if (domoticz.devices(IDX_STROMVERBRAUCH).WhActual < TH_STROMVERBRAUCH) and (domoticz.data.notified == 1) then
            domoticz.data.notified = 0
        end

        -- Check if above threshold and notified flag not set
        -- Action: set notified flag anf alert message
        if (domoticz.devices(IDX_STROMVERBRAUCH).WhActual > TH_STROMVERBRAUCH) and (domoticz.data.notified == 0) then
            -- set notified flag
            domoticz.data.notified = 1
            -- get the time on and log
    	    timeon = os.date("*t")
    	    message = ('Kaffee Machine an %02d:%02d'):format(timeon.hour, timeon.min)
            domoticz.log(message, domoticz.LOG_INFO)
            -- calculate the time off = timeon + 2 hours
            timeoff = os.date("*t", os.time() + 2*60*60)
            -- define message to notify the time coffee machine switches off
            message = ('Kaffee Machine aus %02d:%02d'):format(timeoff.hour, timeoff.min)
            -- update alert message
            msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_ORANGE, message)
            domoticz.log(message, domoticz.LOG_INFO)
        end

    end
}

