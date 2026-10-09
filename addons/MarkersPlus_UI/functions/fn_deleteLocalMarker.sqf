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
// Contact reports share the same Delete permission as their update/status actions.
if ([_closest] call mplus_fnc_isContact && {[_closest] call mplus_fnc_canEditContact}) exitWith {
    private _channel = if ([_closest] call mplus_fnc_isLocalMarker) then {-2} else {markerChannel _closest};
    if !([_channel] call mplus_fnc_channelAvailable) exitWith {true};
    if (_channel == -2) then {deleteMarkerLocal _closest} else {deleteMarker _closest};
    [_closest,_channel] call mplus_fnc_forgetContact;
    ace_markers_userPlacedMarkers = ace_markers_userPlacedMarkers - [_closest];
    if (_closest == (_display getVariable ["mplus_contactSelected",""])) then {[_display] call mplus_fnc_closeContacts};
    true
};
// Shared markers retain native Delete behavior when the panel is closed.
if !([_closest] call mplus_fnc_isLocalMarker && {[_closest] call mplus_fnc_ownsMapMarker}) exitWith {false};
deleteMarkerLocal _closest;
if (_closest == (_display getVariable ["mplus_contactSelected",""])) then {[_display] call mplus_fnc_closeContacts};
(missionNamespace getVariable ["mplus_contactRecords",createHashMap]) deleteAt _closest;
if (_closest == (_display getVariable ["mplus_selectedMarker",""])) then {
    [_display,""] call mplus_fnc_selectMarker;
};
true
