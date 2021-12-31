# @name iperf3
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/" "!\" "%IPERF3PORT%" %TERMINAL%
# @side Local
# @flag
# @description Install iperf3 on the remote server and run a test using iperf3 and mtr. A random remote port is used so you may need to disable your firewall temporarily.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -config checkbox "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash}" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li"
#
# @option IPERF3PORT -config -run textbox "Select a port to override the random generation" ""
#! /usr/bin/env bash
#
winscp_to_bash "${@}"
#
[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"
#
export SSHPASS="${password}"
#
if [[ -n "$(echo "${8}" | grep -o 'ConEmu64.exe')" ]]; then
	/applications/conemu/ConEmu64.exe -run {Bash::bash} -c "sshpass -f '/tmp/.password' ssh -qt -p '${port}' '${username}@${hostname}' 'export IPERF3PORT=${7} && bash -li <(curl -4sL https://git.io/fjRIi)'" -new_console:s &
fi
#
if [[ -n "$(echo "${8}" | grep -o 'mintty.exe')" ]]; then
	/bin/mintty.exe --title 'Iperf3 Remote' -e /bin/bash -lic "sshpass -e ssh -qt -p '$port' '${username}@${hostname}' 'export IPERF3PORT=${7} && bash -li <(curl -4sL https://git.io/fjRIi)'" &
fi
#
sleep 5
#
lftp -p "${port}" -u "${username},$password" "${protocol}://${hostname}" <<- EOF
	pget -c '~/.iperf3port' -o "/tmp"
	quit
EOF
#
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
