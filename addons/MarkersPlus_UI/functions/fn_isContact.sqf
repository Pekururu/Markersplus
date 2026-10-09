params ["_marker"];
_marker in allMapMarkers && {markerShape _marker == "ICON"} && {
    [_marker] call mplus_fnc_isContactName
}
