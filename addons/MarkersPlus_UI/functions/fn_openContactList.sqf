#include "\markersplus_ui\script_component.hpp"
disableSerialization;
if (!hasInterface || {isNull player} || {dialog}) exitWith {};
if (!visibleMap || {isNull findDisplay 12}) exitWith {
    openMap true;
    [{visibleMap && {!isNull findDisplay 12}},{[] call mplus_fnc_openContactList},[],3] call CBA_fnc_waitUntilAndExecute;
};
private _display = findDisplay 12;
if (isNull (_display displayCtrl MP_CONTACT_PANEL)) then {[] call mplus_fnc_openContacts};
private _panel = _display displayCtrl MP_CONTACT_LIST_PANEL;
if (!isNull _panel) exitWith {
    _panel ctrlShow !(ctrlShown _panel);
    if (ctrlShown _panel) then {
        [_display] call mplus_fnc_refreshContactList;
        ["mplus_contactRequest",[player]] call CBA_fnc_serverEvent;
    };
};
_panel = _display ctrlCreate ["mplus_ContactListPanel",MP_CONTACT_LIST_PANEL];
// Attach directly to the left edge and top of the report panel.
_panel ctrlSetPosition [safeZoneX + .27 * safeZoneW,safeZoneY + .18 * safeZoneH,.44 * safeZoneW,.36 * safeZoneH];
_panel ctrlCommit 0;
_display setVariable ["mplus_contactListRows",[]];
_display setVariable ["mplus_contactListInit",false];
[_display] call mplus_fnc_refreshContactList;
["mplus_contactRequest",[player]] call CBA_fnc_serverEvent;
[{
    params ["_args","_handle"];
    _args params ["_display","_panel"];
    if (isNull _display || {isNull _panel}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler};
    if (ctrlShown _panel) then {[_display] call mplus_fnc_refreshContactList};
},1,[_display,_panel]] call CBA_fnc_addPerFrameHandler;
