## Important Note - You need to generate these settings using the WinSCP custom command lftpsync setup.
#
username=''
#
password=''
#
hostname=''
#
port=''
#
protocol=''
#
remote_dir=''
#
local_dir=''
# If these variables are empty or 0 the lftp.conf settings will be used instead.
mirror_parallel_transfer_count='0'
#
mirror_use_pget_n='0'
# This variable will set the command switches the lftp command in this script uses.
mirror_args='-c'