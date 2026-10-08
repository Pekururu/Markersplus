#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display",["_marker",""]];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
if (_marker != "" && {!([_marker] call mplus_fnc_isOwnMarker)}) exitWith {};
_display setVariable ["mplus_selectedMarker",_marker];
_display setVariable ["mplus_editInputs",[]];
[_display,false] call mplus_fnc_setPlacement;
private _editing = _marker != "";
(_panel controlsGroupCtrl MP_TITLE) ctrlSetText (["MarkersPlus","MarkersPlus: Edit"] select _editing);
{
    (_panel controlsGroupCtrl _x) ctrlEnable _editing;
    (_panel controlsGroupCtrl _x) ctrlShow _editing;
} forEach [MP_DELETE,MP_NEW];
(_panel controlsGroupCtrl MP_CHANNEL) ctrlEnable (!_editing);
[_display] call mplus_fnc_layoutPanel;
if (!_editing) exitWith {
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Choose a symbol, then click the map.";
};
// Clear filters so the existing symbol is always present in the grid.
_display setVariable ["mplus_initializing",true];
(_panel controlsGroupCtrl MP_SEARCH) ctrlSetText "";
(_panel controlsGroupCtrl MP_CATEGORY) lbSetCurSel 0;
_display setVariable ["mplus_selectedType",markerType _marker];
(_panel controlsGroupCtrl MP_LABEL) ctrlSetText (markerText _marker);
(_panel controlsGroupCtrl MP_SIZE) ctrlSetText str ((markerSize _marker) select 0);
(_panel controlsGroupCtrl MP_DIRECTION) ctrlSetText str (markerDir _marker);
private _colors = _panel controlsGroupCtrl MP_COLOR;
private _colorRow = -1;
for "_i" from 0 to (lbSize _colors - 1) do {
    if (_colors lbData _i == markerColor _marker) then {_colorRow = _i};
};
if (_colorRow < 0) then {
    _colorRow = _colors lbAdd (markerColor _marker);
    _colors lbSetData [_colorRow,markerColor _marker];
};
_colors lbSetCurSel _colorRow;
private _channel = if ([_marker] call mplus_fnc_isLocalMarker) then {-2} else {parseNumber ((_marker splitString "/") select 2)};
private _channels = _panel controlsGroupCtrl MP_CHANNEL;
private _channelRow = -1;
for "_i" from 0 to (lbSize _channels - 1) do {
    if (_channels lbValue _i == _channel) then {_channelRow = _i};
};
if (_channelRow < 0) then {
    _channelRow = _channels lbAdd format ["Channel %1 (unavailable)",_channel];
    _channels lbSetValue [_channelRow,_channel];
};
_channels lbSetCurSel _channelRow;
_display setVariable ["mplus_initializing",false];
[_display] call mplus_fnc_filterMarkers;
[_display] call mplus_fnc_liveEdit;
(_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Edits save automatically. Alt-drag moves.";
