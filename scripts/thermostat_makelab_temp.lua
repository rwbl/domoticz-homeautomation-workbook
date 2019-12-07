-- thermostat_makelab_temp
-- Get information from the makelab homematicIP thermostat
-- HmIP-eTRV-2 000A18A9A64DAC:1
-- Obtain the device information and extract the temperature from the response
-- http://192.168.1.225/config/xmlapi/state.cgi?datapoint_id=1567
-- HTTP response showing the datapoints 1567 (temperature)
-- <?xml version="1.0" encoding="ISO-8859-1"?>
-- <state>
--  <datapoint value="22.400000" ise_id="1567"/>
-- </state>

-- Domoticz device text (named MakeLab Thermostat Info)
local IDX_MAKELAB_THERMOSTAT_TEMP = 65;

local ID_DATAPOINT = 1567;

-- url of the raspmatic webserver to obtain device information
local URL_RASPMATIC = 'http://192.168.1.225/config/xmlapi/state.cgi?datapoint_id=' .. ID_DATAPOINT;

-- callback of the url request - must be unique across all automation events
local RES_RASPMATIC = 'res_makelab_thermostat_temp';

-- helper to round a number to n decimals
local DECIMALS = 2;

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

return {
	on = {
	    timer = {
	        -- 'every minute'   -- for tests   
	        'every 5 minutes'
        },
		httpResponses = {
			RES_RASPMATIC -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)
		-- domoticz.log('Device ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).name .. ' was changed to ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).state, domoticz.LOG_INFO)

        -- check if the item is a device, then request information
		if (item.isTimer) then
			domoticz.openURL({url = URL_RASPMATIC, method = 'GET', callback = RES_RASPMATIC})
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then

                -- TEMPERATURE
                -- <datapoint value="22.400000" ise_id="1567"/>
                local temperaturevalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1567"]/@value')  -- C
                
                -- log
                local msg = 'Temperature: ' .. tostring(round(temperaturevalue,DECIMALS))
                domoticz.log(msg) 
				
				-- update the domoticz device
				domoticz.devices(IDX_MAKELAB_THERMOSTAT_TEMP).updateTemperature(round(temperaturevalue,1));
				
			else

				domoticz.log('[ERROR] Handling request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end

    end
}

