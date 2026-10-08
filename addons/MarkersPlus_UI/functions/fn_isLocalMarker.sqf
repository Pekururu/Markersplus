params ["_marker"];
// Keep recognizing personal markers created by earlier MarkersPlus builds.
(_marker find "mplus_local_") == 0 || {
    (_marker find "_USER_DEFINED #") == 0 && {((_marker splitString "/") param [2,""]) == "-2"}
}
