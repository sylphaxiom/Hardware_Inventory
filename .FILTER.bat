@echo off

set src="\\colfs1\public\inventory"
set completed="\\colfs1\public\inventory\Completed"
set incomplete="\\colfs1\public\inventory\Incomplete"

for %%i in ("%src%\*.txt") do if not exist "%completed%\%%~nxi" copy %src%\%%~nxi %incomplete%\%%~nxi