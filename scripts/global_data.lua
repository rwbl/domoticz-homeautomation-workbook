-- global_data.lua
-- utility functions used by all dzVents scripts
-- this scripts holds all the globally persistent variables and helper functions
-- see the documentation in the wiki
-- NOTE:
-- THERE CAN BE ONLY ONE global_data SCRIPT in your Domoticz install.
-- usage:
-- return {
--    ...
--    execute = function(domoticz, device)
--       local results = domoticz.helpers.myHandyFunction('bla', 'boo')
--       print(domoticz.helpers.MY_CONSTANT)
--
--       local message = domoticz.variables('DEF_ALERTMSG').value
--       domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_GREY, message)
--
--    end
-- }
-- Robert W.B. Linn
-- 20190309

return {
	-- global persistent data
	-- data = {
	-- 	myGlobalVar = { initial = 12 }
	-- },

	-- global helper functions
	helpers = {
	    
		-- Idx of devices used
	    IDX_ALERTMSG = 55,
	    IDX_CONTROLMSG = 52,

        ------------------------------------------------------------------------
        -- STRING
        ------------------------------------------------------------------------

        -- split a string by delimiter
        -- return array, i.e. array[1], array[2]
        split = function(s, delimiter)
            result = {};
            for match in (s..delimiter):gmatch("(.-)"..delimiter) do
                table.insert(result, match);
            end
            return result;
        end,

        -- check if a string is empty
        -- return true if empty
        isempty = function(s)
            return s == nil or s == ''
        end,

        ------------------------------------------------------------------------
        -- DATE & TIME
        ------------------------------------------------------------------------

        -- get the current date & time from the domoticz instance with time object
        -- return datetime now, i.e. 2018-09-06 09:09:00
        isnow =  function(domoticz)
            return domoticz.time.rawDate .. ' ' .. domoticz.time.rawTime
        end,

        -- get the current date & time from the domoticz instance with time object
        -- return datetime now, i.e. 2018-09-06 09:09:00
        isnowdatetime = function(domoticz)
            return domoticz.time.rawDate .. ' ' .. domoticz.time.rawTime
        end,

        -- get the current date from the domoticz instance with time object
        -- return date now, i.e. 2018-09-06
        isnowdate = function(domoticz)
            return domoticz.time.rawDate
        end,

        -- get the current time from the domoticz instance with time object
        -- return time now, i.e. 09:09:00
        isnowtime = function(domoticz)
            return domoticz.time.rawTime
        end,

        -- get the current time from the domoticz instance with time object
        -- return time now, i.e. 09:09
        isnowhhmm = function(domoticz)
            timearray = domoticz.helpers.split(domoticz.time.rawTime, ':')
            return timearray[1] .. ':' .. timearray[2]
        end,

        -- remove seconds from time string hh:mm:ss
        -- return time string, i.e. 09:09
        converttimehhmm = function(domoticz,timestring)
            timearray = domoticz.helpers.split(timestring, ':')
            return timearray[1] .. ':' .. timearray[2]
        end,

        -- Calculate the date difference in days between now and the target date
        -- Return days rounded up
        datediffnow = function(d,m,y)
            -- print(d,m,y)
	        -- Set the target date from the parameter
	        local targetdate = os.time{day=d, month=m, year=y, hour=0, min=0, sec=0}

        	-- Get the time diff between now and the target date in seconds in a day
	        local daysdiff = os.difftime(targetdate, os.time()) / (24 * 60 * 60)

            -- Return the days rounded up; round down use math.floor(daysdiff)
            return math.ceil(daysdiff)
        end,

        -- Calculate the date difference in days between now and the target date
        -- Return days rounded down
        datediffnow2 =function(d,m,y)
            -- print(d,m,y)
	        -- Set the target date from the parameter
	        local targetdate = os.time{day=d, month=m, year=y}

	        -- Get the time diff between now and the target date in seconds in a day
	        local daysdiff = os.difftime(targetdate, os.time()) / (24 * 60 * 60)

            -- Return the days round down
            return math.floor(daysdiff)
        end,

        -- Calculate the date difference in days between start and end date
        -- Return days
        datediff  = function(ds,ms,ys, de,me,ye)
        	-- Set the start date from the parameter
	        local startdate = os.time{day=ds, month=ms, year=ys}

	        -- Set the target date from the parameter
	        local enddate = os.time{day=de, month=me, year=ye}

	        -- Get the time diff between source and the target date in seconds in a day
	        local daysdiff = os.difftime(startdate, enddate) / (24 * 60 * 60)
	
	        -- Return the days
	        return math.floor(daysdiff)    
        end,

        -- Calculate the age in years + days
        -- Return age as string years J days T
        ageyearsdays = function(domoticz,dbirth,mbirth,ybirth)
	        -- get the actual date 
        	t = os.date ("*t")

	        -- get the year, month, day for now
	        ynow = t.year
	        mnow = t.month
	        dnow = t.day

	        -- year difference between now year and the target year
	        ydiff = ynow - ybirth
	        if (mnow < mbirth) or ((mnow == mbirth) and (dnow < dbirth)) then
		        ydiff = ydiff - 1
	        end

	        if ydiff < 0 then
		        ydiff =  0
	        end
	
	        if ydiff > 0 then
		        -- days diff between birth and year end of birth (31,12)
		        ddiff1 = math.abs(domoticz.helpers.datediff(dbirth, mbirth, ybirth, 31, 12, ybirth))

		        -- days diff between current year start (1,1) and current day,month,year
		        ddiff2 = math.abs(domoticz.helpers.datediff(1, 1, ynow, dnow, mnow, ynow))
		
		        -- days difference between now and the target day+month for the now year, i.e. dtarget+mtarget+ynow
		        ddiff = ddiff1 + ddiff2
	        end

	        if ydiff == 0 then
		        -- days diff between birth and now
		        ddiff = math.abs(domoticz.helpers.datediff(dbirth, mbirth, ybirth, dnow, mnow, ynow))
	        end

	        -- build the age string to return
	        age = ydiff .. ' J ' .. ddiff .. ' T'
	        print(age)
	        return age
        end,

        -- Convert seconds to clock hh:mm:ss
        SecondsToClock = function(seconds)
            local seconds = tonumber(seconds)
            if seconds <= 0 then
                return "00:00:00";
            else
                hours = string.format("%02.f", math.floor(seconds/3600));
                mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
                secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins*60));
                return hours..":"..mins..":"..secs
            end
        end,

        -- Convert minutes to clock hh:mm
        -- Example: MinutesToClock(domoticz.time.sunriseInMinutes)
        MinutesToClock = function(minutes)
            local minutes = tonumber(minutes)
            if minutes <= 0 then
                return "00:00";
            else
                hours = string.format("%02.f", math.floor(minutes/60));
                mins = string.format("%02.f", math.floor(minutes - hours*60));
                return hours..":"..mins
            end
        end,

        -- Return the time of day in minutes since midnight
        -- Example: domoticz.log(tostring(domoticz.helpers.TimeOfDayMinutes()), domoticz.LOG_INFO)
        TimeOfDayMinutes = function()
	        return os.date("%H") * 60 + os.date("%M")
        end,

        ------------------------------------------------------------------------
        --  MESSAGES
        ------------------------------------------------------------------------

        -- Update the alert message with level and text
        alertmsg = function(domoticz, level, msg)
        	domoticz.devices(domoticz.helpers.IDX_ALERTMSG).updateAlertSensor(level, msg)
        end,

        -- Update the control message with text
        controlmsg = function(domoticz, msg)
	        domoticz.devices(domoticz.helpers.IDX_CONTROLMSG).updateText(msg)
        end

	}

-- end return
}

