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
export MAVEN_OPTS=-Xmx1024m

export GIT_PS1_SHOWDIRTYSTATE=true # unstaged (*) - staged (+)
export GIT_PS1_SHOWSTASHSTATE=true # stashed ($)
export GIT_PS1_SHOWUNTRACKEDFILES=true # untracked (%)
# - auto: Show Ahead (<), Behind (>), Diverged (<>), No Difference (=)
# - verbose: Show number of commits ahead/behind (+/-) upstream (i.e. u+1, u-1, u=)
# - name if verbose, then also show the upstream abbrev name
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_DESCRIBE_STYLE="default"
export GIT_PS1_SHOWCOLORHINTS="true"

# remove MSYSTEM from the prompt
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'\[\033[32m\]'       # change to green
PS1="$PS1"'\u@\h '             # user@host<space>
PS1="$PS1"'\[\033[35m\]'       # change to purple
#PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
  PS1="$PS1"'\[\033[36m\]'  # change color to cyan
  PS1="$PS1"'`__git_ps1`'   # bash function
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

source ~/unix-portable.profile
source ~/unix-only.profile
source ~/unix-only-mingw.profile
source ~/win-mingw.profile
source ~/git.profile
source ~/github.profile
source ~/bitbucket_fetchpr.profile
source ~/bitbucket_pullrequest.profile
source ~/ariatemplates.profile
source ~/util.profile
source ~/js.profile
source ~/java.profile
source ~/android.profile

# pull dot profile files from ~ to cwd
alias dotpull='cp ~/*.profile .'

# push dot profile files from cwd to ~
alias dotpush='cp ./*.profile ~'
