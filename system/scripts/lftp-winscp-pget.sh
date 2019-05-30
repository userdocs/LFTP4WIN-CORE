#! /usr/bin/env bash
#
# Credits: A heavily modified version of this idea and script http://www.torrent-invites.com/showthread.php?t=132965 towards a simplified end user experience.
# Authors: Lordhades - Adamaze - userdocs
#
# Github - https://github.com/userdocs/LFTP4WIN
#
source "/scripts/lftp-conf-override.sh"
#
winscp_to_bash "$1" "$2" "$3" "$4" "$5" "$6" "$7"
#
lftp_conf_override
#
# Defines the lock file used per session - hard coded to be the same name in all scripts so that only one lftp job instance will run.
lock_file="/tmp/lftp-winscp.lock"
#
# This checks to see if LFTP is actually running and if the lock file exists. It LFTP is not running and there is a lock file it will be automatically cleared allowing the script to run.
[[ -z "$(ps | grep /usr/bin/lftp | awk '{print $1}')" ]] && rm -f "$lock_file"
#
if [[ -f "$lock_file" ]]
#
then
	echo "An lftp job is already running already."
	echo
    if [[ "$8" = 'skipqueue' ]]; then
        queuestatus='y'
    else
        read -ep "Do you want to queue this download, enter [y] to queue or [n] to skip: " -i "y" queuestatus
        echo
    fi
	if [[ "$queuestatus" =~ ^[Yy]$ ]]; then
		echo "lftp -p '$port' -u '$username,$queued_password' '$protocol://$hostname' -e 'set pget:default-n \"$pget_default_n\"; pget $pget_args \"$queued_remote_dir\" -o \"$queued_local_dir\"; quit'; local_dir=\"$queued_local_dir\"; remote_dir=\"$queued_remote_dir\"; source \"$HOME/extensions/pget-to-local.sh\"" >> "/scripts/queue/jobs.sh"
		echo 'This download has been queued. Use the Winscp Command "Queued Jobs" to view the queued jobs.'
		sleep 2
	fi
	exit
else
	# Create the lock file.
	touch "$lock_file"
	# the lftp command we use followed by the hardcoded settings - these variables are either set above or passed by WinSCP using the custom commands.
	lftp -p "$port" -u ''"$username"','"$password"'' "$protocol://$hostname" <<-EOF
	set pget:default-n "$pget_default_n"
	pget $pget_args "$remote_dir" -o "$local_dir"
	quit
	EOF
	#
	source "$HOME/extensions/pget-to-local.sh"
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
	#
	exit
fi
