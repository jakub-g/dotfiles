#!/bin/bash

# Print the number of the next issue of given repo.
# Usage:
#  nextiss <username> <reponame>
# If omitted, they default to the $GHUSER / $GHREPO from shell environment.
#
# Requires underscore: npm install -g underscore-cli
nextiss () {
    if [ -z "`which underscore`" ]; then
        echo "nextiss() requires underscore-cli to parse JSON: npm install -g underscore-cli"
        return
    fi

    # read params passed to the function...
    local T_GHUSER=$1
    local T_GHREPO=$2

    # ...if empty, use the ones from the Git repo I'm on...
    # look for upstream and origin, sort reverse to have upstream first if present
    local UPSTREAMDATA=`git remote -v | grep "upstream\|origin" | sort -r | head -1 | perl -l -ne '/github.com(:|\/)([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)(?:\.git)?/ && print $2." ".$3'`

    : ${T_GHUSER:=`echo "$UPSTREAMDATA" | cut -d ' ' -f1`}
    : ${T_GHREPO:=`echo "$UPSTREAMDATA" | cut -d ' ' -f2`}

    # ...if still empty, read from globals
    : ${T_GHUSER:=$GHUSER}
    : ${T_GHREPO:=$GHREPO}

    local GHBASEURL="https://api.github.com/repos/$T_GHUSER/$T_GHREPO/issues?sort=created&direction=desc"
    _echoerr '.....'
    local GH1=`curl -s "$GHBASEURL&state=closed" | underscore extract "0.number" 2>/dev/null`
    _echoerr '.....'
    sleep 1
    _echoerr '.....'
    local GH2=`curl -s "$GHBASEURL&state=open"   | underscore extract "0.number" 2>/dev/null`
    # in case no open/closed issues found, assume 0
    : ${GH1:=0}
    : ${GH2:=0}
    local GHNEXT=$(( ($GH2>$GH1?$GH2:$GH1) + 1))
    echo -e "\nNext issue number for $T_GHUSER/$T_GHREPO:" 1>&2 # write to stderr

    echo "$GHNEXT" # write to stdout, so it's a return value at the same time
}

# Open the browser to create a pull request. The pull request is opened from $GHME:<CURRENTBRANCH>.
# In order for current branch detection to work, you have to invoke this when in your Git repo.
# $GHME is read from shell environment, or if empty, inferred from "origin" git remote URL.
#
# Usage:
#  pullreq <username> <reponame>
# If omitted, they default to the $GHUSER / $GHREPO.
#
# Requires either:
#  - python installed (to open default browser),
#  - or chrome installed,
#  - or firefox in the PATH / alias
pullreq () {
    # read params passed to the function...
    local T_GHUSER=$1
    local T_GHREPO=$2

    # ...if empty, use the ones from the Git repo I'm on...
    # look for upstream and origin, sort reverse to have upstream first if present
    local UPSTREAMDATA=`git remote -v | grep "upstream\|origin" | sort -r | head -1 | perl -l -ne '/github.com[:\/]([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)(?:\.git)?/ && print $1." ".$2'`

    : ${T_GHUSER:=`echo "$UPSTREAMDATA" | cut -d ' ' -f1`}
    : ${T_GHREPO:=`echo "$UPSTREAMDATA" | cut -d ' ' -f2`}

    # ...if still empty, read from globals
    : ${T_GHUSER:=$GHUSER}
    : ${T_GHREPO:=$GHREPO}

    # read Github username from env...
    local T_GHME=$GHME
    # ...or if empty, infer from current repo "origin" remote
    : ${T_GHME:=`git remote -v | grep "origin" | head -1 | perl -l -ne '/github.com[:\/]([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)(?:\.git)?/ && print $1'`}

    local CURRBRANCH=$(git rev-parse --abbrev-ref HEAD)
    local URL="https://github.com/$T_GHUSER/$T_GHREPO/pull/new/$T_GHUSER:master...$T_GHME:$CURRBRANCH"

    if [ -n `which python` ]; then
      # is there any cleaner way to launch the default browser that'll work in MinGW?
      python -mwebbrowser $URL &
    elif [ -n `which chrome` ]; then
      chrome $URL &
    else
      firefox $URL &
    fi
}

# Retrieves next issue number from GH, amends HEAD commit changing all ## to #NEXTISSUE,
# and opens the pull request page on GitHub
fastpull() {
    _echocyan "Retrieving data from GitHub..."
    local PULLNO=$(nextiss)
    echo -e "$PULLNO" # seems the returned value is not displayed in bash

    _echocyan "Amending the Git commit...";
    COMMIT_MSG=$(git log -1 --pretty=%B)
    COMMIT_MSG=$(echo "$COMMIT_MSG" | sed -r "s/##/#$PULLNO/g")
    git commit --amend -m "$COMMIT_MSG"

    _echocyan "New commit message:";
    git log -1 --pretty=%B

    _echocyan "Pushing to origin/$CURRBRANCH...";
    local CURRBRANCH=$(git rev-parse --abbrev-ref HEAD)
    git push -u origin "$CURRBRANCH"
    sleep 2

    _echocyan "Opening pull request page in the browser...";
    pullreq
}

_echoerr() {
    echo -n "$@" 1>&2
}
_echocyan() {
    echo -e "\n\033[0;36m$@\033[0m"
}
