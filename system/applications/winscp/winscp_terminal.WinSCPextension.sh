# @name Terminal
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" "!S" "!/" "!\" "%CDLOCAL%"
# @side Local
# @flag
# @description Start a terminal session in the home directory. Default is MinTTy. You can select ConEMU from the custom command preferences.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -config checkbox "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title ""%TITLE%"" -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -title LFTP4WIN -run {Bash::bash} -new_console:t:""%TITLE%""" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title ""%TITLE%"" -e /bin/bash -li"
#
# @option - -config group "Convenience Settings"
#
# @option CDLOCAL -run -config checkbox "Automatically CD to local directory" "no" "yes" "no"
#
# @option TITLE -run textbox "Windows title!" "!\"
#
winscp_to_bash "${@}"
#
[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"
#
[[ -n "${7}" && "${7}" = 'yes' ]] && cd "${local_dir}"
#
export set CHERE_INVOKING=1
#
bash -li
