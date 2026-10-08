params ["_marker"];
if ([_marker] call mplus_fnc_isLocalMarker) exitWith {};
// Use the same property/JIP event as ACE's editor so ACE moves survive JIP.
["ace_markers_setMarkerNetwork",[_marker,[markerType _marker,markerColor _marker,
    markerPos _marker,markerDir _marker,(markerSize _marker) select 0]]] call CBA_fnc_globalEvent;
