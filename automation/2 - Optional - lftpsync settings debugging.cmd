@echo off
setlocal enabledelayedexpansion enableextensions
set LIST=
for %%x in ("%~dp0..\keys\*.ppk") do set LIST=!LIST! "%%x"
IF exist "%~dp0..\keys\*.ppk" (
start "" "%~dp0..\system\applications\kitty\kageant.exe" %LIST:~1%
)
start "" "%~dp0..\system\applications\conemu\ConEmu64.exe" -cmd {Bash::bash} "%~dp0..\system\scripts\lftpsync.sh" debug
exit
