By default lftp settings are managed in the `lftp.conf` which can be accessed by these recommended methods:

**1:** Using the WinSCP custom command `open-lftp-conf`

**2:** Using the `start - notepad ++.cmd` file in the `help` directory.

You should manage your settings here unless you want to have different settings for mirror and pget commands. In order to different settings for each command you can set the variables using the WinSCP custom command `lftp-conf-override`.
