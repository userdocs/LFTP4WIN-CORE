# Options should be set or modified in the /etc/lftp.conf and applied globally if not editable here.
#
# Here you can customize some settings for the mirror command that will override the lftp.conf defaults.
#
# This is where you can set the command switches for the mirror command.
mirror_args='-c'
# Optional - The number of parallel files to download with the mirror command. 
# If this variable is empty or 0 the lftp.conf settings will be used instead.
mirror_parallel_transfer_count='0'
# Optional - Set the number of connections per file lftp can open when using the mirror command.
# If this variable is empty or 0 the lftp.conf settings will be used instead.
mirror_use_pget_n='0'
#
# Here you can customize some settings for the pget command that will override the lftp.conf defaults.
#
# This is where you can set the command switches for the pget command.
pget_args='-c'
# Optional - Set the number of connections per file lftp can open when using the pget command.
# If this variable is empty or 0 the lftp.conf settings will be used instead.
pget_default_n='0'
#