--[[
    luftdruck_update.lua
    If the a value of the BMP280 device (idx=115) has changed, 
    update the value of the Virtual Sensor Barometer named Luftdruck (idx=116)
    Use print(device.dump()) ONLY ONCE to get the properties.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20180911
]]--

-- Idx of the devices
local IDX_BMP280 = 115;
local IDX_LUFTDRUCK = 116;
local DEF_BMP280_COMPENSATION = 0


-- Event handling changes of the BMP280 device
return {
	on = {
		devices = {
			IDX_BMP280
		}
	},
	execute = function(domoticz, device)
        -- print(device.dump())

		-- domoticz.log('Device ' .. device.name .. ' changed ', domoticz.LOG_INFO)
		domoticz.log('Barometer: B=' .. device.barometer .. '/F=' .. device.forecast .. '/FS=' .. device.forecastString, domoticz.LOG_INFO)

        -- Round the pressure
		pressure = math.floor(device.barometer) + DEF_BMP280_COMPENSATION

		-- Forecast from the BMP device to the Barometer device
		-- See source code RFXNames.cpp, BMP_Forecast_Desc
        -- Map the BMP_Forecase_Desc string to dzEvents Forecast value:
        -- domoticz.BARO_STABLE, BARO_SUNNY, BARO_CLOUDY, BARO_UNSTABLE, BARO_THUNDERSTORM

        forecast = -1
		if (device.forecastString == 'Stable') then forecast = domoticz.BARO_STABLE end
        if (device.forecastString == 'Sunny') then forecast = domoticz.BARO_SUNNY end
	    if (device.forecastString == 'Cloudy') then forecast = domoticz.BARO_CLOUDY end
	    if (device.forecastString == 'Unstable') then forecast = domoticz.BARO_UNSTABLE end
	    if (device.forecastString == 'Thunderstorm') then forecast = domoticz.BARO_THUNDERSTORM end
	    if (device.forecastString == 'Unknown') then forecast = domoticz.BARO_STABLE end
	    if (device.forecastString == 'Cloudy/Rain') then forecast = domoticz.BARO_CLOUDY end

        -- Update the virtual sensor Luftdruck
		domoticz.devices(IDX_LUFTDRUCK).updateBarometer(pressure, forecast)
	end
}
