# @name lftp
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" !`bash -c 'base64 -w 0 <<< "!S"'` "!/" "!\"
# @side Local
# @flag
# @description Connect to the remote server using LFTP
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -run -config dropdownlist "Select your terminal" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN_LFTP -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash} -new_console:t:LFTP4WIN_LFTP"=conemu """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title LFTP4WIN_LFTP -e /bin/bash -li"=mintty "wt -w 0 nt --title LFTP4WIN_LFTP ""%WINSCP_PATH%\..\..\bin\bash.exe"" -li"=windows_terminal
#
winscp_to_bash "${@}"
#
[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"
#
cd "${local_dir}" || exit 1
#
lftp -p "${port}" -u "${username},${password}" "${protocol}://${hostname}" -e "cd \"${remote_dir}\"; cls -1aB"
