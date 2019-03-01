--[[
    astro_info.lua
    Display the sunrise and sunset time plus daylength in a virtual text sensor.
    Updated once a day.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20181001
]]--

local utils = require('utils')
-- local msgbox = require('msgbox')

-- Idx of the devices
local IDX_SUNRISESET = 121

return {
    -- active = true,
    on = {
        timer = {
            -- 'every minute'
	        'at 01:00'
        }
    },
    execute = function(domoticz, timer)

        local daylength = domoticz.time.sunsetInMinutes - domoticz.time.sunriseInMinutes
        local msg = utils.MinutesToClock(domoticz.time.sunriseInMinutes)..' - '..utils.MinutesToClock(domoticz.time.sunsetInMinutes)..' ('..utils.MinutesToClock(daylength)..')'
        domoticz.devices(IDX_SUNRISESET).updateText(msg)
        domoticz.log(msg)

    end
}



