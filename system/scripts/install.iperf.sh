#!/usr/bin/env bash
#
# bash <(curl -4sL https://git.io/fjRIi)
#
mkdir -p ~/{bin,lib} && source ~/.bashrc
#
if [[ $(echo "$PATH" | grep -oc "$HOME/bin") -eq "0" && $(cat ~/.bashrc | grep -oc 'export PATH="$HOME/bin${PATH:+:${PATH}}"') -eq "0" ]]; then
	export PATH="$HOME/bin:$PATH${PATH:+:${PATH}}"
	echo 'export PATH="$HOME/bin${PATH:+:${PATH}}"' >> ~/.bashrc
fi
if [[ $(echo "$LD_LIBRARY_PATH" | grep -oc "$HOME/lib") -eq "0" && $(cat ~/.bashrc | grep -oc 'export LD_LIBRARY_PATH="$HOME/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"') -eq "0" ]]; then
	export LD_LIBRARY_PATH="$HOME/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
	echo 'export LD_LIBRARY_PATH="$HOME/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"' >> ~/.bashrc
fi
#
wget -q4O ~/bin/iperf3 https://iperf.fr/download/ubuntu/iperf3_3.1.3 && chmod +x ~/bin/iperf3
wget -q4O ~/lib/libiperf.so.0 https://iperf.fr/download/ubuntu/libiperf.so.0_3.1.3
#
while [[ "$(ss -ln | grep -co ''"$port"'')" -ge "1" ]]; do port="$(shuf -i 10001-32001 -n 1)"; done
echo -n "$port" > ~/.iperf3port
#
echo
echo 'Connect with your client using these commands:'
echo
echo 'iperf3 -p '"$port"' -c '"$(curl -4s icanhazip.com)"''
echo 'iperf3 -p '"$port"' -c '"$(curl -4s icanhazip.com)"' -R'
echo 'iperf3 -p '"$port"' -c '"$(curl -4s icanhazip.com)"' -R -P 10'
echo 'iperf3 -p '"$port"' -c '"$(curl -4s icanhazip.com)"' -R -u'
echo 'iperf3 -p '"$port"' -c '"$(curl -4s icanhazip.com)"' -R -P 10 -u'
echo
#
iperf3 -p $port -s