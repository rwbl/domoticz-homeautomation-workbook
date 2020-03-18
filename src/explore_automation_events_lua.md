# Explore Automation Events
These scripts are not used anymore but kept as learning reference. 

## Lua Command
Not recommended = use dzVents scripts instead.

### Lua basement_humidity_monitor_l.lua

```
-- basement_humidity_monitor_l
-----------------------------------------------------------------------------
-- Monitor the basement humidity if exceeds threshold and write to Domoticz log.
-----------------------------------------------------------------------------

commandArray = {}

-- Split a string by delimiter
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

----------------------------------------------------------------------------------------------------------
-- Domoticz IDX and names of the needed devices
----------------------------------------------------------------------------------------------------------
local KellerIdx = 11;
local KellerName = "Keller";

-- Thresholds
local HumidityThreshold = 70;

----------------------------------------------------------------------------------------------------------
-- Action for specific device
----------------------------------------------------------------------------------------------------------
if devicechanged[KellerName] then

	time = os.date("*t")
	ts = string.format("%02d:%02d:%02d", time.hour, time.min, time.sec);
	print(string.format('Device %s changed @ %s', KellerName, ts));
    -- The svalues contain: TEMP;HUM;HUM_STAT
    -- TEMP = Temperature
    -- HUM = Humidity (0-100 %)
    -- HUM_STAT = Humidity status
	print('Device All Values: ' .. otherdevices_svalues[KellerName]);

	-- Get the humidity
	Humidity = math.floor(otherdevices_humidity[KellerName] * 10) / 10;

    -- Check if the humidity is equal or above threshold - notify
    if Humidity >= HumidityThreshold then
    	print('Basement Humidity >= ' .. HumidityThreshold .. ' (' .. Humidity .. ')');
	    -- print(string.format('Basement Humidity >= %d (%d)', HumidityThreshold, Humidity));
    end

end

return commandArray
```
