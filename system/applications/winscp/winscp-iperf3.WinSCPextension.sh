# @name iperf3
# @command cmd /c start "" "%WINSCP_PATH%\..\kitty\kitty_portable.exe" -pw "!P" "!U@!@" -P "!#" -title "!N" -classname "iperf3" -cmd "export IPERF3PORT=%IPERF3PORT% && bash <(curl -4sL https://git.io/fjRIi)" && start "" "%WINSCP_PATH%\..\conemu\ConEmu64.exe" -run {Bash::bash} "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/" "!\" "!P"
# @side Local
# @flag
# @description Install iperf3 on the remote server and run a test using iperf3 and mtr. A random remote port is used so you may need to disable your firewall temporarily.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option IPERF3PORT -config -run textbox "Select a port to override the random generation" ""
#! /usr/bin/env bash
#
winscp_to_bash "$1" "$2" "$3" "$4" "$5" "$6" "$7"
#
openssh_known_hosts "$port" "$hostname"
#
sleep 10
#
lftp -p "$port" -u "$username,$password" "$protocol://$hostname" <<-EOF
pget -c '~/.iperf3port' -o "/tmp"
quit
EOF
#
echo 'Generating iperf3 report - Server to Client' | tee "$HOME/../help/reports/report-$hostname.txt"
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
#
iperf3 -4 -p "$(cat "/tmp/.iperf3port")" -c "$hostname" -R | tee -a "$HOME/../help/reports/report-$hostname.txt"
#
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
echo 'Generating iperf3 report - Client to Server' | tee -a "$HOME/../help/reports/report-$hostname.txt"
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
#
iperf3 -4 -p "$(cat "/tmp/.iperf3port")" -c "$hostname" | tee -a "$HOME/../help/reports/report-$hostname.txt"
#
rm -f /tmp/.iperf3port
#
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
echo 'Generating MTR report...' | tee -a "$HOME/../help/reports/report-$hostname.txt"
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
mtr -r4 "$hostname" | tee -a "$HOME/../help/reports/report-$hostname.txt"
#
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
echo 'This report has been saved to the help/reports directory.' | tee -a "$HOME/../help/reports/report-$hostname.txt"
echo | tee -a "$HOME/../help/reports/report-$hostname.txt"
read -ep "Are you ready to close the terminals?: " -i "y" quitme
#
if [[ "$quitme" =~ ^[Yy]$ ]]; then
	"/applications/kitty/kitty_portable.exe" -classname "iperf3" -sendcmd "\x03"
	"/applications/kitty/kitty_portable.exe" -classname "iperf3" -sendcmd "exit"
	exit
fi
#