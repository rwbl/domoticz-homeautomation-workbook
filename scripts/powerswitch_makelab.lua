--[[
-- powerswitch_makelab.lua
-- switch the homematic powerplug device (located in the makelab) on / off.
-- the device HMIP-PSM is an actuator switch with status report measured value channel.
-- switching is triggered by sending an url request to raspberrymatic server using the xmlapi addon.
-- the url request uses the xmlapi script statechange with the channel id nd the new value.
-- example switching the plug on: http://192.168.1.225/config/xmlapi/statechange.cgi?ise_id=1451&new_value=true
-- response XML string:
-- <?xml version="1.0" encoding="ISO-8859-1"?><result><changed id="1451" new_value="true"/></result>
-- notes:
-- to obtain the channel id, use the url: http://ccu-ip/config/xmlapi/statelist.cgi
-- then search for the device, i.e. HMIP-PSM 0001D3C99C6AB3 which is taken from the HomeMatic Web-UI
-- NOTE:
-- This scripts is replaced by the domoticz python plugin hmip-psm. 
-- 20190630 by rwbl
]]--

-- Domoticz device switch on/off (named MakeLab Powerswitch)
local IDX_POWERSWITCH_MAKELAB = 177;

-- RaspMatic switch datapoint id (name="HmIP-RF.0001D3C99C6AB3:3.STATE") from device HMIP-PSM 0001D3C99C6AB3:3
-- <channel ise_id="1446" name="HMIP-PSM 0001D3C99C6AB3:3" operate="true" visible="true" index="3">
--  <datapoint ise_id="1451" name="HmIP-RF.0001D3C99C6AB3:3.STATE" type="STATE" operations="7" timestamp="1561132973" valueunit="" valuetype="2" value="false"/>
-- </channel>
local ID_DATAPOINT_STATE = 1451

-- CCU url to switch on/off. use statechange.cgi with value true/false
local URL_CCU = 'http://192.168.1.225/config/xmlapi/statechange.cgi?ise_id=' .. ID_DATAPOINT_STATE .. '&new_value='
-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'powerswitchmakelab';

return {
	on = {
		devices = {
			IDX_POWERSWITCH_MAKELAB
		},
		httpResponses = {
			RES_CCU -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)

        if (item.isDevice) then
    		domoticz.log('Device ' .. domoticz.devices(IDX_POWERSWITCH_MAKELAB).name .. ' was changed to ' .. domoticz.devices(IDX_POWERSWITCH_MAKELAB).state, domoticz.LOG_INFO);
            local state = 'true';		
		    -- check the switch state
		    if domoticz.devices(IDX_POWERSWITCH_MAKELAB).state == 'Off' then
		        state = 'false';
		    end

            -- send the url
            domoticz.openURL({ url = URL_CCU .. state, method = 'GET',	callback = RES_CCU });
        end;

        -- check if the item is a http response from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then
				domoticz.log('[INFO] Switch : ' .. item.statusText)
			else
				domoticz.log('[ERROR] Can not switch :' .. item.statusText, domoticz.LOG_ERROR)
			end
		end

	end
}
