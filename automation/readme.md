**Critical note:** Passwords Golden Rules!

**1:** Do not use double quotes `"` or things will break.

**2:** Make sure the password does not end with a `\` or things will break.

**3:** Single quotes can be used and are escaped.

*Note: Values 1-10 are automatically populated by the WinSCP custom command `lftpsync-setup` once you have successfully connected to a server with WinSCP. Enter, not select, the local and remote directories you want to sync then use the command.*

**Step 1:** Connect to your server using WinSCP and use the custom command `lftpsync-setup`. It can automatically fill these settings. Running this command again will regenerate all script settings and the scheduled task settings based on the settings of the current command. The reset box resets the script and deletes the scheduled task.

`1` - The connection username.

`2` - The connection password - if not using a key file, otherwise you can leave it blank.

`3` - The server hostname.

`4` - Your connection port.

`5` - Your protocol type `sftp` or `ftp` using ssl/tls.

`6` - The remote directory you want to mirror.

`7` - Your local directory for downloaded files. If empty the default`/Download` location is used.

`8` - Optional `mirror_parallel_transfer_count` settings you want the script to use. `lftp.conf` is used if this is blank or `0`.

`9`- Optional `mirror_use_pget_n`settings you want the script to use. `lftp.conf` is used if this is blank.

`10` - Optional `mirror_args` settings you want the script to use. `-c` is the default switch used.

**Step 2:** Optional - You can use the `1 - Optional - lftpsync settings tester.cmd` to run the script in ConEmu to test your connection settings. ConEmu will not run minimized or close upon completion.

**Step 3:** Optional - You can use `2 - Optional - lftpsync settings debugging.cmd` to perform the same test as option 1 but with debug enabled and set to level 10.

**Step 4:** Optional - You can use the `3 - Optional - test lftpsync task.cmd` to run the task now and check it works as intended.

**Step 5:** Optional - You can use `4 - Optional - start taskscheduler.cmd` to tweak the ltfpsync task settings in the task scheduler.

**Step 6:** Optional - You can use the `5 - Optional - delete lftpsync task.cmd` delete lftpsync task from the task scheduler.

**Step 7:** Optional - You can use the `6 - Optional - edit lftp options.cmd` to edit the `lftp.conf` if you need to use some specific settings. If you set the connections settings in the custom command they will override the matching `lftp.conf` settings unless they were set to `0` or left blank.

Congratulations, you are now using lftp on Windows automated via Windows Task Scheduler.

Set it and forget it.