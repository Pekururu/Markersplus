#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
private _mouse = getMousePosition;
private _map = _display displayCtrl 51;
if (isNull _map) exitWith {false};
private _inRect = {
    params ["_rect","_point"];
    _rect params ["_x","_y","_w","_h"];
    _point params ["_px","_py"];
    _px >= _x && {_px <= _x + _w} && {_py >= _y} && {_py <= _y + _h}
};
if !([ctrlPosition _map,_mouse] call _inRect) exitWith {false};
private _panel = _display displayCtrl MP_PANEL;
if (!isNull _panel && {[ctrlPosition _panel,_mouse] call _inRect}) exitWith {false};
private _contacts = _display displayCtrl MP_CONTACT_PANEL;
if (!isNull _contacts && {[ctrlPosition _contacts,_mouse] call _inRect}) exitWith {false};
private _list = _display displayCtrl MP_CONTACT_LIST_PANEL;
if (!isNull _list && {ctrlShown _list} && {[ctrlPosition _list,_mouse] call _inRect}) exitWith {true};
private _closest = [_map,_mouse] call mplus_fnc_markerAtCursor;
if (_closest == "") exitWith {false};
// Shared markers retain native Delete behavior when the panel is closed.
if !([_closest] call mplus_fnc_isLocalMarker && {[_closest] call mplus_fnc_ownsMapMarker}) exitWith {false};
deleteMarkerLocal _closest;
if (_closest == (_display getVariable ["mplus_contactSelected",""])) then {[_display] call mplus_fnc_closeContacts};
(missionNamespace getVariable ["mplus_contactRecords",createHashMap]) deleteAt _closest;
if (_closest == (_display getVariable ["mplus_selectedMarker",""])) then {
    [_display,""] call mplus_fnc_selectMarker;
};
true
