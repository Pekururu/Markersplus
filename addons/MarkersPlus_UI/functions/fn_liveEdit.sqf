#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (_display getVariable ["mplus_initializing",true]) exitWith {};
private _marker = _display getVariable ["mplus_selectedMarker",""];
if (_marker == "") exitWith {};
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
private _colors = _panel controlsGroupCtrl MP_COLOR;
private _inputs = [_marker,_display getVariable ["mplus_selectedType",""],
    ctrlText (_panel controlsGroupCtrl MP_LABEL),_colors lbData (lbCurSel _colors),
    ctrlText (_panel controlsGroupCtrl MP_SIZE),ctrlText (_panel controlsGroupCtrl MP_DIRECTION)];
private _before = _display getVariable ["mplus_editInputs",[]];
if (_inputs isEqualTo _before) exitWith {};
_display setVariable ["mplus_editInputs",_inputs];
// Loading a marker seeds the draft without writing anything back to it.
if (_before isEqualTo [] || {(_before select 0) != _marker}) exitWith {};
if !([_marker] call mplus_fnc_isOwnMarker) exitWith {[_display,""] call mplus_fnc_selectMarker};
private _options = [markerType _marker,markerText _marker,markerColor _marker,
    (markerSize _marker) select 0,markerDir _marker,0];
// Only change fields the user touched; leave externally updated fields alone.
for "_i" from 1 to 3 do {
    if ((_inputs select _i) != (_before select _i)) then {_options set [_i - 1,_inputs select _i]};
};
private _size = [_inputs select 4] call mplus_fnc_readNumber;
private _angle = [_inputs select 5] call mplus_fnc_readNumber;
private _sizeValid = _size isNotEqualTo [] && {(_size select 0) >= 0.25 && {(_size select 0) <= 4}};
if (_sizeValid && {(_inputs select 4) != (_before select 4)}) then {_options set [3,_size select 0]};
if (_angle isNotEqualTo [] && {(_inputs select 5) != (_before select 5)}) then {
    _options set [4,(((_angle select 0) % 360) + 360) % 360];
};
private _current = [markerType _marker,markerText _marker,markerColor _marker,
    (markerSize _marker) select 0,markerDir _marker,0];
if (_options isNotEqualTo _current) then {[_display,"update",_options] call mplus_fnc_editMarker};
if (!_sizeValid || {_angle isEqualTo []}) then {
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Enter a valid angle and size (0.25–4).";
};
