#!/bin/bash

deploy-apk() {
  FN=${FUNCNAME[0]}
  if [ $# -eq 0 ] ; then
    echo "Usage:   $FN <filename>"
    echo "Example: $FN /d/apks/some.apk"
    return
  fi
  adb shell pm uninstall -k $ANDROID_PACKAGE_ID
  adb install -r -d $1
}

alias uninstall-apk="adb shell pm uninstall -k $ANDROID_PACKAGE_ID"