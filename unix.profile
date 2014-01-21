#!/bin/bash

# ======================================================
# various standard linux commands
# ======================================================

# list files in current dir
alias l='ls'

# list files in current dir, one file per line, long output
alias ll='ls -l'

# clear screen
alias cls='clear'

# serve current directory on localhost:88 using Python 2/3
alias serve='python -m SimpleHTTPServer 88'
alias serve2='python -m SimpleHTTPServer 88'
alias serve3='python -m http.server 88'

# list all files from dir and subdirs, sort by filesize
alias filesBySize='find . -type f -exec ls -s {} \; | sort -n -r'

# exit the console
alias xx='exit'
