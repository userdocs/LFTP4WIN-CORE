There is a help folder with some tools to edit scripts,files and fix permissions.

`remove usb.cmd` - Run this to close the main apps included. This is what the file contains.

```cmd
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
```

`start notepad++.cmd` - Will load the included notepad ++ and some important files.

`start - vscode.cmd` - If you have installed VSCode using the [`install_vscode`](functions?id=install_vscode) function it will load VSCode.

> [!warning|iconVisibility:hidden|labelVisibility:hidden|style:callout] Use these troubleshooting files with caution! They are not to be used casually

From version `2.0` these files should no longer be needed but there are still Cygwin issues with moving the from one computer to another for files outside the `$HOME` directory and this file will fix that.

`troubleshooting - ownership.cmd` - Use only if you are have file ownership issues with transferred files or when moving the portable installation between devices.

> [!attention|iconVisibility:hidden|labelVisibility:hidden|style:callout] Use this troubleshooting file with caution! It should not be needed or used casually

`troubleshooting - ownership - recycle bin.cmd` - Use only if you deleted transferred files that corrupted the recycle bin.
