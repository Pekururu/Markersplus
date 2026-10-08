#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_mode","_event"];
_event params ["_map","_button","_x","_y","_shift","_ctrl","_alt"];
private _display = ctrlParent _map;
if (!isNull (_display displayCtrl MP_CONTACT_PANEL)) exitWith {[_mode,_event] call mplus_fnc_contactMapInput};
private _panel = _display displayCtrl MP_PANEL;
// Ignore panel clicks and leave modified input (including ACE Alt-drag) intact.
private _overPanel = false;
if (!isNull _panel) then {
    (ctrlPosition _panel) params ["_px","_py","_pw","_ph"];
    _overPanel = _x >= _px && {_x <= _px + _pw} && {_y >= _py} && {_y <= _py + _ph};
};
if (_overPanel) exitWith {_display setVariable ["mplus_mouseDown",[]]; true};
(ctrlPosition _map) params ["_mx","_my","_mw","_mh"];
if (_x < _mx || {_x > _mx + _mw} || {_y < _my} || {_y > _my + _mh} || {
    _button != 0 || {_shift || _ctrl || _alt}
}) exitWith {
    _display setVariable ["mplus_mouseDown",[]];
    false
};
private _placing = _display getVariable ["mplus_placing",false];
if (_mode == "double") exitWith {
    if (_placing || {diag_tickTime - (_display getVariable ["mplus_lastPlaced",-1]) < 0.3}) exitWith {true};
    private _marker = [_map,[_x,_y]] call mplus_fnc_markerAtCursor;
    if (_marker == "") exitWith {false};
    if ([_marker] call mplus_fnc_isContact) then {[_marker] call mplus_fnc_openContacts} else {
        [true] call mplus_fnc_togglePanel; [_display,_marker] call mplus_fnc_selectMarker;
    };
    true
};
if (_mode == "down") exitWith {
    _display setVariable ["mplus_mouseDown",[_x,_y,diag_tickTime,
        _map ctrlMapScreenToWorld [_x,_y],[_map,[_x,_y]] call mplus_fnc_markerAtCursor]];
    _placing
};
private _down = _display getVariable ["mplus_mouseDown",[]];
private _rotation = [_map,[_x,_y]] call mplus_fnc_rotationGesture;
_display setVariable ["mplus_mouseDown",[]];
if (_down isEqualTo []) exitWith {_placing};
if (_rotation isNotEqualTo []) exitWith {
    _rotation params ["_position","_direction"];
    [_display,_position,_direction] call mplus_fnc_placeMarker;
    true
};
if ((_down select [0,2]) distance2D [_x,_y] >= 0.008 * safeZoneW) exitWith {_placing};
private _marker = [_map,[_x,_y]] call mplus_fnc_markerAtCursor;
if (_marker != "") exitWith {
    if ([_marker] call mplus_fnc_isContact) then {[_marker] call mplus_fnc_openContacts} else {
        [true] call mplus_fnc_togglePanel; [_display,_marker] call mplus_fnc_selectMarker;
    };
    true
};
if (!_placing) exitWith {
    if (!isNull _panel) then {[_display,""] call mplus_fnc_selectMarker};
    false
};
[_display,_map ctrlMapScreenToWorld [_x,_y]] call mplus_fnc_placeMarker;
true
