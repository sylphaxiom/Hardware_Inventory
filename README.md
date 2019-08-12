# Hardware_Inventory
Script to perform hardware inventory of COL enterprise

Main script pulls username, serial number, host name, OS name, OS version, install date, manufacturer, model, CPU, RAM, Architecture, and antivirus.
This information is all put into a hidden folder in a public network drive in a text file with the same name as the computer name.
The script looks for this file, if it exists it does nothing, if it doesn't exist it creates the file, inventories the computer, and appends the text file.

The .FILTER.bat file looks at the files in the main inventory folder and compares it to the completed folder. If the file does not exist 
in the completed folder, it copies that file to the incomplete folder for processing.

After the file is processed and put into a spreadsheet, we change the file name to start with 0. The .CLEAN.bat script looks for that 0
and moves that file to the completed folder and then removes the 0 so it is back to it's original name.
