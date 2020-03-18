
-- thermostat_makelab_info
-- Get information from the makelab homematicIP thermostat
-- HmIP-eTRV-2 000A18A9A64DAC:1
-- Obtain the device information and extract the setpoint & temperature from the response
-- http://ccu-ip/config/xmlapi/state.cgi?device_id=1541
-- Extract from the response showing the datapoints 1567 (temperature) and 1584 (setpoint)
-- <?xml version="1.0" encoding="ISO-8859-1"?>
-- <state>
--  <device config_pending="false" unreach="false" ise_id="1541" name="HmIP-eTRV-2 000A18A9A64DAC">
--      <channel ise_id="1565" name="HmIP-eTRV-2 000A18A9A64DAC:1">
--          <datapoint ise_id="1567" name="HmIP-RF.000A18A9A64DAC:1.ACTUAL_TEMPERATURE" timestamp="1575647467" valueunit="" valuetype="4" value="19.300000" type="ACTUAL_TEMPERATURE"/>
--          <datapoint ise_id="1584" name="HmIP-RF.000A18A9A64DAC:1.SET_POINT_TEMPERATURE" timestamp="1575647467" valueunit="°C" valuetype="4" value="20.000000" type="SET_POINT_TEMPERATURE"/>
--      </channel>
--  </device>
-- </state>

-- Domoticz device text (named MakeLab Thermostat Info)
local IDX_MAKELAB_THERMOSTAT_INFO = 50;

local ID_DEVICE = 1541;

-- url of the raspmatic webserver to obtain device information
local URL_RASPMATIC = 'http://ccu-ip/config/xmlapi/state.cgi?device_id=' .. ID_DEVICE;

-- callback of the url request - must be unique across all automation events
local RES_RASPMATIC = 'RES_makelab_thermostat_info';

-- helper to round a number to n decimals
local DECIMALS = 1;

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

                -- multiple datapoints
			    -- domoticz.log(item.data);
			    -- parse the response using XPath
			    -- select the attribute value of the datapoint element (this is XPath syntax)
			    
			    -- SETPOINT
			    -- <datapoint ise_id="1584" name="HmIP-RF.000A18A9A64DAC:1.SET_POINT_TEMPERATURE" operations="7" timestamp="1561200486" valueunit="°C" valuetype="4" value="4.500000" type="SET_POINT_TEMPERATURE"/>
                local setpointvalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1584"]/@value')   -- C
                -- TEMPERATURE
                -- <datapoint ise_id="1567" name="HmIP-RF.000A18A9A64DAC:1.ACTUAL_TEMPERATURE" operations="5" timestamp="1561200486" valueunit="" valuetype="4" value="23.900000" type="ACTUAL_TEMPERATURE"/>
                local temperaturevalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1567"]/@value')  -- C
                
                -- log
                local msg = 'Setpoint: ' .. tostring(round(setpointvalue,DECIMALS)) .. ', Temperature: ' .. tostring(round(temperaturevalue,DECIMALS))
                domoticz.log(msg) 
				
				-- update the domoticz device
				domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).updateText(msg);
				
			else

				domoticz.log('[ERROR] Handling request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end

    end
}
