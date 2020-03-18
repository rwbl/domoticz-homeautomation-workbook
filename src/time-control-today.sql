-- Domoticz Home Automation Workbook - Function Time Control
-- SQL-Command-File: time-control-today.sql
-- Calculate for today (now) the time difference in hours for the subsequent rows where nValue is 1 (switch is on)
-- Table [LightingLog], Fields [DeviceRowID] = 101, [nValue]=1,[Date]=date('now');
-- Run from the command line with:
-- sqlite3 /home/pi/domoticz/domoticz.db ".read /home/pi/domoticz/scripts/dzVents/scripts/time-control-today.sql"
-- Hints:
-- To select the data for yesterday use [date] >= date('now',"-1 days") AND	[date] < date('now').

.mode list
.separator " - "
.headers on
-- List the blocks
WITH rows AS
	(
	SELECT  *, ROW_NUMBER() OVER (ORDER BY Date) AS rownumber
	FROM    [lightinglog]
	WHERE   [devicerowid] = 101
	AND		[date] >= date('now')
	)
SELECT	strftime('%H:%M',startdata.date) AS Start, 
		strftime('%H:%M',enddata.date) AS End,
		ROUND(CAST( (JulianDay(enddata.date) - JulianDay(startdata.date)) * 24 As Real),3) AS Hours
		-- Round(Cast( (JulianDay(enddata.date) - JulianDay(startdata.date)) * 24 * 60 As Real),2) AS Minutes
		-- Cast( (JulianDay(enddata.date) - JulianDay(startdata.date)) * 24 * 60 * 60 As Integer) AS Secs
FROM	rows startdata
JOIN	rows enddata
ON		startdata.rownumber = enddata.rownumber - 1
WHERE	startdata.nValue = 1;

-- Show the total
WITH rows AS
	(
	SELECT  *, ROW_NUMBER() OVER (ORDER BY Date) AS rownumber
	FROM    [lightinglog]
	WHERE   [devicerowid] = 101
	AND		[date] >= date('now')
	)
SELECT	ROUND( SUM( CAST( (JulianDay(enddata.date) - JulianDay(startdata.date)) * 24 As Real) ),3 ) AS Total
FROM	rows startdata
JOIN	rows enddata
ON		startdata.rownumber = enddata.rownumber - 1
WHERE	startdata.nValue = 1;

