#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params [["_openOnly",false]];
private _display = findDisplay 12;
if (!visibleMap || {isNull _display} || {isNull player}) exitWith {};
if (!isNull (_display displayCtrl MP_PANEL)) exitWith {if (!_openOnly) then {[_display] call mplus_fnc_closePanel}};
[_display] call mplus_fnc_closeContacts;
[_display] call mplus_fnc_attachMap;
private _panel = _display ctrlCreate ["mplus_Panel",MP_PANEL];
_panel ctrlSetPosition [safeZoneX + safeZoneW * 0.71, safeZoneY + safeZoneH * 0.18, safeZoneW * 0.24, safeZoneH * 0.64];
_panel ctrlCommit 0;
[_panel controlsGroupCtrl MP_CONTROLS,"markers"] call mplus_fnc_controlsHint;
call mplus_fnc_updateMapGestures;
_display setVariable ["mplus_initializing",true];
_display setVariable ["mplus_placing",false];
_display setVariable ["mplus_selectedMarker",""];

private _options = +(missionNamespace getVariable ["mplus_lastOptions",[
    "mplus_aapoint","",missionNamespace getVariable ["mplus_defaultColor","ColorBlack"],
    missionNamespace getVariable ["mplus_defaultSize",1],0,1
]]);
_display setVariable ["mplus_selectedType",_options select 0];
(_panel controlsGroupCtrl MP_LABEL) ctrlSetText (_options select 1);
(_panel controlsGroupCtrl MP_SIZE) ctrlSetText str (_options select 3);
(_panel controlsGroupCtrl MP_DIRECTION) ctrlSetText str (_options select 4);

private _categories = _panel controlsGroupCtrl MP_CATEGORY;
{
    _x params ["_name","_class"];
    private _row = _categories lbAdd _name;
    _categories lbSetData [_row,_class];
} forEach [["All markers",""],["Favorites","favorites"],["Tasks","mplus_tasks"],["Movement","mplus_movement"],["Points","mplus_points"]];
_categories lbSetCurSel 0;

private _colors = _panel controlsGroupCtrl MP_COLOR;
private _colorIndex = 0;
{
    _x params ["_class","_name"];
    private _row = _colors lbAdd _name;
    _colors lbSetData [_row,_class];
    private _rgba = [_class] call mplus_fnc_markerColor;
    _colors lbSetPicture [_row,"#(argb,8,8,3)color(1,1,1,1)"];
    _colors lbSetPictureColor [_row,_rgba];
    _colors lbSetPictureColorSelected [_row,_rgba];
    if (_class == (_options select 2)) then {_colorIndex = _row};
} forEach (call mplus_fnc_markerColors);
_colors lbSetCurSel _colorIndex;

private _channels = _panel controlsGroupCtrl MP_CHANNEL;
private _channelIndex = 0;
private _current = missionNamespace getVariable ["mplus_defaultChannel",1];
{
    _x params ["_name","_channel"];
    if ([_channel] call mplus_fnc_channelAvailable) then {
        private _row = _channels lbAdd _name;
        _channels lbSetValue [_row,_channel];
        if (_channel == _current) then {_channelIndex = _row};
    };
} forEach [["Local only (you)",-2],["Group",3],["Side",1],["Command",2],["Vehicle",4],["Global (everyone)",0]];
_channels lbSetCurSel _channelIndex;
_display setVariable ["mplus_initializing",false];
[_display] call mplus_fnc_filterMarkers;
[_display,""] call mplus_fnc_selectMarker;

private _map = _display displayCtrl 51;
private _handlers = [];
_handlers pushBack [_map,"Draw",_map ctrlAddEventHandler ["Draw",{_this call mplus_fnc_drawPreview}]];
_display setVariable ["mplus_mapHandlers",_handlers];
private _keyHandler = _display displayAddEventHandler ["KeyDown",{
    params ["_display","_key"];
    if (_key != 1) exitWith {false};
    if (_display getVariable ["mplus_placing",false]) then {
        [_display,false] call mplus_fnc_setPlacement;
    } else {[_display] call mplus_fnc_closePanel};
    true
}];
_display setVariable ["mplus_keyHandler",_keyHandler];
// A release over another control must end the gesture too. Defer cleanup so
// the map control's release handler can commit first, regardless of event order.
private _releaseHandler = _display displayAddEventHandler ["MouseButtonUp",{
    params ["_display","_button"];
    if (_button != 0) exitWith {false};
    private _down = _display getVariable ["mplus_mouseDown",[]];
    [{
        params ["_display","_down"];
        if (!isNull _display && {(_display getVariable ["mplus_mouseDown",[]]) isEqualTo _down}) then {
            _display setVariable ["mplus_mouseDown",[]];
        };
    },[_display,_down]] call CBA_fnc_execNextFrame;
    false
}];
_display setVariable ["mplus_releaseHandler",_releaseHandler];
ctrlSetFocus (_panel controlsGroupCtrl MP_SEARCH);
