#!/bin/bash
fetchpr-bb() {
  if [ $# -eq 0 ]; then
    echo ""
    echo "fetchpr: Fetch/force-update and checkout a pull request from Stash."
    echo ""
    echo "You need to have clean git state before using this command."
    echo "Note that you can only fetch a pullrequest that was not yet merged."
    echo ""
    echo "Usage:   fetchpr <pr_no>"
    echo "Example: fetchpr 123"
    if ! (git remote -v | grep upstream > /dev/null) ; then
      echo ""
      echo "You need to configure "upstream" remote first if you don't have it:"
      echo "git add remote upstream <url>"
    fi
    return
  fi
  PR_NO=$1
  git fetch -u --force upstream refs/pull-requests/${PR_NO}/from:pr${PR_NO}
  git checkout pr${PR_NO}
}
