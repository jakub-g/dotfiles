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

# extended, case-insensitive grep
alias iegrep='grep -iE'

# up one directory
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias upppp='cd ../../../..'

alias cdup='cd ..'
alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'
alias cd....='cd ../../../..'

# serve current directory on localhost:88 using Python 2/3
alias serve='python -m SimpleHTTPServer 88'
alias serve2='python -m SimpleHTTPServer 88'
alias serve3='python -m http.server 88'

# find files, excluding .git, node_modules etc
findmine() {
  find . -not \( -path './.git' -prune \) -not \( -path './node_modules' -prune \) -not \( -path './*/node_modules' -prune \) -not \( -path './*/dist' -prune \)  -not \( -path './*/lib' -prune \) -type f "$@"
}

# list all files from dir and subdirs, sort by filesize
alias filesBySize='find . -type f -exec ls -s {} \; | sort -n -r'

# display number of files in current directory, recursively
alias countFiles='find . -type f -print | wc -l'

# exit the console
alias xx='exit'
