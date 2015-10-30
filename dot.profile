#!/bin/bash

############## README ##############
#
# 1. This file has to be sourced in '.profile'.
# 2. Perhaps you'll have to convert EOL to UNIX (\n), otherwise it may not work.
#
####################################

export HISTSIZE=4000 HISTFILESIZE=4000
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND='history -a'

source ~/unix-portable.profile
source ~/unix-only.profile
source ~/unix-only-mingw.profile
source ~/win-mingw.profile
source ~/git.profile
source ~/github.profile
source ~/ariatemplates.profile
source ~/util.profile
source ~/js.profile
source ~/java.profile

# pull dot profile files from ~ to cwd
alias dotpull='cp ~/*.profile .'

# push dot profile files from cwd to ~
alias dotpush='cp ./*.profile ~'
