#!/bin/bash

##################################################################
# Open Atlassian Stash pull request from command line.
# (opens the default browser at the proper URL with data prefilled)
#
# It infers current branch name, repo name, current user name, from git config.
############################### CONFIG ###########################
# URL prefix of Stash installation in your company
# BITBUCKER_SERVER_URL_PREFIX="http://example.com"
# this is the list of target branches for PRs; presence here implies being a forbidden input branch
#                       ~!!!!!! no commas between the items !!!!!!
# BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES=("releases/develop" "releases/master")
# additional forbidden input branches, other than the available target branches
# BITBUCKET_SERVER_ADDITIONAL_FORBIDDEN_INPUT_BRANCHES=("master")
##################################################################
pullrequest-bb() {
  if [ -z "$BITBUCKER_SERVER_URL_PREFIX" ] || \
     [ -z "$BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES" ] || \
     [ -z "BITBUCKET_SERVER_ADDITIONAL_FORBIDDEN_INPUT_BRANCHES" ]; then
      echo 'Please configure env variables first!'
      echo ''
      echo 'Example:'
      echo 'BITBUCKER_SERVER_URL_PREFIX=http://mycompany.com'
      echo 'BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES=("releases/develop" "releases/master")'
      echo 'BITBUCKET_SERVER_ADDITIONAL_FORBIDDEN_INPUT_BRANCHES=("master")'
      return
  fi

  SCRIPTNAME="pullrequest" # $0
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
      echo "Usage:"
      echo "$SCRIPTNAME              does 'git push -f' and opens the pull request on Stash"
      echo "$SCRIPTNAME --no-verify  does 'git push -f --no-verify' and opens the pull request on Stash"
      echo "$SCRIPTNAME --no-push    opens the pull request on Stash without pushing"
      echo "$SCRIPTNAME --help       prints this help page"
      return
  fi

  DO_PUSH=true
  if [ "$1" == "--no-push" ] ; then
      DO_PUSH=false
  fi

  VERIFY="--verify"
  if [ "$1" == "--no-verify" ] ; then
      VERIFY="--no-verify"
  fi

  # figure out the name of the current branch
  CURRENT_BRANCH_NAME=$( git rev-parse --abbrev-ref HEAD )
  if [ "$CURRENT_BRANCH_NAME" == "HEAD" ]; then
      echo "You are not currently in a branch. Please checkout a branch."
      return 1
  fi

  # prevent users from opening pull requests from "releases/1.4.0" etc.
  for forbiddenInputBranch in "${BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES[@]}" "${BITBUCKET_SERVER_ADDITIONAL_FORBIDDEN_INPUT_BRANCHES[@]}"
  do
      if [ "$forbiddenInputBranch" == "$CURRENT_BRANCH_NAME" ] ; then
          echo "Please don't open pull requests directly from '${CURRENT_BRANCH_NAME}'; this breaks Stash automatic branch mirroring!"
          echo "Please create a feature branch instead!"
          return 1
      fi
  done

  if [ "$DO_PUSH" = true ] ; then
      echo "Pushing to your remote git repo..."
      git push -u -f origin ${CURRENT_BRANCH_NAME} ${VERIFY}
      returnCode=$?
      if [ "$returnCode" -ne "0" ] ; then
          return
      fi
      echo -e "\n=====================================================================================================\n"
  fi

  # figure out the user based on git remote settings value; taking advantage of "/~USER/" substring in Atlassian Stash URLs
  USER_NAME=$( git config --get remote.origin.url | perl -l -ne '/\/~([^\/]+)\// && print $1' )
  # figure out the repo name: substring after last "/", stripped from ".git"
  REPO_NAME=$( git config --get remote.origin.url | sed 's/.*\///' | sed 's/.git//' )
  # upstream project name (name of Stash project which contains the subrepo)
  STASH_TOP_PROJECT_NAME=$( git config --get remote.upstream.url | awk -F'/' '{print $(NF-1)}' )

  if [ -z "${STASH_TOP_PROJECT_NAME}" ] ; then
      echo "Please set upstream remote URL! (git remote add upstream ...)"
      return 1
  fi

  echo "Opening pull request from '${USER_NAME}/${CURRENT_BRANCH_NAME}' to '${REPO_NAME}'..."
  if [ "$DO_PUSH" = false ] ; then
      echo "(make sure you pushed to the branch before!)"
  fi
  echo ""

  NUM_OF_AVAILABLE_BRANCHES="${#BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES[@]}"
  if [ "${NUM_OF_AVAILABLE_BRANCHES}" == "1" ] ; then
      TARGET_BRANCH="${BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES[0]}"
  else
      # select destination branch from the list
      echo "Select the destination branch of the pull request:"
      PS3='Type the number: '
      select TARGET_BRANCH in "${BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES[@]}"
      do
          goodBranchChosen=false
          for availableBranch in "${BITBUCKET_SERVER_AVAILABLE_TARGET_BRANCHES[@]}"
          do
              if [ "$TARGET_BRANCH" == "$availableBranch" ] ; then
                  goodBranchChosen=true
                  break # break for
              fi
          done

          if [ "$goodBranchChosen" = false ] ; then
              echo "Invalid option chosen, select a number from the list"
          else
              break # break select
          fi
      done
  fi

  # finalize: create the URL and open it
  URL_BASE_USER="/git/users/${USER_NAME}/repos/${REPO_NAME}/pull-requests"
  URL_BASE_PROJECT="/git/projects/${STASH_TOP_PROJECT_NAME}/repos/${REPO_NAME}/pull-requests"
  URL_PARAMS="?create&targetBranch=refs%2Fheads%2F${TARGET_BRANCH}&sourceBranch=refs%2Fheads%2F${CURRENT_BRANCH_NAME}"
  URL_VIEW_PENDING_PRS=${BITBUCKER_SERVER_URL_PREFIX}${URL_BASE_PROJECT}
  URL_OPEN_NEW_PR=${BITBUCKER_SERVER_URL_PREFIX}${URL_BASE_USER}${URL_PARAMS}

  # echo $URL
  # note: if using `start` you have to put dummy first param, or escape & with ^, hence it's better to use `explorer`
  #
  # we are opening two URLs in a quick succession, instead of just one, this is a hack because first time Stash is opened it performs
  # some authentication which does a redirection at the end, which loses the query string...

  # open the pending pull requests list for the given repo
  start "$URL_VIEW_PENDING_PRS"
  sleep 1
  # open a page when you create a new pull request
  start "$URL_OPEN_NEW_PR"
}