@echo off

set src="\\colfs1\public\inventory"
set completed="\\colfs1\public\inventory\Completed"
set incomplete="\\colfs1\public\inventory\Incomplete"

for %%i in ("%incomplete%\0*.txt") do (
	move %incomplete%\%%~nxi %completed%\%%~nxi
)
ren "%completed%\0*.txt" "/*.txt"