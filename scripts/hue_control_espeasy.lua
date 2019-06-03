--[[
    hue_control_espeasy.lua
    Control a Hue Light via ESO8266 NodeMCU running ESPEasy.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190222
]]--

-- Idx of the devices used
local IDX_ESPEASY_HUE_LIGHT = 154
local IDX_HUE_MAKELAB = 118

return {
	on = {
		devices = {
		    IDX_ESPEASY_HUE_LIGHT
		},
	},
    data = {
      prevvalue = { initial = -1 }
    },
	execute = function(domoticz, device)
        local currvalue = math.floor(tonumber(device.text))
	    if domoticz.data.prevvalue == -1 then
	        domoticz.data.prevvalue = currvalue 
	    end
		domoticz.log('Device ' .. device.name .. ' changed from ' ..  tostring(domoticz.data.prevvalue) .. ' to ' .. tostring(currvalue), domoticz.LOG_INFO)
        --  handle noise, i.e. make changes delta > 1
        if (math.abs(domoticz.data.prevvalue - currvalue)) > 1 then
            domoticz.data.prevvalue = currvalue
	        if (domoticz.devices(IDX_HUE_MAKELAB).state == 'Off') then
	            domoticz.devices(IDX_HUE_MAKELAB).switchOn()
		    end
            domoticz.devices(IDX_HUE_MAKELAB).dimTo(currvalue)
        end
	end
}

