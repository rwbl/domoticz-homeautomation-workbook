--[[
    alertmsg_reset.lua
    If the "Alert Meldung Reset" switch is turned ON, 
    the text of the alert sensor (idx=55) is set to the value of the User Variable DEF_ALERTMSG and 
    the switch is turned OFF again.    
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20180909
]]--

-- Idx of the devices used
-- Switch Alert Meldung Reset
local IDX_ALERTMSG_RESET = 119

return {
    -- Check which device(s) have a state change
	on = {
		devices = {
			IDX_ALERTMSG_RESET
		}
	},
    -- Handle the switch if its state has changed to On
	execute = function(domoticz, device)
		domoticz.log('Device ' .. device.name .. ' was changed ' .. domoticz.devices(domoticz.variables('IDX_ALERTMSG').value).text, domoticz.LOG_INFO)
	    if (device.state == 'On') then
            -- only change if the current text differs from the default text
	        if (domoticz.devices(domoticz.variables('IDX_ALERTMSG').value).text ~= domoticz.variables('DEF_ALERTMSG').value) then
                local message = domoticz.variables('DEF_ALERTMSG').value
                domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_GREY, message)
                -- msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_GREY, message)
                domoticz.log(message)
            end
	        device.switchOff()
		end
	end
}

