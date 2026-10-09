#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (isNull _display || {_display getVariable ["mplus_contactListInit",true]}) exitWith {};
private _panel = _display displayCtrl MP_CONTACT_LIST_PANEL;
if (isNull _panel || {!ctrlShown _panel}) exitWith {};
private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
private _rows = [];
private _types = call mplus_fnc_contactTypes;
{
    private _marker = _x;
    private _record = _records get _marker;
    if ([_marker] call mplus_fnc_isContact) then {
        private _index = _types findIf {(_x select 0) == (_record select 1)};
        private _type = (_types select (_index max 0)) select 2;
        if (_record select 1 == "Infantry" && {_record select 4 == "Civilians"}) then {_type = "PERS"};
        private _count = _record select 2;
        if (_count != "" && {_record param [13,false]}) then {_count = "~" + _count};
        if (_count != "") then {_type = format ["%1 %2",_count,_type]};
        private _activity = _record select 3;
        if (_activity == "Moving") then {_activity = format ["%1 %2",_activity,_record select 6]};
        private _disabled = _record param [12,false];
        if (_disabled) then {_activity = "DISABLED"};
        _rows pushBack [_marker,[toUpper (_record select 4),toUpper _type,toUpper _activity,mapGridPosition markerPos _marker,_record select 8],_disabled];
    };
} forEach keys _records;
_rows sort true;
if (_rows isEqualTo (_display getVariable ["mplus_contactListRows",[]])) exitWith {
    if (_rows isEqualTo []) then {(_display displayCtrl MP_CONTACT_LIST_STATUS) ctrlSetText "No contact reports available."};
};
_display setVariable ["mplus_contactListRows",_rows];
_display setVariable ["mplus_contactListInit",true];
private _list = _display displayCtrl MP_CONTACT_LIST;
private _selected = _display getVariable ["mplus_contactSelected",""];
private _selection = -1;
lnbClear _list;
{
    _x params ["_marker","_cells","_disabled"];
    private _row = _list lnbAddRow _cells;
    _list lnbSetData [[_row,0],_marker];
    if (_disabled) then {
        for "_column" from 0 to 4 do {_list lnbSetColor [[_row,_column],[.55,.55,.55,1]]};
    };
    if (_marker == _selected) then {_selection = _row};
} forEach _rows;
_list lnbSetCurSelRow _selection;
_display setVariable ["mplus_contactListInit",false];
(_display displayCtrl MP_CONTACT_LIST_STATUS) ctrlSetText (if (_rows isEqualTo []) then {"No contact reports available."} else {format ["%1 reports | Click a row to open.",count _rows]});
