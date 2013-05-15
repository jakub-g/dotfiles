#!/bin/bash

# Setting globals if not present in environment
: ${GHME:="jakub-g"}
: ${GHUSER:="ariatemplates"}
: ${GHREPO:="ariatemplates"}

# Print the number of the next issue of given repo.
# Usage:
#  nextiss <username> <reponame>
# If omitted, they default to the $GHUSER / $GHREPO.
#
# Requires underscore: npm install -g underscore-cli
nextiss () {
    # read params passed to the function...
    T_GHUSER=$1
    T_GHREPO=$2

    # ...if empty, use the ones from the Git repo I'm on...
    # look for upstream and origin, sort reverse to have upstream first if present
    UPSTREAMDATA=`git remote -v | grep "upstream\|origin" | sort -r | head -1 | perl -l -ne '/github.com(:|\/)([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)\.git/ && print $2." ".$3'`

    : ${T_GHUSER:=`echo "$UPSTREAMDATA" | cut -d ' ' -f1`}
    : ${T_GHREPO:=`echo "$UPSTREAMDATA" | cut -d ' ' -f2`}

    # ...if still empty, read from globals
    : ${T_GHUSER:=$GHUSER}
    : ${T_GHREPO:=$GHREPO}

    GHBASEURL="https://api.github.com/repos/$T_GHUSER/$T_GHREPO/issues?sort=created&direction=desc"
    GH1=`curl -s "$GHBASEURL&state=closed" | underscore extract "0.number" 2>/dev/null`
    GH2=`curl -s "$GHBASEURL&state=open"   | underscore extract "0.number" 2>/dev/null`
    # in case no open/closed issues found, assume 0
    : ${GH1:=0}
    : ${GH2:=0}
    GHNEXT=$(( ($GH2>$GH1?$GH2:$GH1) + 1))
    echo "Next issue number for $T_GHUSER/$T_GHREPO: $GHNEXT"
}

# Open the browser to create a pull request. The pull request is opened from <GHME>:<CURRENTBRANCH>.
# In order for current branch detection to work, you have to invoke this when in your Git repo.
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
    T_GHUSER=$1
    T_GHREPO=$2

    # ...if empty, use the ones from the Git repo I'm on...
    # look for upstream and origin, sort reverse to have upstream first if present
    UPSTREAMDATA=`git remote -v | grep "upstream\|origin" | sort -r | head -1 | perl -l -ne '/github.com[:\/]([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)\.git/ && print $1." ".$2'`

    : ${T_GHUSER:=`echo "$UPSTREAMDATA" | cut -d ' ' -f1`}
    : ${T_GHREPO:=`echo "$UPSTREAMDATA" | cut -d ' ' -f2`}

    # ...if still empty, read from globals
    : ${T_GHUSER:=$GHUSER}
    : ${T_GHREPO:=$GHREPO}

    # read Github username from env...
    T_GHME=$GHME
    # ...or if empty, infer from current repo "origin" remote
    : ${T_GHME:=`git remote -v | grep "origin" | head -1 | perl -l -ne '/github.com[:\/]([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)\.git/ && print $1'`}

    CURRBRANCH=`git rev-parse --abbrev-ref HEAD`
    URL="https://github.com/$T_GHUSER/$T_GHREPO/pull/new/$T_GHREPO:master...$T_GHME:$CURRBRANCH"

    if [ -n `which python` ]; then
      # is there any cleaner way to launch the default browser that'll work in MinGW?
      python -mwebbrowser $URL &
    elif [ -n `which chrome` ]; then
      chrome $URL &
    else
      firefox $URL &
    fi
}
