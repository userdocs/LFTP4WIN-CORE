Sometimes, when `mirror-to-local` to a custom directory lftp gets confused and creates an empty `cygdrive` folder shortly after the download starts. This removed by the scripts just before exiting and you should just ignore it.

> [!attention|iconVisibility:hidden|labelVisibility:hidden|style:callout] Never us `rm` on just the `/cygdrive` as it will get interpreted as `/cygdrive/c` and try to wipe you C drive
