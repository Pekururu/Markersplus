params ["_class"];
// Some colours contain profile expressions instead of literal numbers.
private _rgba = getArray (configFile >> "CfgMarkerColors" >> _class >> "color") apply {
    if (_x isEqualType "") then {call compile _x} else {_x}
};
if (count _rgba != 4 || {_rgba findIf {!(_x isEqualType 0)} >= 0}) exitWith {[1,1,1,1]};
_rgba
