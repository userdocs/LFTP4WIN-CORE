# @name lftpsync-setup
# @command cmd /c start "" "%WINSCP_PATH%\..\conemu\ConEmu64.exe" -run {Bash::bash} "%EXTENSION_PATH%" "%username%" "%hostname%" "%port%" "%protocol%" "%remotepath%" "%localpath%" "%password%" "%mparallel%" "%mpget%" "%arguments%" "%schedule%" "%scheduletime%" "%reset%" "%openlftpsync%"
# @side Local
# @flag
# @description Use this command to automatically generate the lftpsync settings using the current local and remote directories. You can also configure the connection settings.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option reset -run checkbox "Reset the script and delete Scheduled Task" "" "reset"
# @option openlftpsync -run checkbox "Open the lftpsync script with notepad++" "" "openlftpsync"
#
# @option - -run group "Connection Settings"
#
# @option username -run textbox "Username" "!U"
# @option password -run textbox "Password - No double quotes or passwords ending with a /" "!P"
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
# @option scheduletime -config -run dropdownlist "Scheduled Task Time to run:" "20:00" "00:00" "01:00" "02:00" "03:00" "04:00" "05:00" "06:00" "07:00" "08:00" "09:00" "10:00" "11:00" "12:00" "13:00" "14:00" "15:00" "16:00" "17:00" "18:00" "19:00" "20:00" "21:00" "22:00" "23:00"
#
# @option - -run group "Misc"
#
# @option protocol -run textbox "Session (Shortened to Protocol by the script. You can mostly ignore this)" "!S"
#
#! /usr/bin/env bash
#
if [[ "${13}" = 'reset' || "${14}" = 'reset' ]]; then
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
	winscp_to_bash "$1" "$2" "$3" "$4" "$5" "$6" "$7"
	#
	sed -ri "s|^username='(.*)'$|username='$username'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^hostname='(.*)'$|hostname='$hostname'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^port='(.*)'$|port='$port'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^protocol='(.*)'$|protocol='$protocol'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^remote_dir='(.*)'$|remote_dir='$remote_dir'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^local_dir='(.*)'$|local_dir='$local_dir'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^password='(.*)'$|password='$password'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_parallel_transfer_count='(.*)'$|mirror_parallel_transfer_count='$8'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_use_pget_n='(.*)'$|mirror_use_pget_n='$9'|g" /scripts/lftpsync-config.sh
	sed -ri "s|^mirror_args='(.*)'$|mirror_args='$(echo "${10}" | sed -e 's/^\"//' -e 's/\"$//' | sed 's#[~-¬`!£$%^&*()_+={}#:;@<,>.?|\/[]#\\&#g' | sed "s#'#'\\\\\\\''#g")'|g" /scripts/lftpsync-config.sh
	#
	/cygdrive/c/Windows/System32/SchTasks /Create /SC "${11}" /TN "lftpsync" /TR \""$(cygpath.exe -w "/scripts/lftpsync.cmd")"\" /ST "${12}" /F
	echo "The lftpsync script scheduled task has been created using your settings."
	sleep 2
fi
#
if [[ "${13}" = 'openlftpsync' || "${14}" = 'openlftpsync' ]]; then
	"/applications/notepad/notepad++.exe" "$(cygpath -m /scripts/lftpsync-config.sh)"
fi
#
exit
