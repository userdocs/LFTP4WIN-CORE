Here is a brief description of scripts included.

> [!tip|iconVisibility:hidden|labelVisibility:hidden|style:callout] The `lftpsync.sh`, `lftp-winscp-mirror` and `lftp-winscp-pget` use the same hard coded lock file `lftp-winscp.lock` so as not to run another download in parallel while any other download are in progress. They will all check to see if lftp is actually running and clear dead lock files.

`functions.sh` - The heart of the solution. It contains functions used across most scripts to process information passed by WinSCP.

`lftpsync.sh` - A mirror script for use with ConEmu or as a scheduled task. The original idea of this project.

`lftpsync-config.sh` - The settings file for the `lftpsync.sh` script.

`lftp-winscp-mirror.sh` - A heavily modified clone of the `lftpsync.sh` to be used and modified specifically with WinSCP for mirroring remote directories to a local directory.

`lftp-winscp-pget.sh` - A heavily modified clone of the `lftpsync.sh` changed to use `pget` instead of mirror to be used and modified specifically with WinSCP for downloading a single file to a local directory.

`lftp-conf-override.sh` - A script accessed by the custom command `lftp-conf-override` to change or reset the main variables used for the `lftp-winscp-mirror.sh`, `lftp-winscp-pget.sh`.

`install.iperf.sh` - A local copy of the remote installation script used by the `iperf3` command. This script is not used locally and can be ignored.

`lftpsync.cmd` - This is file the the Windows Task Scheduler uses to process the `lftpsync.sh` task.
