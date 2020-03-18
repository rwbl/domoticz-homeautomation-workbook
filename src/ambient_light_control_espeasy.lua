--[[
    ambient_light_control_espeasy.lua
    Measure the ambient light Lux value and if below threshold switch on hue light.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190227
]]--

-- Idx of the devices used
local IDX_AMBIENT_LIGHT = 46
local IDX_HUE_MAKELAB = 118
local IDX_TH_AMBIENT_LIGHT = 10

return {
	on = {
		devices = {
			IDX_AMBIENT_LIGHT
		}
	},
	execute = function(domoticz, device)
	    -- get the threshold
	    local althreshold = domoticz.variables(IDX_TH_AMBIENT_LIGHT).value
	    
		domoticz.log('Device ' .. device.name .. ' changed to ' .. tostring(device.lux) .. ' / ' .. tostring(althreshold), domoticz.LOG_INFO)
		
		-- check threshold
        if (device.lux < althreshold) and (domoticz.devices(IDX_HUE_MAKELAB).state == 'Off') then
    		domoticz.log('Ambient Light below threshold. Switched on light', domoticz.LOG_INFO)
            domoticz.devices(IDX_HUE_MAKELAB).switchOn()
            -- optional check leveland set to default 20%
            if domoticz.devices(IDX_HUE_MAKELAB).level  < 20 then
                domoticz.devices(IDX_HUE_MAKELAB).dimTo(20)
            end
        end
    end
}

