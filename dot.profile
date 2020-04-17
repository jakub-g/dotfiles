#!/bin/bash

############## README ##############
#
# 1. This file has to be sourced in '.profile'.
# 2. Perhaps you'll have to convert EOL to UNIX (\n), otherwise it may not work.
#
####################################

export HISTSIZE=4000 HISTFILESIZE=4000
export HISTCONTROL=ignoredups:erasedups
#if [[ -n "${ConEmuPID}" ]]; then
  #PROMPT_COMMAND='ConEmuC -StoreCWD; history -a'
#fi
export PROMPT_COMMAND='history -a'
export MAVEN_OPTS=-Xmx1024m

export GIT_PS1_SHOWDIRTYSTATE=false # unstaged (*) - staged (+)
export GIT_PS1_SHOWSTASHSTATE=false # stashed ($)
export GIT_PS1_SHOWUNTRACKEDFILES=false # untracked (%)
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
  #PS1="$PS1"'`__git_ps1`'   # bash function
  # __git_ps1 is horribly slow, let's just display branch name without status
  BASIC_PS1='`            if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then'
  BASIC_PS1="$BASIC_PS1"'   printf " (";'
  BASIC_PS1="$BASIC_PS1"'   printf $(git rev-parse --abbrev-ref HEAD);'
  #slow as well...
  if false; then
      :
      #BASIC_PS1="$BASIC_PS1"'   date +%s;'
      BASIC_PS1="$BASIC_PS1"'   IFS="\t " read -r -a SPLIT_INPUT <<< $(git rev-list --left-right --count HEAD...$(git rev-parse --abbrev-ref --symbolic-full-name @{u}));'
      BASIC_PS1="$BASIC_PS1"'   echo "xx ${SPLIT_INPUT[0]} zz ${SPLIT_INPUT[1]} qq ${SPLIT_INPUT[2]} yy";'
      BASIC_PS1="$BASIC_PS1"'   if [ "${SPLIT_INPUT[0]}" == "0" ] && [ "${SPLIT_INPUT[1]}" == "0" ] ; then'
      BASIC_PS1="$BASIC_PS1"'     printf "=";'
      BASIC_PS1="$BASIC_PS1"'   elif [ "${SPLIT_INPUT[1]}" == "0" ]; then'
      BASIC_PS1="$BASIC_PS1"'     printf "+${SPLIT_INPUT[0]}";'
      BASIC_PS1="$BASIC_PS1"'   elif [ "${SPLIT_INPUT[0]}" == "0" ]; then'
      BASIC_PS1="$BASIC_PS1"'     printf "-${SPLIT_INPUT[1]}";'
      BASIC_PS1="$BASIC_PS1"'   else'
      BASIC_PS1="$BASIC_PS1"'     printf "+${SPLIT_INPUT[0]}-${SPLIT_INPUT[1]}";'
      BASIC_PS1="$BASIC_PS1"'   fi;'
      #BASIC_PS1="$BASIC_PS1"'   date +%s;'
  fi
  BASIC_PS1="$BASIC_PS1"'   printf ")";'
  BASIC_PS1="$BASIC_PS1"' fi`'
  PS1="$PS1""$BASIC_PS1"
  #; echo ${SPLIT_INPUT[0]}; echo ${SPLIT_INPUT[1]}
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

source ~/unix-portable.profile
source ~/unix-only.profile
source ~/unix-only-mingw.profile
source ~/win-mingw.profile
source ~/ssh-agent.profile
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

alias dotdot='dot;dotpush;reload;cd -'
