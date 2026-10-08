#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_control","_row"];
private _display = ctrlParent _control;
if (_row < 0 || {_display getVariable ["mplus_contactListInit",true]}) exitWith {};
private _marker = _control lnbData [_row,0];
if (!([_marker] call mplus_fnc_isContact) || {isNil {(missionNamespace getVariable ["mplus_contactRecords",createHashMap]) get _marker}}) exitWith {[_display] call mplus_fnc_refreshContactList};
private _map = _display displayCtrl 51;
// Keep the selected marker visible below the expanded list instead of behind it.
private _center = _map ctrlMapScreenToWorld [safeZoneX + .5 * safeZoneW,safeZoneY + .5 * safeZoneH];
private _visiblePoint = _map ctrlMapScreenToWorld [safeZoneX + .49 * safeZoneW,safeZoneY + .67 * safeZoneH];
private _position = markerPos _marker;
private _target = [(_position select 0) + (_center select 0) - (_visiblePoint select 0),
    (_position select 1) + (_center select 1) - (_visiblePoint select 1),0];
_map ctrlMapAnimAdd [0.25,ctrlMapScale _map,_target];
ctrlMapAnimCommit _map;
[_marker] call mplus_fnc_openContacts;
