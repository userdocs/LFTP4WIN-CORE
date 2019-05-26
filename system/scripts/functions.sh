# A function that performs some useful commands upon the script exiting.
#
ssh_pageant_random=$RANDOM
#
function finish {
	# Kills the ssh-pageant process for this session using the built in kill switch.
	ssh-pageant -q -k > /dev/null 2>&1 || :
	# Removes the ssh-pageant tmp file for this session.
	rm -f "/tmp/AUTH-LFTP4WIN-$ssh_pageant_random" > /dev/null 2>&1 || :
	# Removes the lftpvar.txt which may contain sensitive data.
	[[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' && -f "$HOME/lftpvar.txt" ]] && rm -f "$HOME/lftpvar.txt" > /dev/null 2>&1 || :
	# Removes the lock file.
	[[ "$(ps x | grep -cow '/usr/bin/lftp$')" -eq '0' ]] && rm -f "$lock_file" || :
	# Remove the empty /cygdrive dir created by the script but never do this recursively or it will be interpreted as /cygdrive/c/your hard drive.
	[[ -d /cygdrive ]] && rmdir "/cygdrive" 2> /dev/null || :
	# Clean the tmp dir once the last conemu
	[[ "$(ps x | grep -cow '/applications/conemu/ConEmu/conemu-cyg-64$')" -eq '1' ]] && find /tmp -type s -exec rm -f '{}' \; || :
}
#
function ssh_pageant {
	# ssh-pageant is loaded so that lftp can use our putty ppk keyfile for auth so we can use a single keyfile.
	eval "$(ssh-pageant -q -a "/tmp/AUTH-LFTP4WIN-$ssh_pageant_random")"
	#
}
#
function lftp_conf_override {
	# These checks will use the lftp.conf settings if the relevant variables are left blank in the settings.
	if [[ "$(basename "$0")" = 'lftp-winscp-pget.sh' ]]; then
		[[ -z "$pget_default_n" || "$pget_default_n" -eq '0' ]] && pget_default_n="$(sed -rn 's#set pget:default-n (.*)#\1#p' "/etc/lftp.conf")" || :
	else
		:
	fi
	if [[ "$(basename "$0")" = 'lftp-winscp-mirror.sh' ]]; then
		[[ -z "$mirror_parallel_transfer_count" || "$mirror_parallel_transfer_count" -eq '0' ]] && mirror_parallel_transfer_count="$(sed -rn 's#set mirror:parallel-transfer-count (.*)#\1#p' "/etc/lftp.conf")" || :
		[[ -z "$mirror_use_pget_n" || "mirror_use_pget_n" -eq '0' ]] && mirror_use_pget_n="$(sed -rn 's#set mirror:use-pget-n (.*)#\1#p' "/etc/lftp.conf")" || :
	else
		:
	fi
	#
}
#
function winscp_to_bash {
	# The WinSCP to bash script will take WinSCP custom command variables passed in a specific order and convert them to bash variables for use with scripting.
	#
	# "!U" "!@" "!#" "!S" "!/" "!\" "!P"
	#
	# Get session username - "!U"
	[[ -n "$1" ]] && username="$1" && [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "username='$username'" > "$HOME/lftpvar.txt" || :
	#
	# Get session hostname - "!@"
	[[ -n "$2" ]] && hostname="$2" && [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "hostname='$hostname'" >> "$HOME/lftpvar.txt" || :
	#
	# Get session port - "!#"
	[[ -n "$3" ]] && port="$3" && [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "port='$port'" >> "$HOME/lftpvar.txt" || :
	#
	# Export full session path for the winscp-lftp.WinSCPextension.sh script if used - "!S"
	[[ -n "$4" && "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "session='$4'" >> "$HOME/lftpvar.txt" || :
	#
	# Get session protocol type from - "!S" - Some checks are used to make sure variations of the protocol type are set correctly for use with lftp.
	[[ -n "$4" ]] && protocol="$(echo $4 | cut -d\: -f 1)" && [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "protocol='$protocol'" >> "$HOME/lftpvar.txt" || :
	[[ "$protocol" =~ ^(ftpes|ftps|ftp)$ ]] && protocol="ftp" && [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "protocol_used='$protocol'" >> "$HOME/lftpvar.txt" || :
	[[ "$protocol" =~ ^sftp$ ]] && protocol="sftp" && [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]] && echo "protocol_used='$protocol'" >> "$HOME/lftpvar.txt" || :
	#
	# Get Remote path of currently visited directory - "!/" - or selected file or folder - "!/!" - When WinSCP passes the path to the script it automatically wraps them in quotes only if the path has Unicode characters. So we need to remove them for consistency.
	if [[ -n "$5" ]]; then 
		if [[ "$(basename "$0")" = 'winscp-lftpsync-setup.WinSCPextension.sh' ]]; then
			remote_dir="$(echo "$5" | sed -e 's/^\"//' -e 's/\"$//' | sed 's#[~-¬`!£$%^&*()_+={}#:;@<,>.?|\[]#\\&#g' | sed "s#'#'\\\\\\\''#g")"
		else
			remote_dir="$(echo "$5" | sed -e 's/^\"//' -e 's/\"$//')"
			queued_remote_dir="$(echo "$5" | sed -e 's/^\"//' -e 's/\"$//' | sed "s#'#'\\\\\''#g")"
			if [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]]; then
				echo remote_dir="'$(echo "$5" | sed -e 's/^\"//' -e 's/\"$//' | sed "s#'#'\\\\\''#g")'" >> "$HOME/lftpvar.txt"
			else
				:
			fi
		fi
	fi
	#
	# Get Local path of currently visited directory - "!\" - Gets the local path and converts is to a cygwin format path.
	if [[ -n "$6" && "$6" =~ ^\"?[A-Z]:(\\)?(.*)? ]]; then
		if [[ "$(basename "$0")" = 'winscp-lftpsync-setup.WinSCPextension.sh' ]]; then
			local_dir="$(cygpath -u "$(echo "$6" | sed -e 's/^\"//' -e 's/\"$//')" | sed 's#[~-¬`!£$%^&*()_+={}#:;@<,>.?|\[]#\\&#g' | sed "s#'#'\\\\\\\''#g")"
		else
			local_dir="$(cygpath -u "$(echo "$6" | sed -e 's/^\"//' -e 's/\"$//')")/"
			queued_local_dir="$(cygpath -u "$(echo "$6" | sed -e 's/^\"//' -e 's/\"$//')" | sed "s#'#'\\\\\''#g")/"
			if [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]]; then
				echo local_dir="'$(cygpath -u "$(echo "$6" | sed -e 's/^\"//' -e 's/\"$//')" | sed "s#'#'\\\\\''#g")/'" >> "$HOME/lftpvar.txt"
			else
				:
			fi
		fi
	fi
	#
	# Get Password - "!P" - if a password is used with the session
	if [[ -n "$7" ]]; then
		if [[ "$(basename "$0")" = 'winscp-lftpsync-setup.WinSCPextension.sh' ]]; then
			password="$(echo "$7" | sed -e 's/^\"//' -e 's/\"$//' | sed 's#[~-¬`!£$%^&*()_+={}#:;@<,>.?|\/[]#\\&#g' | sed "s#'#'\\\\\\\''#g")"
		else
			password="$(echo "$7" | sed -e 's/^\"//' -e 's/\"$//')"
			queued_password="$(echo "$7" | sed -e 's/^\"//' -e 's/\"$//' | sed "s#'#'\\\\\''#g")"
			if [[ "$(basename "$0")" = 'winscp-lftp.WinSCPextension.sh' ]]; then
				echo password="'$(echo "$7" | sed -e 's/^\"//' -e 's/\"$//' | sed "s#'#'\\\\\''#g")'" >> "$HOME/lftpvar.txt"
			else
				:
			fi
		fi
	fi
}
