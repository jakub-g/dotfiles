#!/bin/bash

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

# Display diff code
alias gd='git diff'

# Display staged diff code
alias gdc='git diff --cached'

# Display diff stats (one file per line)
alias gds='git diff --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20'

# Display code diff of the tip in branch/tag/commit. Shows HEAD if parameterless.
alias gsh='git show'
complete -F _gitbranches gsh

# Display diff stats of the tip in branch/tag/commit. Shows HEAD if parameterless.
alias gshs='git show --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20'
complete -F _gitbranches gshs

# Same as gshs, but also shows committer (not only author)
alias gshmeta='git show --stat --stat-width=140 --stat-name-width=120 --stat-graph-width=20 --pretty=full'

# Same as gsh + Instead of displaying full line deletions, displays colored inline changes.
alias gshmin='git show --color-words'

# Instead of displaying full line deletions, displays colored inline changes.
alias gdmin='git diff --color-words'

# Displays files changed in a particular commit.
# Usage:
#  gfiles <commit-id>
#  gfiles HEAD
alias gfiles='git diff-tree -r --name-only --no-commit-id'
complete -F _gitbranches gfiles

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
alias gh='ghis'

# Like gh, if you want to display more items.
# Usage:
#  ghm -20
alias ghm='git log --format="%C(cyan)%cd%Creset %C(yellow)%h%Creset %s %Cgreen%an%Creset %n%C(black bold)%b%Creset" --date=short -10'

# Display flat short log.
# Usage:
#  ghiss
#  ghiss -20
alias ghiss='git log --oneline -10'

# Various non-flat log versions
alias gl='git log -5'
alias glog='git log -10'
alias glog1="git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative"
alias glog2="git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(bold white)- %an%C(reset)' --abbrev-commit"
alias glog3="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# ======================================================
# branches - displaying
# ======================================================

# Display recent local branches and last commit date (sorted by last commit date)
alias gb='git for-each-ref --sort=-committerdate --format="%(committerdate:short) %(refname:short)" refs/heads/'

# Display recent local branches - only a few of them (10 by default)
alias gbh='gb | head'

# Display recent local branches - short (only names) (sorted by last commit date)
alias gbs='git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads/'

# Display just the name of the current branch
alias gcurrbranch='git rev-parse --abbrev-ref HEAD'

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

# ======================================================
# branches - switching
# ======================================================

# Check out the branch.
alias gck='git checkout'

# Usage:
#  goto iss234
alias goto='git checkout'

# Create a new branch out of current branch.
# Usage:
#  forkto iss234
alias forkto='git checkout -b'

# Rename current branch.
# Usage:
#  moveto iss234
alias moveto='git branch -m'

# Master is checked out so frequently it deserves its own command.
alias gmaster='git checkout master'

complete -F _gitbranches goto
complete -F _gitbranches gck

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

alias gsync='git fetch origin && git rebase origin/master $(gcurrbranch)'
# Use gsyncc in favor of gsync when you're in gh-pages etc.
alias gsyncc='git fetch origin && git rebase origin/$(gcurrbranch) $(gcurrbranch)'
alias gsyncf='git stash && gsync && git stash pop'
alias gsynctag='git fetch --tags origin'

# ======================================================
# staging / unstaging
# ======================================================

# 'git add all' but only already tracked (update)
alias ga='git add -u .'

# 'git add absolutely all', even untracked and deleted
alias gaaa='git add -A .'

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

alias gc='git commit'
alias gca='git commit -a'

# Commit with inline commit message.
#  Usage: gcam "Commit message"
alias gcm='git commit -m'           # Like above

# Commit with inline commit message, including not staged files.
#  Usage like 'gcm'. Don't confuse with commit --amend
alias gcam='git commit -a -m'

# Amend the last commit - e.g. fix the message.
alias gamend='git commit --amend'

# Amend the last commit, squashing all local changes into it.
alias gamendall='gaaa && gamend'

# Amend the last commit: set date to current date
alias gamenddate='git commit --amend --date="$(date -R)"'

# Amend the last commit: set the author
# Usage:
#  gamendauth "foo <foo@foo>"
alias gamendauth='git commit --amend --author' # should be passed here, as "foo <foo@foo>"

# Cherry-pick
alias gcp='git cherry-pick'
complete -F _gitbranches gcp

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

# Rebase on top of master
alias gremaster='git rebase master'

# ======================================================
# pushing
# ======================================================

# Push (meant to be used with simple push semantics e.g. to push to a tracking branch)
alias gp='git push'

# Push to origin.
alias gpo='git push origin'

# Push --force (to a tracking branch).
alias gpf='git push -f'

# Push to origin -- special command to avoid pushing to upstream by confusing upstream and origin accidentally.
alias gpushfork='gpo'

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
