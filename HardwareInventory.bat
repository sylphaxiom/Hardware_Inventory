REM *** Script to pull full inventory from enterprise ***

REM Set save location

SET location="\\colfs1\public\inventory\%computername%.txt"

REM If file is there exit and do nothing
REM Else gather info

IF EXIST %location% (
	Exit
) ELSE (
	CALL :User
	CALL :Blank
	CALL :SerialNumber
	CALL :SysInfo
	CALL :Blank
	CALL :CPU
	CALL :Architecture
	CALL :RAM
	CALL :Blank
	CALL :Antivirus
	Exit
)

REM Module pulls ram information and converts it to readable format
:RAM
	Set "WMIC_TOTMEM=wmic ComputerSystem get TotalPhysicalMemory /format:Value"
	Set "WMIC_Capacity=wmic memorychip get capacity /format:Value"
	Set "CAP=Capacity"
	Set "TOT=TotalPhysicalMemory"
	Call :GetTOTMEM %TOT% TotalPhysicalMemory
	Call :GetCapacityMem %CAP% Capacity
	Call :Convert %TotalPhysicalMemory% TotalPhysicalMemory_Converted
	Call :Convert %Capacity% Capacity_Converted
	echo TotalPhysicalMemory = %TotalPhysicalMemory_Converted% >> %location%
	echo Memorychip Capacity = %Capacity_Converted%  >> %location%
	Exit /b

REM Module Works with RAM pulls memory capacity
:GetCapacityMem
	FOR /F "tokens=2 delims==" %%I IN (
	  '%WMIC_Capacity% ^| find /I "%~1" 2^>^nul'
	) DO FOR /F "delims=" %%A IN ("%%I") DO SET "%2=%%A"
	Exit /b

REM Module works with RAM pulls total memory
:GetTOTMEM
	FOR /F "tokens=2 delims==" %%I IN (
	  '%WMIC_TOTMEM% ^| find /I "%~1" 2^>^nul'
	) DO FOR /F "delims=" %%A IN ("%%I") DO SET "%2=%%A"
	Exit /b
	
REM Module works with RAM and converts memory values to readable format
:Convert
	Set "VBS=%Temp%\%Random%.vbs"
	(
		echo wscript.echo Convert("%~1"^)
		echo 'Function to format a number into typical size scales
		echo Function Convert(iSize^)
		echo    aLabel = Array("bytes", "KB", "MB", "GB", "TB"^)
		echo    For i = 0 to 4
		echo        If iSize ^> 1024 Then
		echo            iSize = iSize / 1024
		echo        Else
		echo            Exit For
		echo        End If
		echo    Next
		echo    Convert = Round(iSize,2^) ^& " " ^& aLabel(i^)
		echo End Function
	)>"%VBS%"
	for /f "delims=" %%a in ('Cscript //NoLogo "%VBS%"') do set "%2=%%a" 
	Del "%VBS%"
	Exit /b
	
REM Uses System Info to get Computer name, OS, OS version, Install date, manufacturer, and model
:SysInfo
	systeminfo | findstr /i /b /c:"host name" /c:"os name" /c:"os version" /c:"original" /c:"system manu" /c:"system model" >> %location%
	Exit /b
	
REM Gets system serial number which is also service tag
:SerialNumber
	wmic /append:%location% bios get serialnumber
	Exit /b
	
REM Gets architecture which should be x86 or x64
:Architecture
	wmic /append:%location% computersystem get systemtype
	Exit /b
	
REM Gets CPU information from computer
:CPU
	wmic /append:%location% cpu get name
	Exit /b
	
REM Gets the current user that logged in
:User
	@echo Current User: >> %location%
	whoami >> %location%
	Exit /b
	
REM Gets antivirus and looks for Sophos or Forticlient
:Antivirus
	@echo Forticlient or Sophos: >> %location%
	wmic product get version,vendor | findstr /i /c:"forti" /c:"sophos" >> %location%
	IF %ERRORLEVEL% EQU 1 echo No antivirus found! >> %location%
	Exit /b

REM Inputs a blank line in the file for readability purposes
:Blank
	@echo. >> %location%
	Exit /b