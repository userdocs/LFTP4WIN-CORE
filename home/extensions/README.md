# Post processing script extensions (experimental)

These scripts that will trigger after a download is completed and run whatever commands you have created for post processing.

For example, if you do this in the `mirror-to-local.sh` or `lftpsync.sh` extension:

~~~
# mirror-to-local post processing extension
#
find "$local_dir" -name '*.zip' -execdir bsdtar -xmf '{}' ';'
find "$local_dir" -name '*.zip' -execdir rm -f '{}' ';'
#
unrarall --full-path --clean=rar "$local_dir"
~~~

It will unzip all zips then delete them. Then it will use the `unrarall` script to unrar any rar files and then delete them.

You are going to have to trial and error your way through additional post processing.