#!/usr/bin/env bash

# A function that performs some useful commands upon the script exiting.

export ssh_pageant_random="${RANDOM}"

function openssh_known_hosts() {
	# Make sure this folder exists. If it does not, then create it to prevent errors in the function.
	[[ ! -d ~/.ssh ]] && mkdir ~/.ssh
	# Create a blank known_hosts files to prevent errors.
	[[ ! -f ~/.ssh/known_hosts ]] && touch ~/.ssh/known_hosts
	# Compare the remote known host to those stored in the local known_hosts file. If the match fails then add the keys to the file.
	[[ -n $(diff <(ssh-keyscan -4p "${1}" "${2}" 2> /dev/null | sort -h) <(ssh-keygen -F "${2}" | sed '/^# Host/ d' | sort -h)) ]] && ssh-keyscan -4p "${1}" "${2}" >> ~/.ssh/known_hosts 2> /dev/null
	# Since it adds multiple keys and may introduce duplicates, sort the file, remove duplicates and then save it.
	sort ~/.ssh/known_hosts | uniq > ~/.ssh/known_hosts_temp && mv -f ~/.ssh/known_hosts_temp ~/.ssh/known_hosts
}

function finish() {
	# Kills the ssh-pageant process for this session using the built in kill switch.
	ssh-pageant -q -k &> /dev/null
	# Removes the ssh-pageant tmp file for this session.
	rm -f "/tmp/AUTH-LFTP4WIN-${ssh_pageant_random}" &> /dev/null
	# Removes the lftpvar.txt which may contain sensitive data.
	[[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' && -f "${HOME}/lftpvar.txt" ]] && rm -f "${HOME}/lftpvar.txt" &> /dev/null
	# Removes the lock file.
	pgrep ^lftp$ || rm -f "${lock_file:-/tmp/lftp-winscp.lock}"
	# Remove the empty /cygdrive dir created by the script but never do this recursively or it will be interpreted as /cygdrive/c/your hard drive.
	[[ -d /cygdrive ]] && rmdir "/cygdrive" 2> /dev/null
	# Clean the tmp dir once the last conemu
	pgrep ^conemu-cyg-64$ || find /tmp -type s -exec rm -f '{}' \;
	[[ "$(basename "${0}")" =~ ^winscp_(.*).WinSCPextension.sh$ ]] && history -c
}

function ssh_pageant() {
	# ssh-pageant is loaded so that lftp can use our putty ppk keyfile for auth so we can use a single keyfile.
	eval "$(ssh-pageant -q -a "/tmp/AUTH-LFTP4WIN-${ssh_pageant_random}")"
}

function lftp_conf_override() {
	# These checks will use the lftp.conf settings if the relevant variables are left blank in the settings.
	if [[ "$(basename "${0}")" == 'winscp_pget_to_local.WinSCPextension.sh' ]]; then
		[[ -z $pget_default_n || $pget_default_n -eq '0' ]] && pget_default_n="$(sed -rn 's#set pget:default-n (.*)#\1#p' "/etc/lftp.conf")"
	fi

	if [[ "$(basename "${0}")" == 'winscp_mirror_to_local.WinSCPextension.sh' ]]; then
		[[ -z $mirror_parallel_transfer_count || $mirror_parallel_transfer_count -eq '0' ]] && mirror_parallel_transfer_count="$(sed -rn 's#set mirror:parallel-transfer-count (.*)#\1#p' "/etc/lftp.conf")"
		[[ -z $mirror_use_pget_n || "mirror_use_pget_n" -eq '0' ]] && mirror_use_pget_n="$(sed -rn 's#set mirror:use-pget-n (.*)#\1#p' "/etc/lftp.conf")"
	fi
}

function winscp_to_bash() {
	# The WinSCP to bash script will take WinSCP custom command variables passed in a specific order and convert them to bash variables for use with scripting.
	# "!U" "!@" "!#" "!S" "!/" "!\"

	# 1 # !U - Get session username
	[[ -n ${1} ]] && username="${1}" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "username = ${username}" > "${HOME}/lftpvar.txt"

	# 2 # !@ - Get session hostname
	[[ -n ${2} ]] && hostname="${2}" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "hostname = ${hostname}" >> "${HOME}/lftpvar.txt"

	# 3 # !# - Get session port
	[[ -n ${3} ]] && port="${3}" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "port = ${port}" >> "${HOME}/lftpvar.txt"

	# 4 # !S - Process the full encoded session URL to get our password and connection protocols.

	# To work with windows terminal we needed to base64 encode the session URL to avoid character conflict with ; - now we decode it.
	session_url="$(base64 --decode <<< "${4}")"

	# Log to file when using lftp
	[[ -n ${session_url} && "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "session = ${session_url}" >> "${HOME}/lftpvar.txt"

	# Check is the session URL contains a password. If the result is empty then do nothing.
	if [[ -n "$(echo "${session_url}" | cut -f3 -d":" | cut -f1 -d";" | cut -f1 -d"@")" ]]; then
		# Get the URL encoded password string from the session URL and convert this to its un-encoded form to use with openssh and lftp to avoid special character issues.
		password=''"$(printf %b "$(printf %s "${session_url//\%/\\x}" | cut -f3 -d":" | cut -f1 -d";" | cut -f1 -d"@")")"'' && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "password = ${password}" >> "${HOME}/lftpvar.txt"
		# Echo the password to a text file to use with sshpass if the environment variable is not usable when ConEMU is laoded.
		[[ "$(basename "${0}")" == 'winscp_iperf3.WinSCPextension.sh' ]] && echo "$password" > "/tmp/.password"
		# The password with single quotes escaped for reuse or hardcoding into a script. This is adequate to hard code this variable into a script that will be called by another script. script > file > queued jobs script
		password_hardcode="${password//\'/\'\\\'\'}"
		# The password that is fully escaped for additional reuse such as script > sed > file > lftpsync script
		password_escaped="$(printf %q "$password_hardcode")"
		# Modifiers
		[[ "$(basename "${0}")" == 'winscp_lftpsync_setup.WinSCPextension.sh' ]] && password="$password_escaped"
	fi

	# Get session protocol type from - "!S" - Some checks are used to make sure variations of the protocol type are set correctly for use with lftp.
	[[ -n ${session_url} ]] && protocol="$(echo "${session_url}" | cut -d":" -f 1)" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "protocol = ${protocol}" >> "${HOME}/lftpvar.txt"

	# Set the protocol used in the script based detected protocol.
	[[ $protocol =~ ^(ftpes|ftps|ftp)$ ]] && protocol="ftp" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "protocol_used = ${protocol}" >> "${HOME}/lftpvar.txt"
	[[ $protocol =~ ^sftp$ ]] && protocol="sftp" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "protocol_used = ${protocol}" >> "${HOME}/lftpvar.txt"

	# 5 # !/! - Get Remote path of currently visited directory - "!/" - or selected file or folder - When WinSCP passes the path to the script it automatically wraps them in quotes only if the path has Unicode characters. So we need to remove them for consistency.
	if [[ -n ${5} ]]; then
		# The literal path that is not escaped in anyway. Works with direct calls in a scripts or to a file but can fail when passed through another program like sed.
		remote_dir="$(echo "${5}" | sed -r 's/^"(\/.*)"$/\1/')" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "remote_dir = ${remote_dir}" >> "${HOME}/lftpvar.txt"
		# The path with single quotes escaped for reuse or hardcoding into a script. This is adequate to hard code this variable into a script that will be called by another script. script > file > queued jobs script
		remote_dir_hardcode="${remote_dir//\'/\'\\\'\'}"
		# The hard coded path that is fully escaped for additional reuse such as script > sed > file > lftpsync script
		remote_dir_escaped="$(printf %q "${remote_dir_hardcode}")"
		# Modifiers
		[[ "$(basename "${0}")" == 'winscp_lftpsync_setup.WinSCPextension.sh' ]] && remote_dir="${remote_dir_escaped}"
		[[ "$(basename "${0}")" == 'winscp_openssh.WinSCPextension.sh' ]] && remote_dir="${remote_dir_hardcode}"
	fi

	# 6 # !\ - Get Local path of currently visited directory - Gets the local path and converts is to a cygwin format path.
	if [[ -n ${6} && ${6} =~ ^\"?[A-Z]:(\\)?(.*)? ]]; then
		# The literal path that is not escaped in anyway. Works with direct calls in a scripts or to a file but can fail when passed through another program like sed.
		local_dir="$(cygpath -u "$(echo "${6}" | sed -r 's/^"([A-Z]:.*)"$/\1/')")/" && [[ "$(basename "${0}")" == 'winscp_lftp.WinSCPextension.sh' ]] && echo "local_dir = ${local_dir}" >> "${HOME}/lftpvar.txt"
		# The path with single quotes escaped for reuse or hardcoding into a script. This is adequate to hard code this variable into a script that will be called by another script. script > file > queued jobs script
		local_dir_hardcode="${local_dir//\'/\'\\\'\'}"
		# The hard coded path that is fully escaped for additional reuse such as script > sed > file > lftpsync script
		local_dir_escaped="$(printf %q "${local_dir_hardcode}")"
		# Modifiers
		[[ "$(basename "${0}")" == 'winscp_lftpsync_setup.WinSCPextension.sh' ]] && local_dir="${local_dir_escaped}"
	fi
	return
}

function winscp_variables() {
	printf '%s\n' "username=${username}" "hostname=${hostname}" "port=${port}" "password=${password}" "protocol=${protocol}" "remote_dir=${remote_dir}" "local_dir=${local_dir}" "session_url=${session_url}"
}
