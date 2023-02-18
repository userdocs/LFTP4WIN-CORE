# @name Terminal_quick
# @command cmd /c start "" %TERMINAL% "%EXTENSION_PATH%" "!\" "%CDLOCAL%"
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
[[ -n "${2}" && "${2}" = 'yes' ]] && { cd "${1}" || exit 1; }

export set CHERE_INVOKING=1

exec "${SHELL}"
