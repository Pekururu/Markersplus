// Open the map and Markersplus panel, then Execute Local while not holding the mouse.
disableSerialization;
private _display = findDisplay 12;
private _map = _display displayCtrl 51;
if (isNull (_display displayCtrl 81001)) exitWith {hint "Open the Markersplus panel first."};
private _saved = _display getVariable ["mplus_mouseDown",[]];
private _position = _map ctrlMapScreenToWorld [safeZoneX + safeZoneW * 0.4,safeZoneY + safeZoneH * 0.5];
private _marker = createMarkerLocal [[-2] call mplus_fnc_newMarkerName,_position];
_marker setMarkerTypeLocal "mplus_aapoint";
_marker setMarkerDirLocal 37;
private _mouse = _map ctrlMapWorldToScreen (_position vectorAdd [100,0,0]);
private _delay = missionNamespace getVariable ["mplus_rotationDelay",0.5];
private _failures = [];
_display setVariable ["mplus_mouseDown",[0,0,diag_tickTime - _delay - 1,_position,_marker]];
private _rotation = [_map,_mouse] call mplus_fnc_rotationGesture;
if (_rotation isEqualTo []) then {_failures pushBack "Existing marker rejected"} else {
    if (abs ((_rotation select 1) - 90) > 0.1) then {_failures pushBack "East bearing"};
};
if (markerDir _marker != 37) then {_failures pushBack "Preview changed marker"};
if (([_map,_map ctrlMapWorldToScreen _position] call mplus_fnc_rotationGesture) isNotEqualTo []) then {_failures pushBack "Pivot jitter"};
_display setVariable ["mplus_mouseDown",[0,0,diag_tickTime + 1,_position,_marker]];
if (([_map,_mouse] call mplus_fnc_rotationGesture) isNotEqualTo []) then {_failures pushBack "Hold delay"};
_display setVariable ["mplus_mouseDown",[0,0,diag_tickTime - _delay - 1,_position,_marker]];
deleteMarkerLocal _marker;
if (([_map,_mouse] call mplus_fnc_rotationGesture) isNotEqualTo []) then {_failures pushBack "Deleted marker accepted"};
_display setVariable ["mplus_mouseDown",_saved];
hint format ["Rotation failures: %1",_failures];
diag_log format ["Markersplus rotation failures: %1",_failures];
_failures
