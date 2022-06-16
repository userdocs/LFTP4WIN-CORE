#!/usr/bin/env bash
#
# bash <(curl -4sL https://git.io/fjRIi)
#
mkdir -p ~/bin && source ~/.bashrc
#
if [[ $(echo "$PATH" | grep -oc "$HOME/bin") -eq "0" && $(cat ~/.bashrc | grep -oc 'export PATH="$HOME/bin${PATH:+:${PATH}}"') -eq "0" ]]; then
	export PATH="$HOME/bin:$PATH${PATH:+:${PATH}}"
fi
#
if [[ $(echo "$LD_LIBRARY_PATH" | grep -oc "$HOME/lib") -eq "0" && $(cat ~/.bashrc | grep -oc 'export LD_LIBRARY_PATH="$HOME/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"') -eq "0" ]]; then
	export LD_LIBRARY_PATH="$HOME/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
fi
#
wget -q4O ~/bin/iperf3 "https://github.com/userdocs/iperf3-static/releases/latest/download/iperf3-${REMOTE_ARCH}" && chmod 700 ~/bin/iperf3
#
if [[ -z "$IPERF3PORT" ]]; then
	IPERF3PORT="$(shuf -i 10001-32001 -n 1)" && while [[ "$(ss -ln | grep -co ''"$IPERF3PORT"'')" -ge "1" ]]; do IPERF3PORT="$(shuf -i 10001-32001 -n 1)"; done
	echo -n "$IPERF3PORT" > ~/.iperf3port
else
	echo -n "$IPERF3PORT" > ~/.iperf3port
fi
#
echo
echo 'Connect with your client using these commands:'
echo
echo 'iperf3 -p '"$IPERF3PORT"' -c '"$(curl -4s icanhazip.com)"''
echo 'iperf3 -p '"$IPERF3PORT"' -c '"$(curl -4s icanhazip.com)"' -R'
echo 'iperf3 -p '"$IPERF3PORT"' -c '"$(curl -4s icanhazip.com)"' -R -P 10'
echo 'iperf3 -p '"$IPERF3PORT"' -c '"$(curl -4s icanhazip.com)"' -R -u'
echo 'iperf3 -p '"$IPERF3PORT"' -c '"$(curl -4s icanhazip.com)"' -R -P 10 -u'
echo
#
iperf3 -p $IPERF3PORT -s
