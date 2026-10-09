// The report's original sharing scope also controls updates and deletion.
params ["_marker"];
if !([_marker] call mplus_fnc_isContact) exitWith {false};
private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
if ((_records getOrDefault [_marker,[]]) isEqualTo []) exitWith {false};
if ([_marker] call mplus_fnc_ownsMapMarker) exitWith {true};
private _scope = (missionNamespace getVariable ["mplus_contactScopes",createHashMap]) getOrDefault [_marker,[]];
_scope isNotEqualTo [] && {[player,_scope] call mplus_fnc_contactAudience}
