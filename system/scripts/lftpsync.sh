#! /usr/bin/env bash
#
# lftp sync script for used as a standalone script with ConEMU via Windows Task Scheduler.
#
# Credits: A heavily modified version of this idea and script http://www.torrent-invites.com/showthread.php?t=132965 towards a simplified end user experience.
# Authors: Lordhades - Adamaze - userdocs
#
# Github - https://github.com/userdocs/LFTP4WIN
#
source /scripts/lftpsync-config.sh
#
# This check is to set debugging to test a connection.
[[ -n "$1" && "$1" == 'debug' ]] && debug='debug 10' || debug=''
#
openssh_known_hosts "$port" "$hostname"
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
	sleep 2
	exit
else
	# Create the lock file.
	touch "$lock_file"
	# the lftp command we use followed by the hardcoded settings - these variables are either set above or passed by WinSCP using the custom commands.
	lftp -p "$port" -u ''"$username"','"$password"'' "$protocol://$hostname" <<-EOF
	$debug
	set mirror:parallel-transfer-count "$mirror_parallel_transfer_count"
	set mirror:use-pget-n "$mirror_use_pget_n"
	mirror $mirror_args "$remote_dir" "$local_dir/"
	quit
	EOF
	#
	source "$HOME/extensions/lftpsync.sh"
	#
	pushbullet "@ $(date '+%H:%M:%S')"
	pushover "@ $(date '+%H:%M:%S')"
	#
	exit
fi
