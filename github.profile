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
    T_GHUSER=$1
    T_GHREPO=$2

    # default to globals if params not passed
    : ${T_GHUSER:=$GHUSER}
    : ${T_GHREPO:=$GHREPO}

    GHBASEURL="https://api.github.com/repos/$T_GHUSER/$T_GHREPO/issues?sort=created&direction=desc"

    GH1=`curl -s "$GHBASEURL&state=closed" | underscore extract "0.number"`
    GH2=`curl -s "$GHBASEURL&state=open"   | underscore extract "0.number"`
    GHNEXT=$(( ($GH2>$GH1?$GH2:$GH1) + 1))
    echo "Next issue number for $GHUSER/$GHREPO: $GHNEXT"
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
    T_GHUSER=$1
    T_GHREPO=$2

    # default to globals if params not passed
    : ${T_GHUSER:=$GHUSER}
    : ${T_GHREPO:=$GHREPO}

    CURRBRANCH=`git rev-parse --abbrev-ref HEAD`
    URL="https://github.com/$T_GHUSER/$T_GHREPO/pull/new/$T_GHREPO:master...$GHME:$CURRBRANCH"

    if [ -n `which python` ]; then
      # is there any cleaner way to launch the default browser that'll work in MinGW?
      python -mwebbrowser $URL &
    elif [ -n `which chrome` ]; then
      chrome $URL &
    else
      firefox $URL &
    fi
}
