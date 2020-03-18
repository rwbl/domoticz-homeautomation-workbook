-- Domoticz Home Automation Workbook - Function Time Control
-- SQL-Command-File: time-control-sum-today.sql
-- Table [LightingLog], Field [DeviceRowID] = 101;
-- Calculate the summary of the time difference for subsequent rows where nValue is 1 (switch is on)
-- To select all rows with row_number:
-- select ROW_NUMBER() OVER () Nr,* from [LightingLog] where [DeviceRowID] = 101;
 
WITH    rows AS
        (
        SELECT  *, ROW_NUMBER() OVER (ORDER BY Date) AS rownum
        FROM    lightinglog
        WHERE   devicerowid = 101
        )

SELECT  
ROUND( SUM( CAST( (JulianDay(mp.date) - JulianDay(mc.date)) * 24 * 60 As Real) ) ) AS SumMinutes
FROM    rows mc
JOIN    rows mp
ON      mc.rownum = mp.rownum - 1
WHERE   mc.nValue = 1
