# @name lftpsync-setup
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "%username%" "%hostname%" "%port%" !`bash -c 'base64 -w 0 <<< "!S"'` "%remotepath%" "%localpath%" "%mparallel%" "%mpget%" "%arguments%" "%schedule%" "%scheduletime%" "%reset%" "%openlftpsync%"
# @side Local
# @flag
# @description Use this command to automatically generate the lftpsync settings using the current local and remote directories. You can also configure the connection settings.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -config checkbox "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash}" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li"
#
# @option reset -run checkbox "Reset the script and delete Scheduled Task" "" "reset"
# @option openlftpsync -run checkbox "Open the lftpsync script with notepad++" "" "openlftpsync"
#
# @option - -run group "Connection Settings"
#
# @option username -run textbox "Username" "!U"
# @option password -run textbox "Password" "!P"
# @option hostname -run textbox "Hostname" "!@"
# @option port -run textbox "Port" "!#"
#
# @option - -run group "Directory settings"
#
# @option remotepath -run textbox "Remote Path - No double quotes allowed in path." ""!/""
# @option localpath -run textbox "Local Path" "!\"
#
# @option - -config -run group "Lftp Configuration"
#
# @option mparallel -config -run textbox "Mirror Parallel (files to download in parallel)" "5"
# @option mpget -config -run textbox "Mirror Pget (parts to split each file into when downloading)" "5"
# @option arguments -config -run textbox "Arguments (You can specify command arguments here if required)" "-c"
#
# @option - -config -run group "Task Scheduler Settings"
#
# @option schedule -config -run dropdownlist "Set the Scheduled task repetition:" "DAILY" "HOURLY" "DAILY" "WEEKLY" "MONTHLY" "ONLOGON"
# @option scheduletime -config -run dropdownlist "Scheduled Task Time to run:" "20:00" "00:00" "00:30" "01:00" "01:30" "02:00" "02:30" "03:00" "03:30" "04:00" "04:30" "05:00" "05:30" "06:00" "06:30" "07:00" "07:30" "08:00" "08:30" "09:00" "09:30" "10:00" "10:30" "11:00" "11:30" "12:00" "12:30" "13:00" "13:30" "14:00" "14:30" "15:00" "15:30" "16:00" "16:30" "17:00" "17:30" "18:00" "18:30" "19:00" "19:30" "20:00" "20:30" "21:00" "21:30" "22:00" "22:30" "23:00" "23:30"
#
# @option - -run group "Misc"
#
# @option protocol -run textbox "Session (Shortened to Protocol by the script. You can mostly ignore this)" "!S"
#
#! /usr/bin/env bash
#
if [[ "${12}" = 'reset' ]]; then
	sed -ri "s|^username='(.*)'$|username=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^hostname='(.*)'$|hostname=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^port='(.*)'$|port=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^protocol='(.*)'$|protocol=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^remote_dir='(.*)'$|remote_dir=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^local_dir='(.*)'$|local_dir=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^password='(.*)'$|password=''|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_parallel_transfer_count='(.*)'$|mirror_parallel_transfer_count='0'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_use_pget_n='(.*)'$|mirror_use_pget_n='0'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_args='(.*)'$|mirror_args='-c'|g" /scripts/lftpsync-config.sh
	#
	if [[ "$(/cygdrive/c/Windows/System32/SchTasks /query /TN "lftpsync" 2> /dev/null)" ]]; then
		/cygdrive/c/Windows/System32/SchTasks /delete /tn "lftpsync" /f
	fi
	#
	echo "The lftpsync script has been reset to defaults and the scheduled task has been removed."
	sleep 2
else
	winscp_to_bash "${@}"
	sed -ri "s|^username='(.*)'$|username='${username}'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^hostname='(.*)'$|hostname='${hostname}'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^port='(.*)'$|port='$port'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^protocol='(.*)'$|protocol='${protocol}'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^remote_dir='(.*)'$|remote_dir='${remote_dir}'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^local_dir='(.*)'$|local_dir='${local_dir}'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^password='(.*)'$|password='${password}'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_parallel_transfer_count='(.*)'$|mirror_parallel_transfer_count='$7'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_use_pget_n='(.*)'$|mirror_use_pget_n='$8'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_args='(.*)'$|mirror_args='$(printf %q "$(echo "$9" | sed -r 's/^"(.*)"$/\1/' | sed "s:':'\\\\\'':g")")'|g" /scripts/lftpsync-config.sh
	#
	/cygdrive/c/Windows/System32/SchTasks /Create /SC "${10}" /TN "lftpsync" /TR \""$(cygpath.exe -w "/scripts/lftpsync.cmd")"\" /ST "${11}" /F
	echo "The lftpsync script scheduled task has been created using your settings."
	sleep 2
fi
#
if [[ "${13}" = 'openlftpsync' ]]; then
	"/applications/notepad/notepad++.exe" "$(cygpath -m /scripts/lftpsync-config.sh)"
fi
