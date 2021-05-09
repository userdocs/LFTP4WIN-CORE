:: launches a folder chooser and outputs choice to the console
:: https://stackoverflow.com/a/15885133/1683264

@echo off
setlocal

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please select your old LFTP4WIN folder.',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion

if ["%folder%"] EQU [] (
 echo No folder was selected so nothing to do.
 TIMEOUT 5
) else (
 :: generic
 xcopy "%folder%\home" "home\" /F /E /H /Y /B
 xcopy "%folder%\keys" "keys\" /F /E /H /Y /B
 xcopy "%folder%\downloads" "downloads\" /F /E /H /Y /B
 :: notifications
 xcopy "%folder%\system\etc\notifications" "system\etc\notifications" /F /E /H /Y /B
 :: winscp
 xcopy "%folder%\system\applications\winscp\WinSCP.ini" "system\applications\winscp\WinSCP.ini" /F /E /H /Y /B
 :: kitty
 xcopy "%folder%\system\applications\kitty\Sessions" "system\applications\kitty\Sessions\" /F /E /H /Y /B
 xcopy "%folder%\system\applications\kitty\SshHostKeys" "system\applications\kitty\SshHostKeys\" /F /E /H /Y /B
 xcopy "%folder%\system\applications\kitty\kitty.ini" "system\applications\kitty\kitty.ini" /F /E /H /Y /B
 :: configuration scripts
 xcopy "%folder%\system\scripts\lftpsync-config.sh" "system\scripts\lftpsync-config.sh" /F /E /H /Y /B
 xcopy "%folder%\system\scripts\lftp-conf-override.sh" "system\scripts\lftp-conf-override.sh" /F /E /H /Y /B
)

endlocal
