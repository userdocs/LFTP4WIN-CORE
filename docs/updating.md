With the release of version `2.0` there is a file called `LFTP4WIN-import.cmd` in the top level of the solution. When you run this file it will ask you to select another LFTP4WIN (2.0 or newer) directory that you want to import your settings from.

It will import these files and settings:

- Home folder - This is your bash home directory when you use `~` or `$HOME`
- Keyfiles
- Downloads
- notifications
- `lftp-conf-override.sh` script file
- `lftpsync-config.sh` script file
- WinSCP settings
- Kitty settings

Windows task scheduler jobs are not changed. As long as the new LFTP4WIN folder replaces the old one after the import is complete your scheduled task will continue to work.

The WinSCP custom commands are loaded as WinSCP extension files and are independent from the main `WinSCP.ini` file. Extensions are loaded from the `system/applications/winscp` directory and have the name format of `winscp-command-name.WinSCPextension` and they are automatically loaded into WinSCP when it starts. You can add your own in the same way.

> [!tip|iconVisibility:hidden|labelVisibility:hidden|style:callout] Extensions can have the extension of the language they use. So `winscp-command-name.WinSCPextension` can be `winscp-command-name.WinSCPextension.sh` if it is a bash script

**ConEmu:** This program automatically checks for updates when running. It will prompt you.

**WinSCP:** You update this by downloading the portable binaries from the WinSCP website and placing the `WinSCP.exe` and `WinSCP.com` file in the `system/applications/winscp` directory.

**Kitty and Pageant:** You update these by downloading new release and replacing the files in the `system/applications/kitty` directory.

**Cygwin:** Use the `LFTP4WIN-update.cmd` file to update Cygwin.
