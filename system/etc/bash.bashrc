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
if [[ -d "${HOME}/bin" ]] ; then
  PATH="${HOME}/bin${PATH:+:${PATH}}"
fi
# Our custom PS1 prompt
PS1="\[\033[0;36m\][\[\033[0;31m\]\w\[\033[0;36m\]] \[\033[0m\]"
# Source the notifications script.
if [[ -f "/etc/notifications" ]]; then
source "/etc/notifications"
fi
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