# SourceChanges domoticz-home-automation-workbook
Status: 20200825

Domoticz source code changes & enhancements.

After making the changes, restart Domoticz and clear the cache of the browser
```
sudo service domoticz.sh restart
```

## Enhancement: Add JustGage JavaScript Includes
[JustGage](https://www.npmjs.com/package/justgage) is a JavaScript plugin for Dashboard gauges.
Credits to the developers for making the plugin available.

### Copy Files
Copy the files raphael.min.js and justgage.js to the folder:
```
<path>/domoticz/www/js folder.
```

### Add Links
Enhance Domoticz file
```
<path>/domoticz/www/index.html
```
Line 103 (with source 2020.2 build 122279).
**Change**
```
<script src="js/noty/noty.min.js"></script>
<script charset="utf-8" src="js/data-tables/jquery.dataTables.min.js"></script>
```
**To**
```
<script src="js/noty/noty.min.js"></script>

<!-- START: JustGage Links -->
<script charset="utf-8" src="js/raphael.min.js"></script>
<script charset="utf-8" src="js/justgage.js"></script>
<!-- END: JustGage Links -->

<script charset="utf-8" src="js/data-tables/jquery.dataTables.min.js"></script>
```

## Change: Add Custom Menu Sort() Function
Enhance Domoticz file
```
<path>/domoticz/www/app/app.js
```
Add the **sort()** function to the array **data.result.templates** in the loop **$.each(data.result.templates, function (i, item)**:
**$.each(data.result.templates.sort(), function (i, item)**
Line 441 (with source 2020.2 build 122279).
**Change**
```
if (typeof data.result.templates != 'undefined') {
	var customHTML = "";
	$.each(data.result.templates, function (i, item) {
		var cFile = item;
		var cName = cFile.charAt(0).toUpperCase() + cFile.slice(1);
		var cURL = "templates/" + cFile;
```
**To**
```
if (typeof data.result.templates != 'undefined') {
	var customHTML = "";
	$.each(data.result.templates.sort(), function (i, item) {
		var cFile = item;
		var cName = cFile.charAt(0).toUpperCase() + cFile.slice(1);
		var cURL = "templates/" + cFile;
```
