--[[
    security_reset.lua
    Reset the state to Normal for X10 switches as these do not reset by themselves from state Alarm + Tamper.
    Project: atHome
    Interpreter: dzVents, devices
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190519
]]--

-- Idx of the devices used
-- User variable holding the state of the alarm(0=Normal, 1=Alarm)
local IDX_DEF_SECURITY_ALARM = 13
-- The push button to reset the contacts
local IDX_SECURITY_RESET = 162
-- Array of the idx for the security devices: security front door, ...
local SECURITYDEVICES = {160}

return {
	on = {
		devices = {
			IDX_SECURITY_RESET
		}
	},
	execute = function(domoticz, device)
		domoticz.log('SECURITY RESET: ' .. device.name, domoticz.LOG_INFO)
		
        -- Loop over the array of device idx's and set state to normal
        for i, idx in ipairs(SECURITYDEVICES) do
            domoticz.devices(idx).setState('Normal')
        end

        -- Reset the user variable, holding the alarm state, to 0
        if (domoticz.variables(IDX_DEF_SECURITY_ALARM).value == 1) then
            domoticz.variables(IDX_DEF_SECURITY_ALARM).set(0)
        end

		-- Send notification
		-- domoticz.email('Security Alert', 'The devices are resetted to state Normal ', 'someone@the.world.org')

	end
}
