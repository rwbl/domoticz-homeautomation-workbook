--[[
    security_monitor.lua
    Monitor the state of security devices and trigger action if state is not 'Normal'.
    Applies to X10 switches with state Alarm + Tamper.
    Project: atHome
    Interpreter: dzVents, devices
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190520
]]--

-- Array holding the idx for the security devices:
-- security main door (160), ...
local SECURITYDEVICES = {160}
-- User variable holding the state of the alarm (0=Normal, 1=Alarm)
local IDX_DEF_SECURITY_ALARM = 13

return {
    -- Listen to devices and timer
	on = {
	    -- Device has changed state
		devices = SECURITYDEVICES
		,
		-- Timer to reset alarm state to Normal
		timer = {
            'Every 5 minutes'
		}
	},
	execute = function(domoticz, item)
		-- domoticz.log('SECURITY MONITOR: ' .. device.name .. ' was changed to ' .. device.state, domoticz.LOG_INFO)

        -- Device has changed state
        if (item.isDevice) then
            -- if the state is not normal, then trigger action.
		    if (item.state ~= 'Normal') then
		        -- domoticz.email('SECURITY ALERT atHome', item.name .. ' state ' .. item.state, 'rwblinn@outlook.de')
                domoticz.variables(IDX_DEF_SECURITY_ALARM).set(1)
		    end
		 end

        -- Timer triggers resetting the alarm state for all devices
        if (item.isTimer) then
            -- Reset the user variable, holding the alarm state, to 0
            -- Set all devices to state "Normal"
            if (domoticz.variables(IDX_DEF_SECURITY_ALARM).value == 1) then
                domoticz.variables(IDX_DEF_SECURITY_ALARM).set(0)
                
                -- Loop over the array of device idx's and set state to normal
                for i, idx in ipairs(SECURITYDEVICES) do
                    domoticz.devices(idx).setState('Normal')
                end            
            end
        end

    end
}



