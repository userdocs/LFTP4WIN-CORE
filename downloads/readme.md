# Help files - how to use.

`remove usb.cmd` - Run this to close the main apps included. This is what the file contains.

~~~
taskkill /f /im "ssh-pageant.exe"
taskkill /f /im "kageant.exe"
taskkill /f /im "WinSCP.exe"
taskkill /f /im "bash.exe"
taskkill /f /im "ConEmu64.exe"
taskkill /f /im "notepad++.exe"
taskkill /f /im "kitty_portable.exe"
taskkill /f /im "ssh.exe"
taskkill /f /im "lftp.exe"
taskkill /f /im "curl.exe"
~~~

`start notepad++.cmd` - Will load the included notepad ++ and some important files.

*Use these troubleshooting files with caution! They are not to be used casually.*

With  `LFTP4WIN` these files should no longer be needed but I'll leave them here just in case.

`troubleshooting - ownership - recycle bin.cmd` - Use only if you deleted transferred files that corrupted the recycle bin.

`troubleshooting - ownership.cmd` - Use only if you are have file ownership issues with transferred files.