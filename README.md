# FastFeet

NOTE: IF YOU ARE UPGRADING FROM AN OLD VERSION, PLEASE RUN THE "SET" COMMAND AGAIN TO ENABLE THE COMBAT TOGGLE FEATURE OR DELETE YOUR SETTINGS FILE FROM THE DATA FOLDER.

To install, download the files above and drop them in your Windower/Addon folder.

In game, load the addon using the command: //lua l fastfeet 

To set the item you want to equip when moving, use the command: //ff set "Item"
example: //ff set "Herald's Gaiters"
note: Double Quotes are necessary when item has commas or special characters. Capitalization is also important.

If you want to disable item swap during combat, simply use the command: //ff engaged
note: this command will either toggle this setting on or off

Addon will simply run. No need to start stop. It will attempt to re-equip whatever previous item was equipped in that slot. As such, ensure you equip a piece in that slot at some point to register it into memory.
It will dynamically update as you swap gear.
