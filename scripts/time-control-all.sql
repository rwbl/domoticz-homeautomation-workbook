-- Domoticz Home Automation Workbook - Function Time Control
-- SQL-Command-File: time-control-all.sql
-- Table [LightingLog], Field [DeviceRowID] = 101;
-- Calculate for all rows the time difference in hours for the subsequent rows where nValue is 1 (switch is on)
-- Run from the command line with:
-- sqlite3 /home/pi/domoticz/domoticz.db ".read /home/pi/domoticz/scripts/dzVents/scripts/time-control-all.sql"

.header on
-- List the blocks
WITH rows AS
	(
	SELECT  *, ROW_NUMBER() OVER (ORDER BY Date) AS rownumber
	FROM    [lightinglog]
	WHERE   [devicerowid] = 101
	)
SELECT	startdata.date AS Start, 
		enddata.date AS End,
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
	)
SELECT	ROUND( SUM( CAST( (JulianDay(enddata.date) - JulianDay(startdata.date)) * 24 As Real) ),4 ) AS Total
FROM	rows startdata
JOIN	rows enddata
ON		startdata.rownumber = enddata.rownumber - 1
WHERE	startdata.nValue = 1;

