:: CDE Ops
:: New project creation command
:: According to DSTU ISO 19650 NA & archimatika

@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: Define root path & key zones
set root=W:\
set "zones[0]=01-WIP"
set "zones[1]=02-SHA"
set "zones[2]=03-PUB"
set "zones[3]=04-ARC"
set "zones[4]=99-TMP"

:: Input project id
echo [%TIME%] This script will create a basic project structure.
set /p pid="[%TIME%] Please input the project code (XXYYY): "

:: Create project root
echo [%TIME%] Creating root folder "%root%%pid%" ...
mkdir %root%%pid%
:: Create status zone structure
echo [%TIME%] Deploying status zone structure:
for /L %%i in (0,1,4) do (
	mkdir %root%%pid%\!zones[%%i]!
	echo [%TIME%] Creating "%root%%pid%\!zones[%%i]!\" ...
)
	for /L %%j in (0,1,2) do (
		mkdir %root%%pid%\04-ARC\!zones[%%j]!
	)

echo [%TIME%] Project has been deployed.

echo.
endlocal