#!/bin/bash

# ======================================================
# various standard linux commands
# ======================================================

# list files in current dir
alias l='ll'

# list files in current dir, one file per line, long output
alias ll='ls -l --color'

# list all files in current dir, one file per line, long output
alias lla='ls -la --color'

# clear screen
alias cls='clear'

# cat in the reverse order
alias tac='perl -e "print reverse <>"'
alias rev='tac'
alias reverse='tac'

# up one directory
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias upppp='cd ../../../..'

alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'
alias cd....='cd ../../../..'

# serve current directory on localhost:88 using Python 2/3
alias serve='python -m SimpleHTTPServer 88'
alias serve2='python -m SimpleHTTPServer 88'
alias serve3='python -m http.server 88'

# list all files from dir and subdirs, sort by filesize
alias filesBySize='find . -type f -exec ls -s {} \; | sort -n -r'

# exit the console
alias xx='exit'
