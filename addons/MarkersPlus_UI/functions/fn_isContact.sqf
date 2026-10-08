params ["_marker"];
_marker in allMapMarkers && {markerShape _marker == "ICON"} && {
    (_marker find "_USER_DEFINED #") == 0 && {(_marker select [count _marker - 11]) == "/MP_CONTACT"}
}
