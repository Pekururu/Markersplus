#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display","_position"];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {false};
private _options = [_display] call mplus_fnc_readOptions;
if (_options isEqualTo []) exitWith {
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Choose a marker and size between 0.25 and 4.";
    false
};
private _inputLabel = _options select 1;
private _seed = missionNamespace getVariable ["mplus_numberedLabel",""];
private _previousInput = missionNamespace getVariable ["mplus_numberedInputLabel",""];
if (_inputLabel != "" && {_inputLabel != _previousInput} && {_inputLabel != _seed}) then {_seed = _inputLabel};
private _next = [_seed] call mplus_fnc_nextMarkerLabel;
if (_next isEqualTo []) exitWith {
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Use a blank label or end it with a number (e.g. CP 01).";
    false
};
_options set [1,_next select 0];
private _style = _display getVariable ["mplus_duplicateStyle",[]];
private _selected = _display getVariable ["mplus_selectedMarker",""];
if (_selected != "" && {[_selected] call mplus_fnc_isOwnMarker}) then {
    _style = [(markerSize _selected) select 0,markerSize _selected,markerAlpha _selected,markerShadow _selected];
};
[_display,_position,-1,[_options,_style]] call mplus_fnc_placeMarker
