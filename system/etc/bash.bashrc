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
[[ $- != *i* ]] && return

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
export HISTCONTROL=$HISTCONTROL:ignoreboth
#
# Our custom PS1 prompt
PS1="\[\033[0;36m\][\[\033[0;31m\]\w\[\033[0;36m\]] \[\033[0m\]"
# Source the notifications script.
if [[ -f "/etc/notifications" ]]; then
	source "/etc/notifications"
fi
#

install_vscode() {
	printf "\n"
	PS3=$'\n'"Select your version of VSCode please: "
	options=("vscode" "vscodium" "quit")
	select opt in "${options[@]}"; do
		case $opt in
			"vscode")
				vscode_url="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
				vscode_appname="VSCode"
				sed -ri 's|VSCodium.exe|code.exe|g' "../help/start - vscode.cmd"
				break
				;;
			"vscodium")
				vscodium_tag="$(git ls-remote -q -t --refs https://github.com/VSCodium/vscodium.git | awk '{sub(\"refs/tags/\", \"\"); sub(\"(.*)(-|rc|alpha|beta|[a-z]$)\", \"\"); print $2 }' | awk '!/^$/ ' | sort -Vr | head -n 1)"
				vscode_url="https://github.com/VSCodium/vscodium/releases/latest/download/VSCodium-win32-x64-${vscodium_tag}.zip"
				vscode_appname="VSCodium"
				sed -ri 's|code.exe|VSCodium.exe|g' "../help/start - vscode.cmd"
				break
				;;
			"quit")
				printf '\n%s\n\n' "Returning to parent"
				return
				;;
			*)
				printf "\n%s\n" "invalid option $REPLY"
				;;
		esac
	done

	printf "\n"
	PS3=$'\n'"Install plugins/extensions? "
	plugin_options=("yes" "no")
	select plugin_opt in "${plugin_options[@]}"; do
		case $plugin_opt in
			"yes")
				NO_PLUGINS=0
				break
				;;
			"no")
				NO_PLUGINS=1
				break
				;;
			*)
				printf "\n%s\n" "invalid option $REPLY"
				;;
		esac
	done

	printf '\n%s\n\n' "Downloading ${vscode_appname} portable"

	if curl -skNL "${vscode_url}" > "$HOME/vscode.zip"; then
		printf '%s\n\n' "Extracting ${vscode_appname} portable to /applications/VSCode"
		if ! 7za -y x "$(cygpath -m $HOME/vscode.zip)" -o"$(cygpath -m "/applications/VSCode")" &> /dev/null; then
			printf '%s\n\n' "Extraction error - make sure vscode is closed!"
		else
			printf '%s\n\n' "VSCode downloaded, extracted and installed"
		fi

		if [[ $NO_PLUGINS -eq 0 ]]; then
			if [[ -f "$HOME/.vscode_extensions" ]]; then
				while IFS= read -r line; do
					echo "Processing: ${line}"
					/applications/VSCode/bin/code --force --install-extension "${line}" 2> /dev/null
				done < "$HOME/.vscode_extensions"
			else
				/applications/VSCode/bin/code --force --install-extension foxundermoon.shell-format 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension timonwong.shellcheck 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension yzhang.markdown-all-in-one 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension DaltonMenezes.aura-theme 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension EditorConfig.EditorConfig 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension DavidAnson.vscode-markdownlint 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension redhat.vscode-yaml 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension ms-vscode-remote.remote-wsl 2> /dev/null
				/applications/VSCode/bin/code --force --install-extension oderwat.indent-rainbow 2> /dev/null
			fi
		fi

		# /applications/VSCode/bin/code --force --install-extension EXT_NAME  2> /dev/null
		rm -f "$HOME/vscode.zip"
		return
	else
		printf '%s\n' "There was a problem downloading VSCode. Try again later"
		return 1
	fi
}
#
install_git() {
	git_version_1="$(git ls-remote -q -t --refs https://github.com/git-for-windows/git.git | awk '/v/{sub("refs/tags/v", ""); sub("(.*)(-|rc|msysgit|[a-z]$)", ""); print $2 }' | awk '!/^$/' | sort -rV | head -n 1)"
	git_version_2="${git_version_1/\.windows*/}-64-bit"
	git_url="https://github.com/git-for-windows/git/releases/download/v${git_version_1}/PortableGit-${git_version_2}.7z.exe"
	echo
	echo "Downloading git portable with tag: v${git_version_1}"
	echo

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

install_croc() {
	curl -sL "https://raw.githubusercontent.com/schollz/croc/main/src/install/default.txt" -o /tmp/croc_install.sh
	chmod 700 /tmp/croc_install.sh
	bash /tmp/croc_install.sh
	[[ -f /tmp/croc_install.sh ]] && rm -f /tmp/croc_install.sh
	return
}

install_bashit() {
	if [[ ! -d ~/.bash_it ]]; then
		git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
		~/.bash_it/install.sh
	else
		printf '\n%s\n' "Bash-it is already install, use it to update or reset. See otptions using the command: bashit"
	fi
}

#
# The pushover message script.
pushover() {
	if [[ -n $pushover_api_token ]]; then
		curl -4s -d message="Your transfer has finished $1" -d title="lftp-windows" -d token="$pushover_api_token" -d user="$pushover_user_key" 'https://api.pushover.net/1/messages.json' > /dev/null 2>&1 || :
	fi
}
#
# The pushbullet message script.
pushbullet() {
	if [[ -n $pushbullet_api_key ]]; then
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
