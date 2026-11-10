#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (_display getVariable ["mplus_initializing",true]) exitWith {};
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
private _size = sliderPosition (_panel controlsGroupCtrl MP_SIZE);
private _angle = sliderPosition (_panel controlsGroupCtrl MP_DIRECTION);
(_panel controlsGroupCtrl MP_SIZE_TITLE) ctrlSetText format ["Size: %1x",_size toFixed 2];
(_panel controlsGroupCtrl MP_DIRECTION_TITLE) ctrlSetText format ["Angle: %1 deg",round _angle];
private _marker = _display getVariable ["mplus_selectedMarker",""];
if (_marker == "") exitWith {};
private _colors = _panel controlsGroupCtrl MP_COLOR;
private _inputs = [_marker,_display getVariable ["mplus_selectedType",""],
    ctrlText (_panel controlsGroupCtrl MP_LABEL),_colors lbData (lbCurSel _colors),
    _size,_angle];
private _before = _display getVariable ["mplus_editInputs",[]];
if (_inputs isEqualTo _before) exitWith {};
_display setVariable ["mplus_editInputs",_inputs];
// Loading a marker seeds the draft without writing anything back to it.
if (_before isEqualTo [] || {(_before select 0) != _marker}) exitWith {};
if !([_marker] call mplus_fnc_canEditMarker) exitWith {[_display,""] call mplus_fnc_selectMarker};
private _options = [markerType _marker,markerText _marker,markerColor _marker,
    (markerSize _marker) select 0,markerDir _marker,0];
// Only change fields the user touched; leave externally updated fields alone.
for "_i" from 1 to 3 do {
    if ((_inputs select _i) != (_before select _i)) then {_options set [_i - 1,_inputs select _i]};
};
if ((_inputs select 4) != (_before select 4)) then {_options set [3,_size]};
if ((_inputs select 5) != (_before select 5)) then {_options set [4,_angle % 360]};
private _current = [markerType _marker,markerText _marker,markerColor _marker,
    (markerSize _marker) select 0,markerDir _marker,0];
if (_options isNotEqualTo _current) then {[_display,"update",_options] call mplus_fnc_editMarker};
