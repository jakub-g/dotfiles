#!/bin/bash

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

# Open Firefox from shell.
test -f "/c/Program Files (x86)/Mozilla Firefox/firefox.exe" && alias firefox='/c/Program\ Files\ \(x86\)/Mozilla\ Firefox/firefox.exe'
test -f "/c/Program Files/Mozilla Firefox/firefox.exe"       && alias firefox='/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
alias fx='firefox'

# Open IE from shell
alias iexplore='/c/Program\ Files/Internet\ Explorer/iexplore.exe'
alias ie='iexplore'

# Open Chrome from shell.
# Note that $USERPROFILE expands to C:\..., not /c/...; inner quote is needed due to whitespaces
alias chrome="'$USERPROFILE\Local Settings\Application Data\Google\Chrome\Application\chrome.exe'"
