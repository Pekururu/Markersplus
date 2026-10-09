#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params [["_marker",""]];
if (!hasInterface || {isNull player} || {dialog}) exitWith {};
if (!visibleMap || {isNull findDisplay 12}) exitWith {
    openMap true;
    [{visibleMap && {!isNull findDisplay 12}},{_this call mplus_fnc_openContacts},[_marker],3] call CBA_fnc_waitUntilAndExecute;
};
private _display = findDisplay 12;
if (_marker != "" && {!([_marker] call mplus_fnc_isContact)}) exitWith {};
[_display] call mplus_fnc_closePanel;
[_display] call mplus_fnc_attachMap;
private _panel = _display displayCtrl MP_CONTACT_PANEL;
private _createdPanel = isNull _panel;
if (_createdPanel) then {
    _panel = _display ctrlCreate ["mplus_ContactPanel",MP_CONTACT_PANEL];
    _panel ctrlSetPosition [safeZoneX + .71 * safeZoneW,safeZoneY + .18 * safeZoneH,.24 * safeZoneW,.64 * safeZoneH];
    _panel ctrlCommit 0;
};
_display setVariable ["mplus_contactInitializing",true];
[_panel controlsGroupCtrl MP_CONTACT_CONTROLS,"contacts"] call mplus_fnc_controlsHint;
call mplus_fnc_updateMapGestures;
_display setVariable ["mplus_contactSelected",_marker];
_display setVariable ["mplus_contactPicking",_marker == ""];
_display setVariable ["mplus_contactDown",[]];
_display setVariable ["mplus_contactPositionDirty",false];
_display setVariable ["mplus_contactInputs",[]];
_display setVariable ["mplus_contactDetails",false];
private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
private _record = _records getOrDefault [_marker,[]];
_display setVariable ["mplus_contactLoaded",_record];
private _missing = _marker != "" && {_record isEqualTo []};
_display setVariable ["mplus_contactMissing",_missing];
private _editable = _marker == "" || {!_missing && {[_marker] call mplus_fnc_ownsMapMarker}};
_display setVariable ["mplus_contactEditable",_editable];
if (_record isEqualTo []) then {
    private _d = date;
    private _pad = {params ["_number"]; private _s=str _number; if (count _s<2) then {_s="0"+_s}; _s};
    _record = [1,"Unknown","","Unknown","Unknown","Estimated","Unknown","",
        format ["%1:%2",[_d select 3] call _pad,[_d select 4] call _pad],
        format ["%1 (%2)",name player,groupId group player],getPosWorld player,_d];
};
_display setVariable ["mplus_contactObserver",[_record select 9,+(_record select 10),+(_record select 11)]];
_display setVariable ["mplus_contactDisabled",_record param [12,false]];
_display setVariable ["mplus_contactPosition",if (_marker == "") then {[]} else {markerPos _marker}];
private _fillCombo = {
    params ["_id","_values","_selected"];
    private _ctrl = _display displayCtrl _id;
    lbClear _ctrl;
    {private _row = _ctrl lbAdd _x; _ctrl lbSetData [_row,_x]; if (_x == _selected) then {_ctrl lbSetCurSel _row}} forEach _values;
};
private _typeControl = _display displayCtrl MP_CONTACT_TYPE;
lbClear _typeControl;
{
    _x params ["_key","_name"];
    private _row = _typeControl lbAdd _name;
    _typeControl lbSetData [_row,_key];
    if (_key == (_record select 1)) then {_typeControl lbSetCurSel _row};
} forEach (call mplus_fnc_contactTypes);
[MP_CONTACT_ACTIVITY,["Unknown","Stationary","Moving","Firing"],_record select 3] call _fillCombo;
[MP_CONTACT_AFFILIATION,["Unknown","Friendly","Hostile","Civilians"],_record select 4] call _fillCombo;
[MP_CONTACT_ACCURACY,["Estimated","Precise"],_record select 5] call _fillCombo;
[MP_CONTACT_MOVEMENT,["Unknown","N","NE","E","SE","S","SW","W","NW"],_record select 6] call _fillCombo;
(_display displayCtrl MP_CONTACT_COUNT) ctrlSetText (_record select 2);
(_display displayCtrl MP_CONTACT_ESTIMATE) cbSetChecked (_record param [13,false]);
(_display displayCtrl MP_CONTACT_NOTE) ctrlSetText (_record select 7);
(_display displayCtrl MP_CONTACT_TIME) ctrlSetText (_record select 8);
private _channels = _display displayCtrl MP_CONTACT_CHANNEL;
lbClear _channels;
private _selectedChannel = if (_marker == "") then {missionNamespace getVariable ["mplus_contactChannel",1]} else {if ([_marker] call mplus_fnc_isLocalMarker) then {-2} else {markerChannel _marker}};
{
    _x params ["_label","_channel"];
    if ([_channel] call mplus_fnc_channelAvailable || {_marker != "" && {_channel == _selectedChannel}}) then {
        private _row = _channels lbAdd _label; _channels lbSetValue [_row,_channel];
        if (_channel == _selectedChannel) then {_channels lbSetCurSel _row};
    };
} forEach [["Local only (you)",-2],["Side",1],["Group",3],["Command",2],["Vehicle",4],["Global (everyone)",0]];
if (lbCurSel _channels < 0) then {_channels lbSetCurSel 0};
{
    (_display displayCtrl _x) ctrlEnable _editable;
} forEach [MP_CONTACT_TYPE,MP_CONTACT_COUNT,MP_CONTACT_ESTIMATE,MP_CONTACT_ACTIVITY,MP_CONTACT_AFFILIATION,
    MP_CONTACT_ACCURACY,MP_CONTACT_TIME,MP_CONTACT_NOTE,MP_CONTACT_NOW,MP_CONTACT_LOCATION];
_channels ctrlEnable (_marker == "");
(_display displayCtrl MP_CONTACT_DELETE) ctrlShow (_marker != "" && {_editable});
(_display displayCtrl MP_CONTACT_CREATE) ctrlSetText (if (_marker == "") then {"Create report"} else {if (_editable) then {"Update report"} else {"Read only"}});
(_display displayCtrl MP_CONTACT_TITLE) ctrlSetText (if (_marker == "") then {"Contact report"} else {"Contact details"});
(_display displayCtrl MP_CONTACT_STATUS) ctrlSetText (if (_missing) then {"Details unavailable. Requesting from server."} else {if (_marker == "") then {"Click the observed location on the map."} else {if (_editable) then {"Change fields, then Update report."} else {"Report by another player. Read only."}}});
_display setVariable ["mplus_contactInitializing",false];
[_display] call mplus_fnc_refreshContact;
if (_createdPanel) then {
    private _map = _display displayCtrl 51;
    private _draw = _map ctrlAddEventHandler ["Draw",{_this call mplus_fnc_drawContact}];
    _display setVariable ["mplus_contactDraw",_draw];
    private _key = _display displayAddEventHandler ["KeyDown",{
        params ["_display","_key"];
        if (_key != 1) exitWith {false};
        if (_display getVariable ["mplus_contactPicking",false]) then {
            _display setVariable ["mplus_contactPicking",false];
            _display setVariable ["mplus_contactDown",[]];
            (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Picking cancelled. Click the location button to resume.";
        } else {[_display] call mplus_fnc_closeContacts};
        true
    }];
    _display setVariable ["mplus_contactKey",_key];
    private _release = _display displayAddEventHandler ["MouseButtonUp",{
        params ["_display","_button"];
        if (_button == 0) then {
            [{params ["_display"]; if (!isNull _display) then {_display setVariable ["mplus_contactDown",[]]}},[_display]] call CBA_fnc_execNextFrame;
        };
        false
    }];
    _display setVariable ["mplus_contactRelease",_release];
};
["mplus_contactRequest",[player]] call CBA_fnc_serverEvent;
