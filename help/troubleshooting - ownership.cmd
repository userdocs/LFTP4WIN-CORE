@echo off
:: Move to the LFTP4WIN root directory
PUSHD "%~dp0.."
:: If this fails then exit
If %errorlevel% NEQ 0 goto:eof
:: Set the path to a variable.
set FIX_PERMS_PATH="%CD%"
:: Take ownership and reset permissions
takeown /f "%FIX_PERMS_PATH%" /r & icacls "%FIX_PERMS_PATH%" /reset /t /c /q
:: Press enter to exit the script
pause
