-- thermostat_makelab_info.lua
-- get information from the makelab Thermostat
-- HmIP-eTRV-2 000A18A9A64DAC:1
-- Obtain the setpoint
-- http://cu-ip/config/xmlapi/state.cgi?datapoint_id=1584
-- <?xml version="1.0" encoding="ISO-8859-1"?><state><datapoint value="12.000000" ise_id="1584"/></state>
-- NOTE:
-- This script is replaced by the domoticz python plugin hmip-etrv-2.
-- 20190630 by rwbl

-- Domoticz device text (named MakeLab Thermostat Info)
local IDX_THERMOSTAT_MAKELAB_INFO = 175;

-- homematic defines
local ID_DEVICE = 1541;

-- url of the CCU to obtain device information
local URL_CCU = 'http://192.168.1.225/config/xmlapi/state.cgi?device_id=' .. ID_DEVICE;

-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'thermostatmakelabinfo';

-- helper to round a number to n decimals
local DECIMALS = 2;

return {
	on = {
	    timer = {
	        'every minute'    
        },
		httpResponses = {
			RES_CCU -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)
		-- domoticz.log('Device ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).name .. ' was changed to ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).state, domoticz.LOG_INFO)

        -- check if the item is a device, then request information
		if (item.isTimer) then
			domoticz.openURL({ url = URL_CCU, method = 'GET', callback = RES_CCU })
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then

                -- multiple datapoints
			    -- domoticz.log(item.data);
			    -- parse the response using XPath
			    -- select the attribute value of the datapoint element (this is XPath syntax)
			    
			    -- SETPOINT
			    -- <datapoint ise_id="1584" name="HmIP-RF.000A18A9A64DAC:1.SET_POINT_TEMPERATURE" operations="7" timestamp="1561200486" valueunit="Â°C" valuetype="4" value="4.500000" type="SET_POINT_TEMPERATURE"/>
                local setpointvalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1584"]/@value')   -- C
                -- TEMPERATURE
                -- <datapoint ise_id="1567" name="HmIP-RF.000A18A9A64DAC:1.ACTUAL_TEMPERATURE" operations="5" timestamp="1561200486" valueunit="" valuetype="4" value="23.900000" type="ACTUAL_TEMPERATURE"/>
                local temperaturevalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1567"]/@value')  -- Wh
                
                -- log
                domoticz.log('Setpoint: ' .. setpointvalue) 
                domoticz.log('Temperature: ' .. temperaturevalue) 
                local msg = 'Setpoint: ' .. tostring(domoticz.helpers.roundnumber(setpointvalue,1)) .. ', Temperature: ' .. tostring(domoticz.helpers.roundnumber(temperaturevalue,1))
				
				-- update the thermostat info device
				domoticz.devices(IDX_THERMOSTAT_MAKELAB_INFO).updateText(msg);
				
			else

				domoticz.log('[ERROR] Problem handling the request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end

    end
}
