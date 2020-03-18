--[[
    electric_usage_update.lua
    Send, every 3 minutes, a HTTP Request (GET) to the Raspberry Pi running the volkszaehler.
    The volkszaehler resonse is a JSON string.
    Update the Powerconsumption device (44, VirtualSensors,Stromverbrauch,Usage,Electric,2205.58 Watt).

    Request Examples
    data last 5 minutes (ensure to replace the space by a +
    requesturl = 'http://vz-ip-address/middleware.php/data/958bce60-b342-11e8-b54f-bbec0573e1f4.json?from=5+minutes+ago&to=now'
    data now
    requesturl = 'http://vz-ip-address/middleware.php/data/958bce60-b342-11e8-b54f-bbec0573e1f4.json?from=now&to=now',

    Request Result JSON string
    {"version":"0.3","data":{"tuples":###,"uuid":"958bce60-b342-11e8-b54f-bbec0573e1f4","from":1536243168796,"to":1536243170351,"min":[1536243170351,926.0450147835],"max":[1536243170351,926.0450147835],"average":926.045,"consumption":0.4,"rows":2}}
    Obtain the powerconsumption from key data.average

    For testing, add 'every minute' to the timer and check the log file.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 201809111
]]--

-- The request url uses from=5 minutes ago to to=now
local requesturl = 'http://vz-ip-address/middleware.php/data/958bce60-b342-11e8-b54f-bbec0573e1f4.json?from=5+minutes+ago&to=now'

-- Idx of the devices
local IDX_POWERCONSUMPTION = 44

return {
    -- active = true,
	on = {
		timer = {
			'every 3 minutes'
			-- 'every minute'
		},
		httpResponses = {
            'electricusageData'
        }
	},
	execute = function(domoticz, item)
        -- if the timer is executed, then place http get request, which result is handled by the callback.
        if (item.isTimer) then
            domoticz.openURL({
                url = requesturl,
                method = 'GET',
                callback = 'electricusageData'
            })
		end
		-- callback handling the url get request response
        if (item.isHTTPResponse) then
            -- for tests log the data requested (json string)
			-- domoticz.log(item.data)

            if (item.ok) then -- statusCode == 2xx
                -- parse the json string to get the average from key data.average
                local powerconsumption = tonumber(item.json.data.average)

                -- update the powerconsumption device
                domoticz.devices(IDX_POWERCONSUMPTION).updateEnergy(math.floor(powerconsumption))

                domoticz.log('[INFO] Electric usage updated: ' .. powerconsumption .. ' ' .. tostring(item.statusCode), domoticz.LOG_INFO)
            end

            if not (item.ok) then -- statusCode != 2xx
                local message = '[ERROR] Electric usage: ' .. tostring(item.statusCode) .. ' ' .. msgbox.isnowdatetime(domoticz)
                domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_YELLOW, message)
                domoticz.log(message, domoticz.LOG_INFO)
            end
        end
	end
}


