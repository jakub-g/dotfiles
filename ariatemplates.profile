#!/bin/bash

# Aria Templates command line shortcuts
#
# Note: Due to MinGW bug (feature?), command line params starting with leading /, are expanded by the shell to C:/path/to/mingw/..
# In order to avoid it, I used cmd //c "originalcommand" in attest(). Remove cmd //c and quotes if you're on real UNIX env.

# Launch attester with default config.
# Usage:
#  attester
alias attester='npm run-script attester'

# store some strings for reuse
sharedConf='--predictable-urls true --shutdown-on-campaign-end false --config.tests.aria-templates.extraScripts /aria/css/atskin.js --config.resources./ src --config.resources./test test'
classpathConfPrefix='--config.tests.aria-templates.classpaths.includes'
attesterPath='node node_modules/attester/bin/attester.js' # assuming this is done in AT directory, using it's npm-installed Attester
attesterSlaveUrl="http://localhost:7777/__attester__/slave.html"

# Launch attester passing one specific test classpath.
# Usage:
#  attest test.aria.widgets.form.autocomplete.issue315.OpenDropDownFromButtonTest
#  attest test/aria/widgets/form/autocomplete/issue315/OpenDropDownFromButtonTest
#  attest test/aria/widgets/form/autocomplete/issue315/OpenDropDownFromButtonTest.js
# @param $1 classpath
attest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        cmd //c "${attesterPath} --phantomjs-instances 1 ${sharedConf} ${classpathConfPrefix} ${classpath}"
    else
        echo "Please provide a classpath."
    fi
}

# chattest and fxattest do the following:
# 1. Start a new Attester campaign with the specific classpath to be executed, and the provided browser expected to connect
# 2. If -o is passed at the end: open the Attester URL in the given browser.
# Note that since both of those things are done asynchronously, the URL might hit 40
# if Attester's server didn't manage to boot up by the time the browser tries to hit the URL. Just F5 then to reload.

fxattest() {
    _browserattest $# "$1" "Firefox" &
    if [ "$2" == "-o" ]; then
        sleep 1
        firefox ${attesterSlaveUrl} &
    fi
}
chattest() {
    _browserattest $# "$1" "Chrome" &
    if [ "$2" == "-o" ]; then
        sleep 1
        chrome ${attesterSlaveUrl} &
    fi
}
ieattest() {
    _browserattest $# "$1" "IE" &
    if [ "$2" == "-o" ]; then
        sleep 1
        iexplore ${attesterSlaveUrl} &
    fi
}

fxtest() {
    _browsertest $# "$1" "firefox"
}
chtest() { # you'll need to add (at least on Windows) the folder of chrome executable to the system's PATH
    _browsertest $# "$1" "chrome"
}
ietest() {
    _browsertest $# "$1" "iexplore"
}

_browsertest() {
    # $1: no.of params passed to previous func,
    # $2: classpath,
    # $3: browsername (executable)

    browsername=$3
    # this is rather ugly, but I haven't found a better way to read the alias...
    browserexec=$(type "$browsername" | sed "s/$browsername is aliased to//" | sed "s/^ *\|\`\|'//g")
    if [ $1 -eq 1 ] ; then
        classpath=$(_filenameToClassPath $2)
        url=$(_testUrlFromClasspath $classpath)
        if [[ "$browserexec" = "/"* ]] ; then
            # /c/Program\ Files/Mozilla\ Firefox/firefox.exe
            # can't run it directly here like this neither unquoted nor quoted in MinGW, need to remove backlashes
            browserexec=${browserexec//\\/} # remove backslashes...
            "$browserexec" $url &
        else
            # sth like C:\Documents and Settings\qbk\Local Settings\Application Data\Google\Chrome\Application\chrome.exe
            # this can be run, quoted, by MinGW
            "$browserexec" $url &
        fi
    else
        echo "Please provide a classpath."
    fi
}

_browserattest() {
    # $1: no.of params passed to previous func,
    # $2: classpath,
    # $3: browsername (attester-expected)

    if [ $1 -eq 1 ] || [ $1 -eq 2 ] ; then
        classpath=$(_filenameToClassPath $2)
        cmd //c "${attesterPath} --port 7777 --browsers.browserName $3 ${sharedConf} ${classpathConfPrefix} ${classpath}"
    else
        echo "Please provide a classpath."
    fi
}

multest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        ietest ${classpath} &
        fxtest ${classpath} &
        chtest ${classpath} &
        attest ${classpath}
    else
        echo "Please provide a classpath."
    fi
}

# =============== helpers ===============

# @param $1 filename
_filenameToClassPath() {
    # / to . replacements allows for folder-based TAB-autocompletion to work
    echo $1 | sed -e 's/\//\./g' | sed -e 's/.js$//g'
}

# @param $1 classpath
_testUrlFromClasspath() {
    echo "http://localhost/aria-templates/test/beta.html?dev=true&debug=true&verbose=true&testClasspath=$1"
}
