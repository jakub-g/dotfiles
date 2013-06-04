#!/bin/bash

# Aria Templates command line shortcuts
#
# Note: Due to MinGW bug (feature?), command line params starting with leading /, are expanded by the shell to C:/path/to/mingw/..
# In order to avoid it, I used cmd //c "originalcommand" in attest(). Remove cmd //c and quotes if you're on real UNIX env.

# Launch attester with default config.
# Usage:
#  attester
alias attester='npm run-script attester'

# Launch attester passing one specific test classpath.
# Usage:
#  attest test.aria.widgets.form.autocomplete.issue315.OpenDropDownFromButtonTest
#  attest test/aria/widgets/form/autocomplete/issue315/OpenDropDownFromButtonTest
#  attest test/aria/widgets/form/autocomplete/issue315/OpenDropDownFromButtonTest.js
# @param $1 classpath
attest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        cmd //c "node node_modules/attester/bin/attester.js --phantomjs-instances 1 --config.tests.aria-templates.extraScripts /aria/css/atskin.js --config.resources./ src --config.resources./test test --config.tests.aria-templates.classpaths.includes ${classpath}"
    else
        echo "Please provide a classpath."
    fi
}

chattest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        cmd //c "node node_modules/attester/bin/attester.js --port 7777 --browsers.browserName Chrome --config.tests.aria-templates.extraScripts /aria/css/atskin.js --config.resources./ src --config.resources./test test --config.tests.aria-templates.classpaths.includes ${classpath}"
    else
        echo "Please provide a classpath."
    fi
}

fxattest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        cmd //c "node node_modules/attester/bin/attester.js --port 7777 --browsers.browserName Firefox --config.tests.aria-templates.extraScripts /aria/css/atskin.js --config.resources./ src --config.resources./test test --config.tests.aria-templates.classpaths.includes ${classpath}"
    else
        echo "Please provide a classpath."
    fi
}

fxtest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        url=$(_testUrlFromClasspath $classpath)
        firefox $url &
    else
        echo "Please provide a classpath."
    fi
}
ietest() {
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        url=$(_testUrlFromClasspath $classpath)
        ie $url &
    else
        echo "Please provide a classpath."
    fi
}
chtest() { # you'll need to add (at least on Windows) the folder of chrome executable to the system's PATH
    if [ $# -eq 1 ] ; then
        classpath=$(_filenameToClassPath $1)
        url=$(_testUrlFromClasspath $classpath)
        chrome $url &
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
