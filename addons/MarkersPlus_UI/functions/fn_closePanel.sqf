#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (isNull _display) exitWith {};
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
[_display] call mplus_fnc_liveEdit;
private _options = [_display] call mplus_fnc_readOptions;
if (_options isNotEqualTo []) then {missionNamespace setVariable ["mplus_lastOptions",_options]};
_display setVariable ["mplus_placing",false];
_display setVariable ["mplus_duplicateStyle",[]];
_display setVariable ["mplus_selectedMarker",""];
_display setVariable ["mplus_gridTiles",[]];
_display setVariable ["mplus_mouseDown",[]];
_display setVariable ["mplus_numberedDialogUntil",-1];
{
    _x params ["_control","_event","_id"];
    _control ctrlRemoveEventHandler [_event,_id];
} forEach (_display getVariable ["mplus_mapHandlers",[]]);
_display setVariable ["mplus_mapHandlers",[]];
private _keyHandler = _display getVariable ["mplus_keyHandler",-1];
if (_keyHandler >= 0) then {_display displayRemoveEventHandler ["KeyDown",_keyHandler]};
_display setVariable ["mplus_keyHandler",-1];
private _releaseHandler = _display getVariable ["mplus_releaseHandler",-1];
if (_releaseHandler >= 0) then {_display displayRemoveEventHandler ["MouseButtonUp",_releaseHandler]};
_display setVariable ["mplus_releaseHandler",-1];
// Defer deletion: ctrlDelete must not destroy the currently executing button event.
[{if (!isNull (_this select 0)) then {ctrlDelete (_this select 0)}},[_panel]] call CBA_fnc_execNextFrame;
