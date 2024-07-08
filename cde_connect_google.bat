@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

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
echo Try to establish Google Drive connection...

set "share_path[0]=G:\Shared drives"
set "share_path[1]=G:\Спільні диски"
set "share_path[2]=G:\Общие диски"

if not %google_id% == "" (
 	for /L %%s in (0,1,2) do (
	    if exist "!share_path[%%s]!" (
	    	subst W: "!share_path[%%s]!"
	    	timeout /t 4 /nobreak > NUL
		echo Drive disk was found on G:\ and could be mounted
		timeout /t 3 /nobreak > NUL
	    	echo "!share_path[%%s]!" connected successfully
	    	timeout /t 2 /nobreak > NUL
	    )
	)
) else (
	echo Can't find any google drive on G:, aborted
)

chcp 850 >nul

pause