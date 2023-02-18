# @name Terminal
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!U" "!@" "!#" !`bash -c 'base64 -w 0 <<< "!S"'` "!/" "!\" "%CDLOCAL%"
# @side Local
# @flag
# @description Start a terminal session in the home directory. Default is MinTTy. You can select ConEMU from the custom command preferences.
# @author userdocs
# @version 1.0
# @homepage https://github.com/userdocs/LFTP4WIN-CORE
#
# @option - -config group "Terminal Settings"
#
# @option TERMINAL -run -config dropdownlist "Use ConEMU instead of MinTTY" """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title ""%TITLE%"" -e /bin/bash -li" """%WINSCP_PATH%\..\conemu\ConEmu64.exe"" -run {Bash::bash} -new_console:t:""%TITLE%"""=conemu """%WINSCP_PATH%\..\..\bin\mintty.exe"" --Title ""%TITLE%"" -e /bin/bash -li"=mintty "wt -w 0 nt --title ""%TITLE%"" ""%WINSCP_PATH%\..\..\bin\bash.exe"" -li"=windows_terminal
#
# @option - -config group "Convenience Settings"
#
# @option CDLOCAL -run -config checkbox "Automatically CD to local directory" "no" "yes" "no"
#
# @option TITLE -run textbox "Windows title!" "!\"
#
winscp_to_bash "${@}"

mapfile -t export_vars < <(winscp_variables)

[[ "${protocol:?}" == 'sftp' ]] && openssh_known_hosts "${port}" "${hostname}"

[[ -n "${7}" && "${7}" = 'yes' ]] && { cd "${local_dir}" || exit 1; }

export set CHERE_INVOKING=1

exec env "${export_vars[@]}" "${SHELL}"
