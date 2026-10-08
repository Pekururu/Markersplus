#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_mode","_event"];
_event params ["_map","_button","_x","_y","_shift","_ctrl","_alt"];
private _display = ctrlParent _map;
private _list = _display displayCtrl MP_CONTACT_LIST_PANEL;
private _overList = false;
if (!isNull _list && {ctrlShown _list}) then {
    (ctrlPosition _list) params ["_lx","_ly","_lw","_lh"];
    _overList = _x >= _lx && {_x <= _lx+_lw} && {_y >= _ly} && {_y <= _ly+_lh};
};
if (_overList) exitWith {_display setVariable ["mplus_contactDown",[]]; true};
private _panel = _display displayCtrl MP_CONTACT_PANEL;
(ctrlPosition _panel) params ["_px","_py","_pw","_ph"];
if (_x >= _px && {_x <= _px+_pw} && {_y >= _py} && {_y <= _py+_ph}) exitWith {_display setVariable ["mplus_contactDown",[]]; true};
(ctrlPosition _map) params ["_mx","_my","_mw","_mh"];
if (_button != 0 || {_shift || _ctrl || _alt} || {_x < _mx || {_x > _mx+_mw} || {_y < _my} || {_y > _my+_mh}}) exitWith {
    _display setVariable ["mplus_contactDown",[]]; false
};
private _picking = _display getVariable ["mplus_contactPicking",false];
if (_mode == "double") exitWith {
    if (_picking || {diag_tickTime - (_display getVariable ["mplus_lastPlaced",-1]) < .3}) exitWith {true};
    private _marker = [_map,[_x,_y]] call mplus_fnc_markerAtCursor;
    if ([_marker] call mplus_fnc_isContact) then {[_marker] call mplus_fnc_openContacts; true} else {false}
};
if (_mode == "down") exitWith {_display setVariable ["mplus_contactDown",[_x,_y]]; _picking};
private _down = _display getVariable ["mplus_contactDown",[]];
_display setVariable ["mplus_contactDown",[]];
if (_down isEqualTo [] || {_down distance2D [_x,_y] >= .008 * safeZoneW}) exitWith {false};
if (_picking) exitWith {[_display,"position",_map ctrlMapScreenToWorld [_x,_y]] call mplus_fnc_contactAction; true};
private _marker = [_map,[_x,_y]] call mplus_fnc_markerAtCursor;
if (_marker == "") exitWith {false};
if ([_marker] call mplus_fnc_isContact) then {[_marker] call mplus_fnc_openContacts} else {
    [true] call mplus_fnc_togglePanel; [_display,_marker] call mplus_fnc_selectMarker;
};
true
