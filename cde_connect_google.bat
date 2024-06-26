@echo off
setlocal enabledelayedexpansion

rem check if W: has been used, delete and reconnect as new instance

echo Looking for existing W: drive...
set drive_id=""
set drive_type=""
set drive_name=""
set google_id=""
for /f "skip=1 tokens=*" %%a in ('wmic logicaldisk get deviceid^, drivetype^, volumename') do (
    for /f "tokens=1-4" %%b in ("%%a") do (
	    if "%%b"=="W:" (
	    	echo Found %%b ^(type=%%c, label="%%d %%e"^), removing...
		    set "drive_id=%%b"
		    set "drive_type=%%c"
		    set "drive_name=%%d %%e"
	    )
	    if "%%b"=="G:" (
		    set "google_id=%%b"
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

rem connecting google drive shared disks

echo.
echo Establishing Google Drive connection...
if not %google_id% == "" (
	subst W: "G:\Shared drives"
	timeout /t 5 /nobreak > NUL
	echo Connected
) else (
	echo Can't find any google drive on G:, aborted
	pause
)