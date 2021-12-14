#!/bin/bash

# Set git user config
alias ginitconfig="git config user.email 'jakub.g.opensource@gmail.com'; git config user.name 'jakub-g'"

# ======================================================
# autocompletion helpers
# ======================================================

# TAB-autocompletion for branch-based commands. Probably highly suboptimal, but works
_gitbranches()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    opts=`git branch -l | cut -c 3- | tr -s '[:space:]' '[ *]'`
    COMPREPLY=( $(compgen -W "${opts}" -- $cur) )
}

# Go up into top directory of a Git project.
alias gogit='cd "./"$(git rev-parse --show-cdup)' # if already in git dir,empty string is returned

# ======================================================
# diff
# ======================================================

alias gitkk='gitk &'

# Display diff code
alias gd='git diff'

# Display diff stats
alias gdmeta='git diff --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20 --pretty=fuller'

# Display staged diff code
alias gdc='git diff --cached'

# Display diff stats (one file per line)
alias gds='git diff --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20'

# Display diff, ignore whitespace
alias gdw='git diff -w'

# Display code diff of the tip in branch/tag/commit. Shows HEAD if parameterless.
alias gsh='git show'
complete -F _gitbranches gsh

# Display diff stats of the tip in branch/tag/commit. Shows HEAD if parameterless.
alias gshs='git show --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20'
complete -F _gitbranches gshs

# Same as gshs, but also shows committer (not only author)
alias gshmeta='git show --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20 --pretty=fuller'
alias gshm='gshmeta'
alias gm='gshmeta'

# Same as gshmeta but ignores EOL changes
alias gshmetamin='gshmeta --ignore-space-at-eol'

# Same as gsh + Instead of displaying full line deletions, displays colored inline changes.
alias gshmin='git show --color-words'

# Instead of displaying full line deletions, displays colored inline changes.
alias gdmin='git diff --color-words'

# Displays files changed in a particular commit.
# Usage:
#  findFilesChangedInCommit <commit-id>
#  findFilesChangedInCommit HEAD
alias findFilesChangedInCommit='git diff-tree -r --name-only --no-commit-id'
complete -F _gitbranches findFilesChangedInCommit

# Displays ".orig" files in a current folder and subfolders
alias find-orig-files='findmine | grep -iE .orig$'
alias findorig='find-orig-files'
alias origfind='find-orig-files'

# Deletes ".orig" files in a current folder and subfolders
alias find-orig-files-and-remove='find-orig-files | xargs -I % sh -c "echo %; rm %"'
alias rmorig='find-orig-files-and-remove'
alias origrm='find-orig-files-and-remove'

# Displays particular file contents at particular revision
gshFileAtRevision() {
  local FILE="$1"
  local REVISION="$2"
  git show "${REVISION}":"${FILE}"
}

# ======================================================
# status
# ======================================================

# Show current situation in the branch
alias gs='git status'

# Show current situation in the branch (short version)
alias gss='git status -s'

# ======================================================
# log
# ======================================================

# Display flat log. h/his like history.
# Usage: gh (use ghm for more items)
alias ghis='ghm | cat' # it displays in less even if is short enough, thus cat
# Display flat short log.
# Usage:
#  gh
#  ghm -50
alias gh='ghm -10'
alias ghm='git --no-pager log --format="%C(yellow)%h%Creset %C(cyan)%cd%Creset %s %Cgreen%an%Creset" --date=format-local:"%F %R"'
#alias ghm='git --no-pager log --format="%C(yellow)%h%Creset %C(cyan)%cd%Creset %s %Cgreen%an%Creset" --date=short'

# Like gh, if you want to display full commit message
# Usage:
#  ghx
#  ghxm -50
alias ghx='ghxm -20'
alias ghxm='git --no-pager log --format="%C(cyan)%cd%Creset %C(yellow)%h%Creset %s %Cgreen%an%Creset %n%C(black bold)%b%Creset" --date=short'

# Various non-flat log versions
alias gl='ghm -10'
alias gl2='ghm -20'
alias gl3='ghm -30'
alias gl4='ghm -40'
alias gl5='ghm -50'

alias glog='git log -10'
alias glog1="git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative"
alias glog2="git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(bold white)- %an%C(reset)' --abbrev-commit"
alias glog3="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# List all file extensions that can be found in a git repo
# alias gextensions='git ls-tree -r HEAD --name-only | sed -rn "s|.*\.([^\.]+)$|\1|p" | sort | uniq'
# note the escape before $1
alias gextensions='git ls-tree -r HEAD --name-only | perl -ne "print \$1 if m/\.([^.\/]+)$/" | sort -u'

# ======================================================
# branches - displaying
# ======================================================

# Display recent local branches and last commit date (sorted by last commit date)
alias gb_min='git for-each-ref --sort=-committerdate --format="%(committerdate:short) %(refname:short)" refs/heads/'

# Display recent local branches and last commit date (sorted by last commit date). Additionally, display last commit message
alias gb='git for-each-ref --sort=-committerdate --format="%(committerdate:short) %(refname:short) %(color:cyan) %(contents:subject)" refs/heads/'

# Display recent local branches - only a few of them (10 by default)
alias gbh='gb | head'

# gb count
alias gbc='gb | wc -l'

# Display recent local branches - short (only names) (sorted by last commit date)
alias gbs='git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads/'

# Display just the name of the current branch
alias gcurrbranch='git rev-parse --abbrev-ref HEAD'

# Display just the name of the branch that the current branch is tracking
alias gcurrbranch-trackingbranch='git rev-parse --abbrev-ref --symbolic-full-name @{u}'

# Displays the +/- diff to the tracking branch
alias git-diff-to-tracking-branch='git rev-list --left-right --count HEAD...$(gcurrbranch-trackingbranch)'
alias gtracking='git-diff-to-tracking-branch'
# git rev-list --left-right --count HEAD...$(git rev-parse --abbrev-ref --symbolic-full-name @{u})

# Display just the name of the last branch committed to
alias gblast='git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads/ | head -1'

# Display the name of the newest tag
alias gtaglast='git describe --abbrev=0'

# Checkout the last branch committed to
alias gotolast='goto $(gblast)'

# Display local branches (default sorting by name)
alias gbr='git branch'

# Display local and remote branches
alias gbra='git branch -a'

# Checks if a local branch exists. Returns 0 or 1 exit code
# Usage:
#  gbrexists master
gbrexists() {
  git show-ref --verify --quiet "refs/heads/$1"
}
# Checks if a remote branch exists. Returns 0 or 1 exit code
# Usage:
#  gbrexistsRemote "origin/master"
gbrexistsRemote() {
  git show-ref --verify --quiet "refs/remotes/$1"
}

# ======================================================
# branches - switching
# ======================================================

# Check out the branch.
alias gitco='git checkout'
complete -F _gitbranches gitco

# Usage:
#  goto iss234
alias goto='git checkout'
complete -F _gitbranches goto

# Create a new branch out of current branch.
# Usage:
#  forkto iss234
alias forkto='git checkout -b'
complete -F _gitbranches forkto

# Rename current branch.
# Usage:
#  moveto iss234
alias moveto='git branch -m'
complete -F _gitbranches moveto

# Rename a branch
# Usage:
#  rename oldname newname
alias rename='git branch -m'
complete -F _gitbranches rename

# Master is checked out so frequently it deserves its own command.
alias master='git checkout master'
alias m='master'
#alias dev='git checkout dev'

# ======================================================
# updating - from upstream
# ======================================================

alias gup='git fetch upstream && git rebase upstream/master $(gcurrbranch)'
# Use gupc in favor of gsync when you're in gh-pages etc.
alias gupc='git fetch upstream && git rebase upstream/$(gcurrbranch) $(gcurrbranch)'
alias gupf='git stash && gup && git stash pop'
alias guptag='git fetch --tags upstream'       # tags are not downloaded by default

# ======================================================
# updating - from origin (syncing)
# ======================================================

alias gf='git fetch'
alias gfd='git fetch origin dev'
alias gfm='git fetch origin master'
alias gfu='git fetch upstream'

# Sync current branch, `master` and `dev` with origin
gsync() {
  local CURR_BRANCH=$(gcurrbranch)
  git fetch origin

  # rebase current local branch on top of origin tracking branch
  # edit: this does not make sense, if we are on feature branch and want to push --force!
  #if (gbrexistsRemote "origin/${CURR_BRANCH}") ; then
  #  echo -e '\nSyncing current branch with origin...'
  #  git rebase origin/${CURR_BRANCH} ${CURR_BRANCH}
  #fi

  # additionally, rebase local master on top of origin master, if applicable
  echo -e '\nSyncing master...'
  if (gbrexistsRemote "origin/releases/master" && gbrexists "master") ; then
    git rebase origin/releases/master master
  elif (gbrexistsRemote "origin/master" && gbrexists "master") ; then
    git rebase origin/master master
  fi

  # additionally, rebase local dev on top of origin dev, if applicable
  echo -e '\nSyncing dev...'
  if (gbrexistsRemote "origin/releases/dev" && gbrexists "dev") ; then
    git rebase origin/releases/dev dev
  elif (gbrexistsRemote "origin/dev" && gbrexists "dev") ; then
    git rebase origin/dev dev
  fi

  echo -e '\nComing back to original branch...'
  git checkout ${CURR_BRANCH}
}

# Rebase on top of master, dev
alias gremaster='git rebase master'

alias remaster='git rebase origin/master'
alias redev='git rebase origin/dev'

alias gsync-master='gsync && echo -e "\nRebasing on top of " && remaster'
alias gsync-dev='gsync && echo -e "\nRebasing on top of dev" &&  redev'

# Use gsyncc in favor of gsync when you're in gh-pages etc.
alias gsyncc='git fetch origin && git rebase origin/$(gcurrbranch) $(gcurrbranch)'
alias gsyncf='git stash && gsync && git stash pop'
alias gsynctag='git fetch --tags origin'

# Usage:
#  git-sync-remote <remote-name>
# Example:
#  git-sync-remote alice
git-sync-remote(){
  REMOTE_NAME="$1"
  if [ -z "${REMOTE_NAME}" ] ; then
    echo 'You need to provide remote name'
    return
  fi
  git branch -ar | sed 's|^[ \t]*||' | grep -e "^${REMOTE_NAME}/" | sed "s|${REMOTE_NAME}/||" | xargs git fetch "${REMOTE_NAME}"
}

alias gbd='git branch -d'
complete -F _gitbranches gbd

alias gbD='git branch -D'
complete -F _gitbranches gbD

git-delete-merged-branches-local(){
  git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d
}

git-delete-merged-branches-remote(){
  git branch -r --merged | grep -v master | grep origin | sed 's/origin\///' | xargs -n 1 git push --delete origin --no-verify
}

# ======================================================
# staging / unstaging
# ======================================================

# 'git add all' but only already tracked (update)
alias ga='git add -u .'

# 'git add absolutely all', even untracked and deleted
alias gaaa='git add -A .'
alias gaa='gaaa'

# Unstage the file added to index.
#  Usage: gunstage foo.txt
alias gunstage='git reset HEAD'

# Get rid of the last commit.
alias gdrop='git reset --hard HEAD^'

# Discard current, uncommitted changes
alias gdiscard='git reset --hard HEAD'

# ======================================================
# committing
# ======================================================

# "Work in progress" commit: add everything and commit with "WIP" commit message
alias wip='gcm WIP'
alias wipnv='wip --no-verify'

alias wipaa='gaaa; wip'
alias wipaanv='gaaa; wipnv'

alias gc='git commit'
alias gca='git commit -a'

# Commit with inline commit message.
#  Usage: gcam "Commit message"
alias gcm='git commit -m'           # Like above

# Commit with inline commit message, including not staged files.
#  Usage like 'gcm'. Don't confuse with commit --amend
alias gcam='git commit -a -m'

# Quick amend, without changing commit message
alias gamend='git commit --amend --no-edit'

# Amend the last commit, squashing all local changes into it.
alias gamendall='gaaa && gamend'

# Amend the last commit: set date to current date
alias gamenddate='git commit --amend --date="$(date -R)"'

# Amend the last commit - e.g. fix the message.
alias gamendmsg='git commit --amend'

# Amend the last commit: set the author
# Usage:
#  gamendauth "foo <foo@foo>"
alias gamendauth='git commit --amend --author' # should be passed here, as "foo <foo@foo>"

# Cherry-pick
alias gcp='git cherry-pick'
complete -F _gitbranches gcp

alias gcpa='gcp --abort'

# Cherry-pick / back-port the bugfix: appends a line that says "(cherry picked from commit ...)"
alias gcpx='git cherry-pick -x'
complete -F _gitbranches gcpx

# Cherry-pick "theirs"
alias gcptheirs='git cherry-pick -x --strategy recursive -X theirs'
complete -F _gitbranches gcptheirs

# Cherry-pick discarding EOL changes
alias gcpeol='git cherry-pick --strategy=recursive --strategy-option=renormalize'
complete -F _gitbranches gcpeol

# ======================================================
# undoing changes in files
# ======================================================

# Revert changes in a single file to the previous revision (from HEAD^)
# Example: grevert foo.txt
alias grevert='git checkout @^ --'

# ======================================================
# executing pre-commit hook
# ======================================================
# This will invoke the pre-commit hook, but cancel the commit due to empty commit message

# 'git-hook-staged': invoke the hook on staged files only
alias ghks="gcm ''"

# 'git-hook-all':    invoke the hook on all files modified in the working copy
alias ghka="gcam ''"

# ======================================================
# merging
# ======================================================

alias git-merge-theirs='git merge -X theirs'
complete -F _gitbranches git-merge-theirs

alias gmrg='git mergetool'

# Resets to a commit, and squashes all further commit into one
gsquash-over() {
    if [ $# -eq 1 ] ; then
        commit=$1
        git reset --hard $commit ; git merge --squash HEAD@{1}; git commit
    else
        echo -e "Usage: $FUNCNAME <commit>\nDoes hard reset to <commit> and merges all further commits into one"
    fi
}

# ======================================================
# rebasing
# ======================================================

# git rebase.
#  Usage:
#   gri HEAD^^^
#   gri 3
gri(){ # e.g "gri 4"
    # hack to check if $1 exists and is a number...
    if [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null; then
        ref="HEAD`printf %$1s |tr " " "^"`"   # output HEAD^^^^ if $1 == 4
        git rebase -i ${ref}
    else
        git rebase -i $1
    fi
}

# continue rebase
alias grc='git rebase --continue'

# abort rebase
alias gra='git rebase --abort'

# Fetch and rebase on top of the tracking branch
alias gfgr='git fetch && git rebase'

# ======================================================
# pushing
# ======================================================

# Push (meant to be used with simple push semantics e.g. to push to a tracking branch)
alias gp='git push'

# Push to origin.
alias gpo='git push origin'

# Push --force (to a tracking branch).
alias gpf='git push -f'

# Push to origin to a matching branch, and track
alias gpu='git push -u origin $(gcurrbranch)'

# Push to fork to a matching branch, and track
alias gpfork='git push -u fork $(gcurrbranch)'

# Push --force (to a tracking branch) and skip hooks.
alias gpfnv='git push -f --no-verify'

# Push to origin, to master branch
alias gpom='git push origin master'

# Push to origin, to master branch, --force -> careful!
alias gpomf='git push -f origin master'

## Note:
## no gpum='git push upstream master' here to avoid pushing to upstream by mistake due to a typo!

# Deleting remote branch.
#  Usage:                          gdelremote foo
#  To delete local branch:         git branch -d foo
#  To force delete local branch:   git branch -D foo
#  To force delete local branch:   gdel foo
alias gdelremote='git push origin --delete'

# Delete a local branch (force).
#  Usage:                          gdel foo
alias gdel='git branch -D'
complete -F _gitbranches gdel

# ======================================================
# bisecting
# ======================================================
alias gbisect='git bisect start'
alias good='git bisect good'
alias bad='git bisect bad'
alias gbiend='git bisect reset'

# ======================================================
# traversing history
# ======================================================

# Go back in Git commit hierarchy
# Usage:
#  goback
alias goback='git checkout HEAD~'

# Go forward in Git commit hierarchy, towards particular commit.
# Note: not tested on merges (assumes linear history).
# Usage:
#  gofwd v1.2.7
# Does nothing when the parameter is not specified.
gofwd() {
  git checkout `git rev-list --topo-order HEAD.."$*" | tail -1`
}
complete -F _gitbranches gofwd

# ======================================================
# repo cleanup and other stuff
# ======================================================

# For fixing CRLF issues after adding .gitattributes file
alias gfixCRLF="git rm --cached -r . && git reset --hard && git commit -a -m 'Normalize CRLF' -n"

alias gk='gitk'
complete -F _gitbranches gk

archive() {
  git tag archive/$1 $1
  git branch -D $1
}

review() {
  git fetch origin $1
  git checkout origin/$1
}

