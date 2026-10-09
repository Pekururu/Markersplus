#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display","_action",["_position",[]]];
if (isNull (_display displayCtrl MP_CONTACT_PANEL)) exitWith {};
private _selected = _display getVariable ["mplus_contactSelected",""];
private _editable = _display getVariable ["mplus_contactEditable",false];
if (_action == "new") exitWith {[] call mplus_fnc_openContacts};
if (_action == "details") exitWith {
    _display setVariable ["mplus_contactDetails",!(_display getVariable ["mplus_contactDetails",false])];
    [_display] call mplus_fnc_refreshContact;
};
if (_action == "pick") exitWith {
    if (!_editable) exitWith {};
    _display setVariable ["mplus_contactPicking",true];
    (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Click the observed position. Map dragging still works.";
};
private _setObserver = {
    private _d = date;
    private _pad = {params ["_n"]; private _s=str _n; if (count _s<2) then {_s="0"+_s}; _s};
    (_display displayCtrl MP_CONTACT_TIME) ctrlSetText format ["%1:%2",[_d select 3] call _pad,[_d select 4] call _pad];
    _display setVariable ["mplus_contactObserver",[format ["%1 (%2)",name player,groupId group player],getPosWorld player,_d]];
};
if (_action == "now") exitWith {if (_editable) then {call _setObserver; [_display] call mplus_fnc_refreshContact}};
if (_action == "position") exitWith {
    if (!_editable) exitWith {};
    if ((_display getVariable ["mplus_contactPosition",[]]) isEqualTo []) then {call _setObserver};
    _display setVariable ["mplus_contactPosition",+_position];
    _display setVariable ["mplus_contactPositionDirty",_selected != ""];
    _display setVariable ["mplus_contactPicking",false];
    (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Position chosen. Complete the report, then submit.";
    [_display] call mplus_fnc_refreshContact;
};
_position = _display getVariable ["mplus_contactPosition",[]];
private _record = [_display] call mplus_fnc_readContact;
if (_action == "copy") exitWith {
    if (_position isNotEqualTo [] && {_record isNotEqualTo []} && {!(_display getVariable ["mplus_contactMissing",false])}) then {
        copyToClipboard (([_record,_position] call mplus_fnc_formatContact) select 1);
        (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Report copied for voice/radio use.";
    };
};
if (!_editable) exitWith {};
if (_selected != "" && {!([_selected] call mplus_fnc_ownsMapMarker)}) exitWith {
    (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Original report is no longer available.";
};
private _channels = _display displayCtrl MP_CONTACT_CHANNEL;
private _channel = _channels lbValue (lbCurSel _channels);
if !([_channel] call mplus_fnc_channelAvailable) exitWith {(_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Sharing channel unavailable."};
private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
if (_action == "disable") exitWith {
    if (_selected == "") exitWith {};
    // Toggle the saved observation, independently of incomplete or unsent field edits.
    private _saved = +(_records getOrDefault [_selected,[]]);
    if !([_saved] call mplus_fnc_validateContact) exitWith {};
    private _disabled = !(_saved param [12,false]);
    private _estimated = _saved param [13,false];
    _saved resize 12;
    _saved set [0,1];
    if (_estimated) then {_saved set [0,3]; _saved append [_disabled,true]} else {
        if (_disabled) then {_saved set [0,2]; _saved pushBack true};
    };
    ([_saved] call mplus_fnc_contactAppearance) params ["_type","_color"];
    _selected setMarkerTypeLocal _type;
    _selected setMarkerColorLocal _color;
    private _label = ([_saved,markerPos _selected] call mplus_fnc_formatContact) select 0;
    if (_channel == -2) then {_selected setMarkerTextLocal _label} else {
        _selected setMarkerText _label;
        [_selected] call mplus_fnc_syncAceMarker;
        ["mplus_contactPublish",[player,_selected,_saved,_channel]] call CBA_fnc_serverEvent;
    };
    _records set [_selected,_saved];
    _display setVariable ["mplus_contactLoaded",_saved];
    _display setVariable ["mplus_contactDisabled",_disabled];
    [_display] call mplus_fnc_refreshContact;
    [_display] call mplus_fnc_refreshContactList;
    (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText (["Contact reactivated.","Contact disabled."] select _disabled);
};
if (_action == "delete") exitWith {
    if (_selected == "") exitWith {};
    if (_channel == -2) then {deleteMarkerLocal _selected} else {
        deleteMarker _selected;
    };
    [_selected,_channel] call mplus_fnc_forgetContact;
    ace_markers_userPlacedMarkers = ace_markers_userPlacedMarkers - [_selected];
    [] call mplus_fnc_openContacts;
    (_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Contact removed. Ready for a new report.";
};
if (_action != "submit" || {_position isEqualTo []} || {_record isEqualTo []}) exitWith {};
private _marker = _selected;
if (_marker == "") then {
    private _name = ([_channel] call mplus_fnc_newMarkerName) + "/MP_CONTACT";
    _marker = if (_channel == -2) then {createMarkerLocal [_name,_position]} else {createMarker [_name,_position,_channel,player]};
};
if (_marker == "") exitWith {(_display displayCtrl MP_CONTACT_STATUS) ctrlSetText "Could not create marker. Try again."};
([_record] call mplus_fnc_contactAppearance) params ["_markerType","_markerColor"];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal _markerType;
_marker setMarkerColorLocal _markerColor;
_marker setMarkerPosLocal _position;
if (_selected == "") then {_marker setMarkerSizeLocal [1,1]; _marker setMarkerDirLocal 0};
private _label = ([_record,_position] call mplus_fnc_formatContact) select 0;
if (_channel == -2) then {_marker setMarkerTextLocal _label} else {
    _marker setMarkerText _label;
    [_marker] call mplus_fnc_syncAceMarker;
    ["mplus_contactPublish",[player,_marker,_record,_channel]] call CBA_fnc_serverEvent;
};
_records set [_marker,_record];
ace_markers_userPlacedMarkers pushBackUnique _marker;
_display setVariable ["mplus_lastPlaced",diag_tickTime];
[_marker] call mplus_fnc_openContacts;
(_display displayCtrl MP_CONTACT_STATUS) ctrlSetText (["Contact updated.","Contact created. New starts another report."] select (_selected == ""));
