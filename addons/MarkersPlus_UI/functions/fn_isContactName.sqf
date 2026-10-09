// Pure name check: also used on the server before marker replication arrives.
params ["_marker"];
if ((_marker find "_USER_DEFINED #") != 0) exitWith {false};
// Keep legacy reports readable for the rest of their mission. Saved-plan loads
// create fresh names, without rewriting stored report records or old markers.
if ((_marker select [(count _marker - 11) max 0]) == "/MP_CONTACT") exitWith {true};
private _parts = _marker splitString "/";
if (count _parts != 3) exitWith {false};
private _digits = toArray (_parts select 1);
if (_digits isEqualTo [] || {_digits findIf {_x < 48 || {_x > 57}} >= 0}) exitWith {false};
private _id = parseNumber (_parts select 1);
_id >= 2000000 && {_id < 3000000} && {(_parts select 2) in ["-2","0","1","2","3","4"]}
