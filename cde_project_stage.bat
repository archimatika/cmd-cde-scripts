:: CDE Ops
:: New project stage creation command
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

:: Define roles & rights
:: CI - container inherit, OI - object inherit, F - full control
set roles=1D 1PM A AC E FP H J L LA P S Y Z
set "rights[1D]=D:(CI)(OI)F"
set "rights[1PM]=1PM:(CI)(OI)F"
set "rights[A]=A:(CI)(OI)F"
set "rights[AC]=AC:(CI)(OI)F"
set "rights[E]=E:(CI)(OI)F"
set "rights[FP]=F:(CI)(OI)F"
set "rights[H]=H:(CI)(OI)F"
:: J = ex L
set "rights[J]=L:(CI)(OI)F"
:: L = ex G
set "rights[L]=G:(CI)(OI)F"
:: LA = ex GC
set "rights[LA]=GC:(CI)(OI)F"
set "rights[P]=P:(CI)(OI)F"
set "rights[S]=S:(CI)(OI)F"
set "rights[Y]=1PM:(CI)(OI)F D:(CI)(OI)F"
set "rights[Z]=1PM:(CI)(OI)F D:(CI)(OI)F"

:: Input project id
echo [%TIME%] This script will create a basic stage structure.
set /p pid="[%TIME%] Please input the project code (XXYYY): "
set /p sid="[%TIME%] Please input the stage code (XX00): "

:: Check project exists
echo [%TIME%] Checking root folder "%root%%pid%" ...
if not exist "%root%%pid%" (
	echo [%TIME%] Project not found, aborted.
	endlocal

) else (
	echo [%TIME%] Project found, deploying stage ...
	:: regular zones
	for /L %%i in (0,1,2) do (
		if not exist "%root%%pid%\!zones[%%i]!\%sid%" (
			mkdir %root%%pid%\!zones[%%i]!\%sid%
		)
		echo [%TIME%] Creating "%root%%pid%\!zones[%%i]!\%sid%" ...
		:: create role folders, assign rights
		for %%r in (%roles%) do (
			if not exist "%root%%pid%\!zones[%%i]!\%sid%\%%r" (
				echo [%TIME%] Adding %%r ...
				mkdir %root%%pid%\!zones[%%i]!\%sid%\%%r >nul
			) else (
				echo [%TIME%] Updating %%r ...
			)
			icacls %root%%pid%\!zones[%%i]!\%sid%\%%r /grant !rights[%%r]! >nul
		)
	)
	:: archive zones
	for /L %%j in (0,1,2) do (
		if not exist "%root%%pid%\04-ARC\!zones[%%j]!\%sid%" (
			mkdir %root%%pid%\04-ARC\!zones[%%j]!\%sid% >nul
		)
	)
	echo [%TIME%] Stage structure deployed.

	echo.
	endlocal
)