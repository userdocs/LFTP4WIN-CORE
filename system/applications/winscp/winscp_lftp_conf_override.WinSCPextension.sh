# @name lftp-conf-override
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "%parguments%" "%pget%" "%marguments%" "%mparallel%" "%mpget%" "%reset%" "%openlftpconfoverride%"
# @side Local
# @flag
# @description Use this command to change some specific transfer settings that will override the lftp conf settings while not reset to the defaults.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -config checkbox "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash}" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li"
#
# @option reset -run checkbox "Reset values to disable all overrides" "" "reset"
# @option openlftpconfoverride -run checkbox "open the lftp-conf-override script with notepad++" "" "openlftpconfoverride"
#
# @option - -config -run group "Pget Configuration"
#
# @option pget -config -run textbox " Pget (parts to split each file into when downloading)" "0"
# @option parguments -config -run textbox "Pget arguments (You can specify command arguments here if required)" "-c"
#
# @option - -config -run group "Mirror Configuration"
#
# @option mparallel -config -run textbox "Mirror Parallel (files to download in parallel)" "0"
# @option mpget -config -run textbox "Mirror Pget (parts to split each file into when downloading)" "0"
# @option marguments -config -run textbox "Mirror arguments (You can specify command arguments here if required)" "-c"
#
if [[ "${6}" = 'reset' ]]; then
	sed -ri "s|^pget_args='(.*)'$|pget_args='-c'|g" /scripts/lftp-conf-override.sh
	sed -ri "s|^pget_default_n='(.*)'$|pget_default_n='0'|g" /scripts/lftp-conf-override.sh
	#
	sed -ri "s|^mirror_args='(.*)'$|mirror_args='-c'|g" /scripts/lftp-conf-override.sh
	sed -ri "s|^mirror_parallel_transfer_count='(.*)'$|mirror_parallel_transfer_count='0'|g" /scripts/lftp-conf-override.sh
	sed -ri "s|^mirror_use_pget_n='(.*)'$|mirror_use_pget_n='0'|g" /scripts/lftp-conf-override.sh
	#
	echo "The lftp conf overrides have been reset to defaults."
	sleep 2
else
	sed -ri "s|^pget_args='(.*)'$|pget_args='$(echo "$1" | sed -e 's/^\"//' -e 's/\"$//' | sed 's#[~-¬`!£$%^&*()_+={}#:;@<,>.?|\/[]#\\&#g' | sed "s#'#'\\\\\\\''#g")'|g" /scripts/lftp-conf-override.sh
	sed -ri "s|^pget_default_n='(.*)'$|pget_default_n='$2'|g" /scripts/lftp-conf-override.sh
	#
	sed -ri "s|^mirror_args='(.*)'$|mirror_args='$(echo "$3" | sed -e 's/^\"//' -e 's/\"$//' | sed 's#[~-¬`!£$%^&*()_+={}#:;@<,>.?|\/[]#\\&#g' | sed "s#'#'\\\\\\\''#g")'|g" /scripts/lftp-conf-override.sh
	sed -ri "s|^mirror_parallel_transfer_count='(.*)'$|mirror_parallel_transfer_count='$4'|g" /scripts/lftp-conf-override.sh
	sed -ri "s|^mirror_use_pget_n='(.*)'$|mirror_use_pget_n='$5'|g" /scripts/lftp-conf-override.sh
	#
	echo "The lftp conf overrides have been set."
	sleep 2
fi
#
if [[ "${7}" = 'openlftpconfoverride' ]]; then
	"/applications/notepad/notepad++.exe" "$(cygpath -m /scripts/lftp-conf-override.sh)"
fi
