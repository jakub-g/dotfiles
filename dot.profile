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

# pull dot profile files from ~ to cwd
alias dotpull='cp ~/*.profile .'

# push dot profile files from cwd to ~
alias dotpush='cp ./*.profile ~'
