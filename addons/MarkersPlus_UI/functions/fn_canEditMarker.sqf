params ["_marker"];
if !(_marker in allMapMarkers) exitWith {false};
if (markerShape _marker != "ICON" || {[_marker] call mplus_fnc_isContact}) exitWith {false};
if ([_marker] call mplus_fnc_isLocalMarker) exitWith {[_marker] call mplus_fnc_isOwnMarker};
if ((markerType _marker find "mplus_") != 0) exitWith {false};
// Only native user markers belong in the shared editor; leave mission markers alone.
if ((_marker find "_USER_DEFINED #") != 0) exitWith {false};
[markerChannel _marker] call mplus_fnc_channelAvailable
