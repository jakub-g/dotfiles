#!/bin/bash

# Open Notepad++ from MINGW!
# Usage:
#  np foo.txt
alias np='/c/Program\ Files/Notepad++/notepad++.exe'
alias n++='np'

# Open Firefox from shell
alias firefox='/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
alias fx='firefox'

# Open IE from shell
alias iexplore='/c/Program\ Files/Internet\ Explorer/iexplore.exe'
alias ie='iexplore'

# Open Chrome from shell.
# Note that $USERPROFILE expands to C:\..., not /c/...; inner quote is needed due to whitespaces
alias chrome="'$USERPROFILE\Local Settings\Application Data\Google\Chrome\Application\chrome.exe'"
