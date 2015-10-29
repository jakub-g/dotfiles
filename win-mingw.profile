#!/bin/bash

alias o='start .'

# Print clipboard contents
alias showclip='cat /dev/clipboard'
# Go to the folder specified in the clipboard
alias gotoclip='cd "$(cat /dev/clipboard)"'

# Open Notepad++ from MINGW!
# Usage:
#  np foo.txt
test -f "/c/Program Files (x86)/Notepad++/notepad++.exe" && alias np='/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe'
test -f "/c/Program Files/Notepad++/notepad++.exe"       && alias np='/c/Program\ Files/Notepad++/notepad++.exe'
alias n++='np'

# Open Sublime3
alias subl3='/c/Program\ Files/Sublime\ Text\ 3/sublime_text.exe'

# Open Firefox from shell.
test -f "/c/Program Files (x86)/Mozilla Firefox/firefox.exe" && alias firefox='/c/Program\ Files\ \(x86\)/Mozilla\ Firefox/firefox.exe'
test -f "/c/Program Files/Mozilla Firefox/firefox.exe"       && alias firefox='/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
alias fx='firefox'

# Open Chrome from shell (Windows 7).
# (deprecated) Note that $USERPROFILE expands to C:\..., not /c/...; inner quote is needed due to whitespaces
# (deprecated) alias chrome="'$USERPROFILE\Local Settings\Application Data\Google\Chrome\Application\chrome.exe'"
test -f "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" && alias chrome='/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'

# Open Chrome Canary from shell (Windows 7).
_chrome_canary="$USERPROFILE\AppData\Local\Google\Chrome SxS\Application\chrome.exe"
test -f "${_chrome_canary}" && alias chrome-canary='"${_chrome_canary}"'

# Open IE from shell
alias iexplore='/c/Program\ Files/Internet\ Explorer/iexplore.exe'
alias ie='iexplore'
