--[[
-- electric_usage_makelab.lua
-- url request from the homematic (raspberrymatic) server, to obtain power & energy data from a single device.
-- url 'http://ccu-ip/config/xmlapi/state.cgi?device_id=1418'
-- device HMIP-PSM is an actuator switch with status report measured value channel
-- NOTE:
-- This script is replaced by the domoticz python plugin hmip-psm.
-- 20190630 by rwbl
]]--

-- domoticz device hw virtualsensors, type general, subtype kwh
local IDX_ELECTRICUSAGEMAKELAB = 174;

-- homematic defines
local ID_DEVICE = 1418;

-- url of the CCU to obtain device information
local URL_CCU = 'http://IP-CCU/config/xmlapi/state.cgi?device_id=' .. ID_DEVICE;

-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'electricusagemakelab';

-- helper to round a number to n decimals
local DECIMALS = 2;

return {
	on = {
		timer = {
			'every minute'
			-- 'every 5 minutes'
		},
		httpResponses = {
			RES_CCU -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)

        -- check the timer to place the url request
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
                local powervalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1471"]/@value')   -- W
                local energyvalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1467"]/@value')  -- Wh
                domoticz.log('Power Value: ' .. powervalue) 
                domoticz.log('Energy Value: ' .. energyvalue) 
				-- update the energy device with power and energyvalue
				domoticz.devices(IDX_ELECTRICUSAGEMAKELAB).updateElectricity(
				    domoticz.helpers.roundnumber(tonumber(powervalue),2),     -- W
				    domoticz.helpers.roundnumber(tonumber(energyvalue),2) )   -- Wh
                			    
			else

				domoticz.log('[ERROR] Problem handling the request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end

	end
}

