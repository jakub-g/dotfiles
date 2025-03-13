#!/bin/bash

############## README ##############
#
#  This file has to be sourced in '.zshrc'
#
####################################

export GIT_PS1_SHOWDIRTYSTATE=false # unstaged (*) - staged (+)
export GIT_PS1_SHOWSTASHSTATE=false # stashed ($)
export GIT_PS1_SHOWUNTRACKEDFILES=false # untracked (%)
# - auto: Show Ahead (<), Behind (>), Diverged (<>), No Difference (=)
# - verbose: Show number of commits ahead/behind (+/-) upstream (i.e. u+1, u-1, u=)
# - name if verbose, then also show the upstream abbrev name
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_DESCRIBE_STYLE="default"
export GIT_PS1_SHOWCOLORHINTS="true"

source ~/dotfiles/unix-portable.profile
source ~/dotfiles/unix-only.profile
source ~/dotfiles/unix-only-mingw.profile
source ~/dotfiles/git.profile
source ~/dotfiles/js.profile
source ~/dotfiles/quarantine.profile

alias dot='cd ~/dotfiles'

# pull dot profile files from ~ to cwd
alias dotpull='cp ~/*.profile .'

# push dot profile files from cwd to ~
alias dotpush='cp ./*.profile ~'

alias dotdot='dot;dotpush;reload;cd -'
