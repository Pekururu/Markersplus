// Open the Markersplus panel without selecting a marker, then Execute Local.
disableSerialization;
private _display = findDisplay 12;
private _panel = _display displayCtrl 81001;
if (isNull _panel || {(_display getVariable ["mplus_selectedMarker",""]) != ""}) exitWith {hint "Open the marker panel without selecting a marker first."};
private _size = _panel controlsGroupCtrl 81015;
private _angle = _panel controlsGroupCtrl 81016;
private _saved = [sliderPosition _size,sliderPosition _angle];
private _failures = [];
if (sliderRange _size isNotEqualTo [0.25,4]) then {_failures pushBack "Size range"};
if (sliderRange _angle isNotEqualTo [0,360]) then {_failures pushBack "Angle range"};
{
    _x params ["_scale","_bearing"];
    _size sliderSetPosition _scale;
    _angle sliderSetPosition _bearing;
    private _options = [_display] call mplus_fnc_readOptions;
    if (_options isEqualTo []) then {_failures pushBack "Missing options"} else {
        if (abs ((_options select 3) - _scale) > 0.001) then {_failures pushBack format ["Size %1",_scale]};
        if (abs ((_options select 4) - (_bearing % 360)) > 0.001) then {_failures pushBack format ["Angle %1",_bearing]};
    };
} forEach [[0.25,0],[1,90],[4,360]];
{
    _x params ["_control","_class","_changed","_default"];
    private _handler = compile getText (configFile >> "mplus_Panel" >> "controls" >> _class >> "onMouseButtonDown");
    _control sliderSetPosition _changed;
    [_control,0] call _handler;
    if (abs (sliderPosition _control - _changed) > 0.001) then {_failures pushBack format ["%1 left-click reset",_class]};
    [_control,1] call _handler;
    if (abs (sliderPosition _control - _default) > 0.001) then {_failures pushBack format ["%1 right-click reset",_class]};
} forEach [[_size,"Size",2,1],[_angle,"Direction",90,0]];
_size sliderSetPosition (_saved select 0);
_angle sliderSetPosition (_saved select 1);
[_display] call mplus_fnc_liveEdit;
hint format ["Slider failures: %1",_failures];
diag_log format ["Markersplus slider failures: %1",_failures];
_failures
