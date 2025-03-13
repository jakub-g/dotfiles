#!/bin/bash

# ======================================================
# various standard linux commands
# ======================================================

# list files in current dir
alias l='ll'

# list all files in current dir, one file per line, long output, colored
alias ll='ls -l --color'
# ...and include dotfiles
alias lla='ls -la --color'
# ...and human-friendly block sizes
alias llh='ll --block-size=M'
alias llah='lla --block-size=M'

# count numbers of lines in a file
alias wcl='wc -l'

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

# List files in a .tar.gz file (-t list -v verbose -z gzip -f filename)
alias tar_preview='tar tvzf'

# serve current directory on localhost:88 using Python 2/3
alias serve='python -m SimpleHTTPServer 88'
alias serve2='python -m SimpleHTTPServer 88'
alias serve3='python -m http.server 88'

# find files, excluding all dot-folders, .git, node_modules, dist, lib folders
findmine() {
  find . -not \( -path '*/\.*' -prune \) -not \( -path './.git' -prune \) -not \( -path './node_modules' -prune \) -not \( -path './*/node_modules' -prune \) -not \( -path './*/dist' -prune \)  -not \( -path './*/lib' -prune \) -type f "$@"
}

# list all files from dir and subdirs, sort by filesize
alias filesBySize='find . -type f -exec ls -s {} \; | sort -n -r'

# display number of files in current directory, recursively
alias countFiles='find . -type f -print | wc -l'

# exit the console
alias xx='exit'

# Simple pagination of long output
# Usage:
#  something | p 1    // something | head -10
#  something | p 2    // something | head -20 | tail -10
#  something | p 3    // something | head -30 | tail -10
p() {
  if [[ "$1" == "" ]]; then
    head -10
  elif [[ "$1" == "1" ]]; then
    head -10
  else
    HEAD=$(($1 * 10))
    head "-${HEAD}" | tail -10
  fi
}

alias h10='head -10'
alias h20='head -20'
alias h30='head -30'
alias h40='head -40'
alias h50='head -50'
