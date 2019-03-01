--[[
    volumio_play.lua
    Set the volumio to play or stop by sending API request using the command play or stop.
    After pressing play ON or OFF, the switch Volumio Update State is turned on.
    This triggers the script volumio_getstate and updates the song and play state.

    Request Example setting command play:
    requesturl = 'volumio.local/api/v1/commands/?cmd=play
    Response:
    {"time":1551340573349,"response":"play Success"}

    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190228
]]--

-- External modules: /home/pi/domoticz/scripts/dzVents/scripts
local msgbox = require('msgbox')
 
-- Request url (see reference https://volumio.github.io/docs/API/REST_API.html)
-- Example setting the Volumiovolume to 80:
-- volumio.local/api/v1/commands/?cmd=volume&volume=80
-- Response: 
-- {"time":1549566800842,"response":"volume Success"}
-- Added to the url is the value (level) of the switch (dimmer)
local cmdurl = 'volumio.local/api/v1/commands/?cmd='
-- local cmdplay = 'play&N=0'   -- play with first queu track as default
local cmdplay = 'play&N='   -- the track queu number is added from user variable DEF_VOLUMIO_TRACK
local cmdstop = 'stop'
local cmd

-- Idx of the devices
local IDX_VOLUMIOPLAYSWITCH = 149
local IDX_VOLUMIOSTATUS = 151
local IDX_VOLUMIOUPDATESTATESWITCH = 155
local IDX_DEF_VOLUMIO_TRACK = 11

-- Messages
local MSGVOLUMIOPLAY = 'PLAY'
local MSGVOLUMIOSTOP = 'STOP'
local MSGVOLUMIOOFF = 'OFF'
local MSGVOLUMIOERROR = 'ERROR'

return {
	on = {
		devices = {
			IDX_VOLUMIOPLAYSWITCH
		},
		httpResponses = {
            'volumioPlay'
        }
	},
	execute = function(domoticz, item)
		domoticz.log('Device ' .. domoticz.devices(IDX_VOLUMIOPLAYSWITCH).name .. ' was changed:' .. tostring(domoticz.devices(IDX_VOLUMIOPLAYSWITCH).state), domoticz.LOG_INFO)

        -- if the device is changed then set volumio to play or stop
		if (item.isDevice) then

            -- check if the device has been switched on or off 
            -- to set the command
            if (domoticz.devices(IDX_VOLUMIOPLAYSWITCH).state == 'On') then
                cmd = cmdplay .. tostring(domoticz.variables(IDX_DEF_VOLUMIO_TRACK).value)
        		domoticz.log(cmd, domoticz.LOG_INFO)
                domoticz.devices(IDX_VOLUMIOSTATUS).updateAlertSensor(1, MSGVOLUMIOPLAY)
            else
                cmd = cmdstop
                domoticz.devices(IDX_VOLUMIOSTATUS).updateAlertSensor(2, MSGVOLUMIOSTOP)
            end

            -- set play mode play or stop via api request
            domoticz.openURL({
                url = cmdurl .. cmd,
                method = 'GET',
                callback = 'volumioPlay'
            })

    	end

		-- callback handling the url get request response
        if (item.isHTTPResponse) then

            if (item.ok) then -- statusCode == 2xx
                domoticz.log('[INFO] Volumio Play set to ' .. domoticz.devices(IDX_VOLUMIOPLAYSWITCH).state, domoticz.LOG_INFO)
            end

            if not (item.ok) then -- statusCode != 2xx
                domoticz.devices(IDX_VOLUMIOSTATUS).updateAlertSensor(4, MSGVOLUMIOOFF)
                local message = '[ERROR] Volumio Set Play Mode: ' .. tostring(item.statusCode) .. ' ' .. msgbox.isnowdatetime(domoticz)
                msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_YELLOW, message)
                domoticz.log(message, domoticz.LOG_INFO)
            end

        end

	end
}

