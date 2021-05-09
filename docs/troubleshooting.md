Here you will find some useful troubleshooting hints.

## WinSCP

You have updated WinSCP and lost the custom commands?

# Troubleshooting info

Occasionally a new version of WinSCP resets the layout. Then all you need to do is right click somewhere on the top section of WinSCP to access the toolbar context menu and enable custom commands. They will show again.

## Kitty

Here is the integration command used in case it gets lost or changed.

```cmd
"%WINSCP_PATH%\..\kitty\kitty_portable.exe" -pw "!P" "!U@!@" -P "!#" -title "!N" -classname "lftp4win" -cmd "cd '!/'"
```

## lftp

You can enable debugging in the `lftp.conf` by removing the comment `#` before the `# debug 10 -o "~/lftp-debug.log"` at the top of the file. This log is saved to the home folder in the main folder.

You access the `lftp.conf` by using one of these methods:

Using the WinSCP custom command `open-lftp-conf` for loading this file into notepad++

By using the `6 - Optional - edit lftp options.cmd` in the automation folder.

By using the `start - notepad ++.cmd` in the help folder.

## lftp automation

You are having trouble connecting with the `lftpsync.sh` script?

Use the debugging option and it should provide useful information to help.
