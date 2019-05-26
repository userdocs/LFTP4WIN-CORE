# @name notifications
# @command cmd /c start "" "%WINSCP_PATH%\..\conemu\ConEmu64.exe" -run {Bash::bash} "%EXTENSION_PATH%" "%pushoverkey%" "%pushovertoken%" "%pushbullet%" "%reset%" "%openotifications%"
# @side Local
# @flag
# @description Use this command to enter your API keys and tokens for push notifications
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option reset -run checkbox "Reset the notifications settings file" "" "reset"
# @option openotifications -run checkbox "Open the notifications settings file with notepad++" "" "openotifications"
#
# @option - -config -run group "Pushover settings"
#
# @option pushoverkey -config -run textbox "Enter your Pushover API key here:" ""
# @option pushovertoken -config -run textbox "Enter your Pushover token here:" ""
#
# @option - -config -run group "Pushbullet settings"
#
# @option pushbullet -config -run textbox "Enter your Pushbullet API key here:" ""
#
# @option - -config -run group "Notifications Settings Help"
#
# @option - -config -run link https://git.io/fjBHX
#
#! /usr/bin/env bash
#
if [[ "$4" = 'reset' || "$5" = 'reset' ]]; then
	sed -ri "s|^pushover_user_key='(.*)'$|pushover_user_key=''|g" /etc/notifications
	sed -ri "s|^pushover_api_token='(.*)'$|pushover_api_token=''|g" /etc/notifications
	sed -ri "s|pushbullet_api_key='(.*)'$|pushbullet_api_key=''|g" /etc/notifications
	#
	echo "Your notifications settings have been reset to the defaults."
	sleep 2
else
	sed -ri "s|^pushover_user_key='(.*)'$|pushover_user_key='$1'|g" /etc/notifications
	sed -ri "s|^pushover_api_token='(.*)'$|pushover_api_token='$2'|g" /etc/notifications
	sed -ri "s|pushbullet_api_key='(.*)'$|pushbullet_api_key='$3'|g" /etc/notifications
	#
	echo "Your notifications settings have been set."
	sleep 2
fi
#
if [[ "$4" = 'openotifications' || "$5" = 'openotifications' ]]; then
	"/applications/notepad/notepad++.exe" "$(cygpath -m /etc/notifications)"
fi
#
exit
