#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display","_active"];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
private _status = _panel controlsGroupCtrl MP_STATUS;
if (_active && {(_display getVariable ["mplus_selectedMarker",""]) != ""}) then {
    [_display,""] call mplus_fnc_selectMarker;
};
if (_active) then {
    private _options = [_display] call mplus_fnc_readOptions;
    if (_options isEqualTo []) exitWith {_active = false; _status ctrlSetText "Choose a marker and size between 0.25 and 4."};
    if !([_options select 5] call mplus_fnc_channelAvailable) exitWith {_active = false; _status ctrlSetText "That sharing channel is unavailable."};
    _status ctrlSetText "Click places; hold + drag rotates. Esc cancels.";
} else {_status ctrlSetText "Placement stopped. Esc closes the panel."};
if (!_active) then {
    _display setVariable ["mplus_duplicateStyle",[]];
    (_panel controlsGroupCtrl MP_TITLE) ctrlSetText (["Markers","Edit marker"] select ((_display getVariable ["mplus_selectedMarker",""]) != ""));
};
_display setVariable ["mplus_placing",_active];
_display setVariable ["mplus_mouseDown",[]];
private _caption = if (_active) then {
    "Cancel placement"
} else {
    if ((_display getVariable ["mplus_selectedMarker",""]) != "") then {"Place new marker"} else {"Place marker"}
};
(_panel controlsGroupCtrl MP_PLACE) ctrlSetText _caption;
