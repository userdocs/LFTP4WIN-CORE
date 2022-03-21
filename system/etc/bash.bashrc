# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.3-2

# /etc/bash.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/bash.bashrc

# Modifying /etc/bash.bashrc directly will prevent
# setup from updating it.

# System-wide bashrc file

# Check that we haven't already been sourced.
[[ -z ${CYG_SYS_BASHRC} ]] && CYG_SYS_BASHRC="1" || return

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Exclude *dlls from TAB expansion
export EXECIGNORE="*.dll"

# Set a default prompt of: user@host and current_directory
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
# Uncomment to use the terminal colours set in DIR_COLORS
# eval "$(dircolors -b /etc/DIR_COLORS)"
#
# LFTP4WIN changes below.
#
# Set the PATH be be specific to this installation.
PATH=/usr/local/bin:/usr/bin
#
# Set PATH so it includes user's private bin if it exists
if [[ -d "${HOME}/bin" ]]; then
	PATH="${HOME}/bin${PATH:+:${PATH}}"
fi
#
export HISTCONTROL=$HISTCONTROL:ignoredups
#
# Our custom PS1 prompt
PS1="\[\033[0;36m\][\[\033[0;31m\]\w\[\033[0;36m\]] \[\033[0m\]"
# Source the notifications script.
if [[ -f "/etc/notifications" ]]; then
	source "/etc/notifications"
fi
#
install_vscode() {
	echo
	echo "Downloading VSCode portable"
	echo
	if curl -skNL "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive" > "$HOME/vscode.zip"; then
		echo "Extracting VSCode portable to /applications/VSCode"
		echo
		if ! 7za -y x "$(cygpath -m $HOME/vscode.zip)" -o"$(cygpath -m "/applications/VSCode")" &> /dev/null; then
			echo "Extraction error - make sure vscode is closed!"
			echo
		else
			echo "VSCode downloaded, extracted and installed"
			echo
		fi
		#
		/applications/VSCode/bin/code --force --install-extension foxundermoon.shell-format 2> /dev/null
		/applications/VSCode/bin/code --force --install-extension timonwong.shellcheck 2> /dev/null
		/applications/VSCode/bin/code --force --install-extension yzhang.markdown-all-in-one 2> /dev/null
		/applications/VSCode/bin/code --force --install-extension vscode-icons-team.vscode-icons 2> /dev/null
		/applications/VSCode/bin/code --force --install-extension unifiedjs.vscode-remark 2> /dev/null
		# /applications/VSCode/bin/code --force --install-extension EXT_NAME  2> /dev/null
		rm -f "$HOME/vscode.zip"
	else
		echo "There was a problem downloading VSCode. Try again later"
	fi
}
#
install_git() {
	echo
	echo "Downloading git portable"
	echo
	git_version_1="$(curl -s https://github.com/git-for-windows/git/releases/latest | grep -oP "v(.*)\.windows\.[0-9]")"
	#
	if [[ "${git_version_1}" =~ ^v(.*)windows.1$ ]]; then
		git_version_2="${git_version_1#v}" && git_version_2="${git_version_2/\.windows\.1/}-64-bit"
	else
		git_version_2="${git_version_1#v}" && git_version_2="${git_version_2/\.windows/}-64-bit"
	fi
	#
	git_url="https://github.com/git-for-windows/git/releases/download/${git_version_1}/PortableGit-${git_version_2}.7z.exe"
	#
	if curl -skNL "${git_url}" > "$HOME/git.7z.exe"; then
		echo "Extracting git portable to /applications/git"
		echo
		if ! "$HOME/git.7z.exe" -y -o"$(cygpath -m "/applications/git")" &> /dev/null; then
			echo "Extraction error - make sure git is closed!"
			echo
		else
			echo "git downloaded, extracted and installed"
			echo
		fi
		rm -f "$HOME/git.7z.exe"
	else
		echo "There was a problem downloading git. Try again later"
	fi

}
#
# The pushover message script.
pushover() {
	if [[ -n "$pushover_api_token" ]]; then
		curl -4s -d message="Your transfer has finished $1" -d title="lftp-windows" -d token="$pushover_api_token" -d user="$pushover_user_key" 'https://api.pushover.net/1/messages.json' > /dev/null 2>&1 || :
	fi
}
#
# The pushbullet message script.
pushbullet() {
	if [[ -n "$pushbullet_api_key" ]]; then
		curl -4u ''"$pushbullet_api_key"':' 'https://api.pushbullet.com/v2/pushes' -d type="note" -d title="lftp-windows" -d body="Your transfer has finished $1" > /dev/null 2>&1 || :
	fi
}
#
# Load our functions for use across all scripts.
source "/scripts/functions.sh"
#
# Load ssh pageant to be used whenever conemu loads a terminal.
ssh_pageant
#
# The trap command executes the finish function on the specified signals.
trap finish EXIT SIGINT SIGTERM SIGHUP
