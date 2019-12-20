# Explore Automation Events- Blockly
These scripts are not used anymore but kept as learning reference. 

## Blockly

### Blockly basement_humidity_monitor_b
**Pseudo Code**
```
If Basement Hum. >= 70
	Do Write to log: "Basement Humdity >= 70%"
```

```
<xml xmlns="http://www.w3.org/1999/xhtml">
	<block type="domoticzcontrols_if" id="x^=wjt{k=`dx=Fl#wrb2" inline="false" x="-17" y="-515">
		<value name="IF0">
			<block type="logic_compare" id="g^W!IO^NHkiajc5W9`9:">
				<field name="OP">GTE</field>
					<value name="A">
						<block type="humidityvariables" id="[X8;8?@!;W73DIj/%:B^">
							<field name="Humidity">11</field>
						</block>
					</value>
					<value name="B">
						<block type="math_number" id="eg/nK9[A6BDpamucN-P@">
							<field name="NUM">70</field>
						</block>
					</value>
			</block>
		</value>

		<statement name="DO0">
			<block type="writetolog" id="6zvObCut#4+4:oMqa!P}">
				<value name="writeToLog">
					<block type="text" id="MG*FcLx4CQmf8mu(Hdl2">
						<field name="TEXT">Basement Humidity &gt;= 70%</field>
					</block>
				</value>
			</block>
		</statement>
	</block>
</xml>
```

