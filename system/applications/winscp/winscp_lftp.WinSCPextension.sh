# @name lftp
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/" "!\"
# @side Local
# @flag
# @description Connect to the remote server using LFTP
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -config checkbox "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash}" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN -e /bin/bash -li"
#
winscp_to_bash "${@}"
#
[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"
#
cd "${local_dir}"
#
lftp -p "${port}" -u "${username},${password}" "${protocol}://${hostname}" -e "cd \"${remote_dir}\"; cls -1aB"
