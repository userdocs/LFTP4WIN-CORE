# @name mirror-to-local
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/!" "!\" "%skipqueue%"
# @side Local
# @flag RemoteFiles
# @description LFTP mirror selected remote directory to local window.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -config checkbox "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash}" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li"
#
# @option - -config group "Settings"
#
# @option skipqueue -config checkbox "Skip queue confirmation" "" "skipqueue"
#
#! /usr/bin/env bash
#
# Credits: A heavily modified version of this idea and script http://www.torrent-invites.com/showthread.php?t=132965 towards a simplified end user experience.
# Authors: Lordhades - Adamaze - userdocs
#
# Github - https://github.com/userdocs/LFTP4WIN
#
source "/scripts/lftp-conf-override.sh"
#
winscp_to_bash "${@}"
#
[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"
#
lftp_conf_override
#
# Defines the lock file used per session - hard coded to be the same name in all scripts so that only one lftp job instance will run.
lock_file="/tmp/lftp-winscp.lock"
#
# This checks to see if LFTP is actually running and if the lock file exists. It LFTP is not running and there is a lock file it will be automatically cleared allowing the script to run.
[[ -z "$(ps | grep /usr/bin/lftp | awk '{print $1}')" ]] && rm -f "${lock_file}"
#
if [[ -f "${lock_file}" ]]; then
	echo "An lftp job is already running already."
	echo
	if [[ "${7}" = 'skipqueue' ]]; then
		queuestatus='y'
	else
		read -ep "Do you want to queue this download, enter [y] to queue or [n] to skip: " -i "y" queuestatus
		echo
	fi
	if [[ "${queuestatus}" =~ ^[Yy]$ ]]; then
		echo "lftp -p '${port}' -u '${username}','${password_hardcode}' '${protocol}://${hostname}' -e 'set mirror:parallel-transfer-count \"${mirror_parallel_transfer_count}\"; set mirror:use-pget-n \"${mirror_use_pget_n}\"; mirror ${mirror_args} \"${remote_dir_hardcode}\" \"${local_dir_hardcode}\"; quit'; local_dir='${local_dir_hardcode}'; remote_dir='${remote_dir_hardcode}'; source '${HOME}/extensions/mirror-to-local.sh'" >> "/scripts/queue/jobs.sh"
		echo 'This download has been queued. Use the Winscp Command "Queued Jobs" to view the queued jobs.'
		sleep 2
	fi
else
	# Create the lock file.
	touch "${lock_file}"
	# the lftp command we use followed by the hardcoded settings - these variables are either set above or passed by WinSCP using the custom commands.
	lftp -p "${port}" -u ''"${username}"','"${password}"'' "${protocol}://${hostname}" <<- EOF
		set mirror:parallel-transfer-count "${mirror_parallel_transfer_count}"
		set mirror:use-pget-n "${mirror_use_pget_n}"
		mirror ${mirror_args} "${remote_dir}" "${local_dir}"
		quit
	EOF
	#
	source "${HOME}/extensions/mirror-to-local.sh"
	#
	while [ -s "/scripts/queue/jobs.sh" ]; do
		echo "$(sed '1q;d' "/scripts/queue/jobs.sh")" > "/scripts/queue/runjobs.sh"
		source "/scripts/queue/runjobs.sh"
		rm -f "/scripts/queue/runjobs.sh"
		sed -i '1d' "/scripts/queue/jobs.sh"
	done
	#
	pushbullet "@ $(date '+%H:%M:%S')"
	pushover "@ $(date '+%H:%M:%S')"
fi
