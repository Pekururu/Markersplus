#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (isNull _display) exitWith {};
private _list = _display displayCtrl MP_CONTACT_LIST_PANEL;
if (!isNull _list) then {ctrlDelete _list};
private _panel = _display displayCtrl MP_CONTACT_PANEL;
if (isNull _panel) exitWith {};
_display setVariable ["mplus_contactPicking",false];
_display setVariable ["mplus_contactSelected",""];
_display setVariable ["mplus_contactDown",[]];
private _map = _display displayCtrl 51;
private _draw = _display getVariable ["mplus_contactDraw",-1];
if (_draw >= 0 && {!isNull _map}) then {_map ctrlRemoveEventHandler ["Draw",_draw]};
{
    private _id = _display getVariable [_x select 0,-1];
    if (_id >= 0) then {_display displayRemoveEventHandler [_x select 1,_id]};
    _display setVariable [_x select 0,-1];
} forEach [["mplus_contactKey","KeyDown"],["mplus_contactRelease","MouseButtonUp"]];
_display setVariable ["mplus_contactDraw",-1];
[{if (!isNull (_this select 0)) then {ctrlDelete (_this select 0)}},[_panel]] call CBA_fnc_execNextFrame;
