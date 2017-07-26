deployAPK ()
{
    FN=${FUNCNAME[0]};
    if [ $# -eq 0 ]; then
        echo "Usage:   $FN <filename>";
        echo "Example: $FN /d/apks/test.apk";
        return;
    fi;
    adb shell pm uninstall -k com.example.myapp;
    adb install -r $1
}
