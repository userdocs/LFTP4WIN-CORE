# Post processing script extensions (experimental)

These scripts will trigger after a download is completed and run whatever commands you have created for post processing.

For example, if you do this in the `lftpsync.sh` extension:

~~~
# lftpsync post processing extension
#
find "$local_dir" -name '*.zip' -o -name '*.7z' -execdir bsdtar -xmf '{}' ';'
find "$local_dir" -name '*.zip' -o -name '*.7z' -execdir rm -f '{}' ';'
#
unrarall --full-path --clean=rar "$local_dir"
~~~

It will search the entire local directory and unzip all zips then delete them. Then it will use the `unrarall` script to unrar any rar files and then delete them.

Or if you do this in the `mirror-to-local.sh` extension:

~~~
# mirror-to-local post processing extension
#
find "$local_dir${remote_dir##*/}/" -name '*.zip' -o -name '*.7z' -execdir bsdtar -xmf '{}' ';'
find "$local_dir${remote_dir##*/}/" -name '*.zip' -o -name '*.7z' -execdir rm -f '{}' ';'
#
unrarall --full-path --clean=rar "$local_dir${remote_dir##*/}/"
~~~

It will only search the folders you selected to mirror and unzip all zips then delete them. Then it will use the `unrarall` script to unrar any rar files and then delete them.

Or if you do this in the `pget-to-local.sh` extension:

~~~
# pget-to-local post processing extension
#
filename="$(echo ${remote_dir##*/} | sed 's/\.[^.]*$//')"
#
find "$local_dir" -name "$filename.zip" -o -name "$filename.7z" -execdir bsdtar -xmf '{}' ';'
find "$local_dir" -name "$filename.zip" -o -name "$filename.7z" -execdir rm -f '{}' ';'
#
find "$local_dir" -name "$filename.rar" -execdir unrar -idq -y x '{}' ';'
find "$local_dir" -name "$filename.rar" -execdir rm -f '{}' ';'
~~~

It will only extract the selected files if they are `zip` or `7z` or `rar` and then delete them.


You are going to have to trial and error your way through additional post processing. This should be a good starting point.
