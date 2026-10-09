#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_map"];
private _display = ctrlParent _map;
if (!visibleMap) exitWith {};
// Also catches paste/cut edits that do not produce a keyboard event.
[_display] call mplus_fnc_liveEdit;
private _panel = _display displayCtrl MP_PANEL;
private _selected = _display getVariable ["mplus_selectedMarker",""];
if (_selected != "") then {
    if !([_selected] call mplus_fnc_isOwnMarker) then {
        [_display,""] call mplus_fnc_selectMarker;
        _selected = "";
    } else {
        [_map,markerPos _selected,_selected] call mplus_fnc_drawSelection;
    };
};
if !(_display getVariable ["mplus_placing",false]) exitWith {};
private _mouse = getMousePosition;
private _inRect = {
    params ["_rect","_point"];
    _rect params ["_x","_y","_w","_h"];
    _point params ["_px","_py"];
    _px >= _x && {_px <= _x + _w} && {_py >= _y} && {_py <= _y + _h}
};
if (!([ctrlPosition _map,_mouse] call _inRect) || {[ctrlPosition _panel,_mouse] call _inRect}) exitWith {};
private _options = [_display] call mplus_fnc_readOptions;
if (_options isEqualTo []) exitWith {};
_options params ["_type","_text","_color","_size","_direction"];
private _position = _map ctrlMapScreenToWorld _mouse;
private _rotation = [_map,_mouse] call mplus_fnc_rotationGesture;
if (_rotation isNotEqualTo []) then {
    _position = _rotation select 0;
    _direction = _rotation select 1;
    _map drawLine [_position,_map ctrlMapScreenToWorld _mouse,[1,0.85,0.15,0.8]];
};
private _config = configFile >> "CfgMarkers" >> _type;
private _rgba = [_color] call mplus_fnc_markerColor;
_rgba set [3,0.7];
private _iconSize = [_size,_size];
private _copyStyle = _display getVariable ["mplus_duplicateStyle",[]];
if (_copyStyle isNotEqualTo [] && {_size == (_copyStyle select 0)}) then {_iconSize = _copyStyle select 1};
private _pixels = getNumber (_config >> "size");
_map drawIcon [getText (_config >> "icon"),_rgba,_position,
    _pixels * (_iconSize select 0),_pixels * (_iconSize select 1),_direction,_text,0,0.035,"RobotoCondensed","right"];
