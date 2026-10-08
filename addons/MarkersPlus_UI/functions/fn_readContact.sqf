#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
private _panel = _display displayCtrl MP_CONTACT_PANEL;
if (isNull _panel) exitWith {[]};
private _data = {
    params ["_id"];
    private _control = _display displayCtrl _id;
    _control lbData (lbCurSel _control)
};
private _observer = _display getVariable ["mplus_contactObserver",["",[],[]]];
// Treat a blank or whitespace-only optional count as unknown, never as zero.
private _countChars = toArray ctrlText (_display displayCtrl MP_CONTACT_COUNT);
while {count _countChars > 0 && {(_countChars select 0) in [9,10,13,32]}} do {_countChars deleteAt 0};
while {count _countChars > 0 && {(_countChars select (count _countChars - 1)) in [9,10,13,32]}} do {_countChars deleteAt (count _countChars - 1)};
private _record = [1,[MP_CONTACT_TYPE] call _data,toString _countChars,
    [MP_CONTACT_ACTIVITY] call _data,[MP_CONTACT_AFFILIATION] call _data,[MP_CONTACT_ACCURACY] call _data,
    [MP_CONTACT_MOVEMENT] call _data,ctrlText (_display displayCtrl MP_CONTACT_NOTE),
    ctrlText (_display displayCtrl MP_CONTACT_TIME),_observer select 0,_observer select 1,_observer select 2];
if !([_record] call mplus_fnc_validateContact) exitWith {[]};
private _observedDate = +(_record select 11);
_observedDate set [3,parseNumber ((_record select 8) select [0,2])];
_observedDate set [4,parseNumber ((_record select 8) select [3,2])];
_record set [11,_observedDate];
_record
