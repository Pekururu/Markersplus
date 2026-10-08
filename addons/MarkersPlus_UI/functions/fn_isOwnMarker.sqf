params ["_marker"];
if !(_marker in allMapMarkers) exitWith {false};
if (markerShape _marker != "ICON" || {[_marker] call mplus_fnc_isContact}) exitWith {false};
// Personal vanilla icons loaded from plans use our local editor too. ACE's
// standard editor replaces icons with shared markers when confirmed.
if ((markerType _marker find "mplus_") != 0 && {!(_marker in (missionNamespace getVariable ["mplus_personalPlanIcons",[]]))}) exitWith {false};
[_marker] call mplus_fnc_ownsMapMarker
