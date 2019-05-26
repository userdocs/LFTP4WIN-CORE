# @name iperf3
# @command cmd /c start "" "%WINSCP_PATH%\..\kitty\kitty_portable.exe" -pw "!P" "!U@!@" -P "!#" -title "!N" -classname "iperf3" -cmd "bash <(curl -4sL https://git.io/fjRIi)" && start "" "%WINSCP_PATH%\..\conemu\ConEmu64.exe" -run {Bash::bash} "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/" "!\" "!P"
# @side Local
# @flag
# @description Install iperf3 on the remote server and run a test using iperf3 and mtr. A random remote port is used so you may need to disable your firewall temporarily.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
#! /usr/bin/env bash
#
winscp_to_bash "$1" "$2" "$3" "$4" "$5" "$6" "$7"
#
sleep 10
#
lftp -p "$port" -u "$username,$password" "$protocol://$hostname" <<-EOF
pget -c '~/.iperf3port' -o "/tmp"
quit
EOF
#
echo 'Generating iperf3 report...'
echo
iperf3 -p "$(cat "/tmp/.iperf3port")" -c "$hostname" -R | tee "$HOME/../help/reports/report-$hostname.txt"
#
echo
#
rm -f /tmp/.iperf3port
#
echo 'Generating MTR report...'
echo
mtr -r4 "$hostname" | tee -a "$HOME/../help/reports/report-$hostname.txt"
#
echo
echo 'This report has been saved to the help/reports directory.'
echo
read -ep "Are you ready to close the terminals?: " -i "y" quitme
#
if [[ "$quitme" =~ ^[Yy]$ ]]; then
	"/applications/kitty/kitty_portable.exe" -classname "iperf3" -sendcmd "\x03"
	"/applications/kitty/kitty_portable.exe" -classname "iperf3" -sendcmd "exit"
	exit
fi
#