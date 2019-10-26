# @name lftp
# @command cmd /c start "" "%WINSCP_PATH%\..\conemu\ConEmu64.exe" -run {Bash::bash} "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/" "!\" "!P"
# @side Local
# @flag
# @description Connect to the remote server using LFPT
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
#! /usr/bin/env bash
#
winscp_to_bash "$1" "$2" "$3" "$4" "$5" "$6" "$7"
#
openssh_known_hosts "$port" "$hostname"
#
cd "$local_dir"
#
lftp -p "$port" -u "$username,$password" "$protocol://$hostname" -e "cd \"$remote_dir\"; cls -1aB"
#
exit