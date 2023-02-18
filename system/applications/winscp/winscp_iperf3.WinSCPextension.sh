# @name iperf3
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" !`bash -c 'base64 -w 0 <<< "!S"'` "!/" "!\" "%IPERF3PORT%" "%REMOTEARCH%" %TERMINAL%
# @side Local
# @flag
# @description Install iperf3 on the remote server and run a test using iperf3 and mtr. A random remote port is used so you may need to disable your firewall temporarily.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -run -config dropdownlist "Select your terminal" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN_IPERF3 -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash} -new_console:t:LFTP4WIN_IPERF3"=conemu """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN_IPERF3 -e /bin/bash -li"=mintty "%LocalAppData%\Microsoft\WindowsApps\wt.exe -w 0 nt --title LFTP4WIN_IPERF3 ""%WINSCP_PATH%\..\..\bin\bash.exe"" -li"=windows_terminal
#
# @option IPERF3PORT -config -run textbox "Select a port to override the random generation" ""
#
# @option REMOTEARCH -config -run dropdownlist "Select the remote arch:" "amd64" "amd64" "arm64v8" "arm32v7" "arm32v6" "i386" "ppc64le" "s390x"
#
#! /usr/bin/env bash

winscp_to_bash "${@}"

[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"

if [[ "${9##*\\}" == 'ConEmu64.exe' ]]; then
	if [[ -z "${password}" ]]; then
		/applications/conemu/ConEmu64.exe -run {Bash::bash} -c "ssh -qt -p '${port}' '${username}@${hostname}' 'export IPERF3PORT=${7} && export REMOTEARCH=${8} && bash -li <(curl -4sL https://git.io/fjRIi)'" -new_console:s:t:LFTP4WIN_IPERF3_REMOTE &
	else
		/applications/conemu/ConEmu64.exe -run {Bash::bash} -c "passh -p env:password ssh -qt -p '${port}' '${username}@${hostname}' 'export IPERF3PORT=${7} && export REMOTEARCH=${8} && bash -li <(curl -4sL https://git.io/fjRIi)'" -new_console:s:t:LFTP4WIN_IPERF3_REMOTE &
	fi
fi

if [[ "${9##*\\}" == 'mintty.exe' ]]; then
	if [[ -z "${password}" ]]; then
		/bin/mintty.exe --title LFTP4WIN_IPERF3_REMOTE -e /bin/bash -c "ssh -qt -p '$port' '${username}@${hostname}' 'export IPERF3PORT=${7} && export REMOTEARCH=${8} && bash -li <(curl -4sL https://git.io/fjRIi)'" &
	else
		/bin/mintty.exe --title LFTP4WIN_IPERF3_REMOTE -e /bin/bash -c "passh -p env:password ssh -qt -p '$port' '${username}@${hostname}' 'export IPERF3PORT=${7} && export REMOTEARCH=${8} && bash -li <(curl -4sL https://git.io/fjRIi)'" &
	fi
fi

if [[ "${9##*\\}" =~ (-w|wt.exe) ]]; then
	if [[ -z "${password}" ]]; then
		"$(cygpath -u "${LOCALAPPDATA}\Microsoft\WindowsApps\wt.exe")" -w 0 nt --title LFTP4WIN_IPERF3_REMOTE bash -c "ssh -qt -p '$port' '${username}@${hostname}' 'export IPERF3PORT=${7} && export REMOTEARCH=${8} && bash -li <(curl -4sL https://git.io/fjRIi)'" &
	else
		"$(cygpath -u "${LOCALAPPDATA}\Microsoft\WindowsApps\wt.exe")" -w 0 nt --title LFTP4WIN_IPERF3_REMOTE bash -c "passh -p env:password ssh -qt -p '$port' '${username}@${hostname}' 'export IPERF3PORT=${7} && export REMOTEARCH=${8} && bash -li <(curl -4sL https://git.io/fjRIi)'" &
	fi
fi

sleep 5

lftp -p "${port}" -u "${username},$password" "${protocol}://${hostname}" <<- EOF
	pget -c '~/.iperf3port' -o "/tmp"
	quit
EOF

echo 'Generating iperf3 report - Server to Client' | tee "${HOME}/../help/reports/report-${hostname}.txt"
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
#
iperf3 -4 -p "$(cat "/tmp/.iperf3port")" -c "${hostname}" -R | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
#
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
echo 'Generating iperf3 report - Client to Server' | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
#
iperf3 -4 -p "$(cat "/tmp/.iperf3port")" -c "${hostname}" | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
#
rm -f /tmp/.iperf3port
rm -f /tmp/.password
#
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
echo 'Generating MTR report...' | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
mtr -r4 "${hostname}" | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
#
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
echo 'This report has been saved to the help/reports directory.' | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
echo | tee -a "${HOME}/../help/reports/report-${hostname}.txt"
read -ep "Are you ready to close the terminals?: " -i "y" quitme
#
if [[ "${quitme}" =~ ^[Yy]$ ]]; then
	exit
fi
