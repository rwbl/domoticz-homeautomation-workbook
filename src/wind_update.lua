--[[
    wind_update.lua
	If the a value of the device Windmesser (idx=28) changes, 
	update the value (Wind direction & speed) of 
	the Virtual Sensor Wind named Wind (ix=117)
    Use print(device.dump()) ONLY ONCE to get the properties.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20180910
]]--

-- Idx of the devices
local IDX_WINDMESSER = 28;
local IDX_WIND = 117;

-- Event handling changes of the Windmesser device
return {
	on = {
		devices = {
			IDX_WINDMESSER
		}
	},
	execute = function(domoticz, device)
        -- print(device.dump())
		-- domoticz.log('Device ' .. device.name .. ' changed ', domoticz.LOG_INFO)

        bearing = device.direction
        direction = device.directionString
        speed = device.speed
        gust = device.gust
        temperature = device.temperature
        chill = device.chill

        -- Update the virtual sensor Luftdruck
		domoticz.devices(IDX_WIND).updateWind(bearing, direction, speed, gust, temperature, chill)
	end
}

