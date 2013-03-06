#!/bin/bash

############## README ##############
#
# 1. This file has to be renamed to '.profile'. I've renamed it to dot.profile
#    so it's not hidden by 'ls' by default.
# 2. Perhaps you'll have to convert EOL to UNIX (\n), otherwise it may not work.
#
####################################

source ~/unix.profile
source ~/unix-mingw.profile
source ~/win-mingw.profile
source ~/git.profile
source ~/ariatemplates.profile

# pull dot profile files from ~ to cwd
alias dotpull='cp ~/*.profile .'

# push dot profile files from cwd to ~
alias dotpush='cp ./*.profile ~'
