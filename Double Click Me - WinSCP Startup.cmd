@echo off
setlocal enabledelayedexpansion

set LFTP4WIN_BASE=%~dp0
set LFTP4WIN_ROOT=%~dp0system

set PATH=%LFTP4WIN_ROOT%\bin
set USERNAME=LFTP4WIN
set HOME=%LFTP4WIN_BASE%home
set GROUP=None
set GRP=
set SHELL=/bin/bash

(
    echo # /etc/fstab
    echo # IMPORTANT: this files is recreated on each start by LFTP4WIN-conemu.cmd
    echo #
    echo #    This file is read once by the first process in a Cygwin process tree.
    echo #    To pick up changes, restart all Cygwin processes.  For a description
    echo #    see https://cygwin.com/cygwin-ug-net/using.html#mount-table
    echo #
    echo none /cygdrive cygdrive binary,noacl,posix=0,sparse,user 0 0
) > "%LFTP4WIN_ROOT%\etc\fstab"

IF EXIST "%LFTP4WIN_ROOT%\etc\fstab" "%LFTP4WIN_ROOT%\bin\sed" -i 's/\r$//' "%LFTP4WIN_ROOT%\etc\fstab"

IF EXIST "%LFTP4WIN_ROOT%\portable-init.sh" "%LFTP4WIN_ROOT%\bin\bash" -li "%LFTP4WIN_ROOT%\portable-init.sh"

set LIST=
for %%x in ("%LFTP4WIN_BASE%keys\*.ppk") do set LIST=!LIST! "%%x"
IF exist "%LFTP4WIN_BASE%keys\*.ppk" (
start "" "%LFTP4WIN_ROOT%\applications\kitty\kageant.exe" %LIST:~1%
)
start "" "%LFTP4WIN_ROOT%\applications\winscp\WinSCP.exe"

