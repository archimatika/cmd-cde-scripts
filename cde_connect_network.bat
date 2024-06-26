@echo off
setlocal enabledelayedexpansion

rem check if W: has been used, delete and reconnect as new instance

echo Looking for existing W: drive...
set drive_id=""
set drive_type=""
set drive_name=""
for /f "skip=1 tokens=*" %%a in ('wmic logicaldisk get deviceid^, drivetype^, volumename') do (
    for /f "tokens=1-4" %%b in ("%%a") do (
	    if "%%b"=="W:" (
	    	echo Found %%b ^(type=%%c, label="%%d %%e"^), removing...
		    set "drive_id=%%b"
		    set "drive_type=%%c"
		    set "drive_name=%%d %%e"
	    )
	)
)

if not %drive_id% == "" (
	if %drive_type% == 3 (
		rem just for case
		subst W: /D
	)
	if %drive_type% == 4 (
		net use W: /delete /y
	)
	timeout /t 3 /nobreak > NUL
) else (
	echo No drive W: found
)

rem connecting to server storage with vpn

echo.
echo Establishing server vpn connection...

set "net_status="
set "net_name="
for /f "tokens=*" %%c in ('rasdial') do (
    if "%%c"=="Connected to" (
        set "net_status=Connected"
    )
    if "%%c"=="Archimatika" (
        set "net_name=%%c"
    )  
)

if defined net_status (
	net use W: \\archimatika.local\public\work
	timeout /t 3 /nobreak > NUL
) else (
	echo No VPN connection found, aborted
)