--[[
    hue_wz_timer.lua
    Turn WZ Hue lamps on & off by given time: ON at sunset, OFF at 23:00.
    Update the alert message.
    IMPORTANT: Ensure the timer and the timer trigger are the same.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20181128
]]--

-- Idx of the devices
local IDX_HUE_WZABLAGE = 111
local IDX_HUE_WZTV = 112
local IDX_HUE_HAUSTUER = 110

-- Update alert message with alert level green.
local function setalertmsg(domoticz, state)
	local message= 'Hue Lampen ' .. state .. ' ' .. domoticz.helpers.isnowhhmm(domoticz)
    domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_GREEN, message)
end

local function hueswitchon(domoticz)
	domoticz.devices(IDX_HUE_WZABLAGE).switchOn()
    domoticz.devices(IDX_HUE_WZTV).switchOn()
    domoticz.devices(IDX_HUE_HAUSTUER).switchOn()
    setalertmsg(domoticz, 'an')
end

local function hueswitchoff(domoticz)
    domoticz.devices(IDX_HUE_WZABLAGE).switchOff()
    domoticz.devices(IDX_HUE_WZTV).switchOff()
    domoticz.devices(IDX_HUE_HAUSTUER).switchOff()
    setalertmsg(domoticz, 'aus')
end

return {
    active = true,
    on = {
        timer = {
            '60 minutes before sunset',
	        '30 minutes before sunset',
	        'at 23:00',
	        'at 07:00',
	        'at 08:00'
        }
    },
    execute = function(domoticz, timer)

        -- in the evening send message hue lights will be switched on
        if (timer.trigger == '60 minutes before sunset') then
            -- format date & time see www.lua.org/pil/22.1.html. X = time.
            local now=os.time()
            local nowplus30minutes = domoticz.helpers.converttimehhmm(domoticz,os.date("%X",now+(30*60)))
        	local message= 'Hue Lampen gehen an ' .. nowplus30minutes
            domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_GREEN, message)
        end

        -- switch the hue lights on & off in the evening
        if (timer.trigger == '30 minutes before sunset') then hueswitchon(domoticz) end
        if (timer.trigger == 'at 23:00') then hueswitchoff(domoticz) end

        -- switch the hue lights on & off in the morning
        -- NOT USED
        -- if (timer.trigger == 'at 07:00') then hueswitchon(domoticz) end
        -- if (timer.trigger == 'at 08:00') then hueswitchoff(domoticz) end

    end
}

