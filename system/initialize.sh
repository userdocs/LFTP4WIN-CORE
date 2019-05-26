#!/usr/bin/env bash
#
mkgroup -c > /etc/group
echo "$USERNAME:*:1001:$(mkpasswd -c | cut -d':' -f 4):$(mkpasswd -c | cut -d':' -f 5):$HOME:/bin/bash" > /etc/passwd
#
if [[ ! -f /.initialize-done && -f /.core-installed ]]; then
    ln -fsn '../usr/share/terminfo' '/lib/terminfo'
    touch /.initialize-done
fi