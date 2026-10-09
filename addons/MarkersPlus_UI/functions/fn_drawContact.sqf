#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_map"];
private _display = ctrlParent _map;
private _panel = _display displayCtrl MP_CONTACT_PANEL;
if (!visibleMap || {isNull _panel}) exitWith {};
private _selected = _display getVariable ["mplus_contactSelected",""];
if (_selected != "" && {!(_selected in allMapMarkers)}) exitWith {
    [_display] call mplus_fnc_closeContacts;
};
// Newly arrived/updated shared details refresh a read-only view. Unsubmitted own drafts stay intact.
if (_selected != "") then {
    private _record = (missionNamespace getVariable ["mplus_contactRecords",createHashMap]) getOrDefault [_selected,[]];
    private _loaded = _display getVariable ["mplus_contactLoaded",[]];
    if (_record isNotEqualTo [] && {_record isNotEqualTo _loaded} && {
        _display getVariable ["mplus_contactMissing",false] || {!(_display getVariable ["mplus_contactEditable",false])}
    }) exitWith {
        if !(_display getVariable ["mplus_contactReload",false]) then {
            _display setVariable ["mplus_contactReload",true];
            [{params ["_display","_marker"]; if (!isNull _display) then {
                _display setVariable ["mplus_contactReload",false];
                if (!isNull (_display displayCtrl MP_CONTACT_PANEL) && {(_display getVariable ["mplus_contactSelected",""]) == _marker}) then {[_marker] call mplus_fnc_openContacts};
            }},[_display,_selected]] call CBA_fnc_execNextFrame;
        };
    };
    if !(_display getVariable ["mplus_contactPositionDirty",false]) then {_display setVariable ["mplus_contactPosition",markerPos _selected]};
};
// Poll only input changes; catches paste/cut without rebuilding text every frame.
private _inputs = [
    _display getVariable ["mplus_contactPosition",[]],
    ctrlText (_display displayCtrl MP_CONTACT_COUNT),ctrlText (_display displayCtrl MP_CONTACT_NOTE),
    cbChecked (_display displayCtrl MP_CONTACT_ESTIMATE),
    ctrlText (_display displayCtrl MP_CONTACT_TIME)
];
{
    private _control = _display displayCtrl _x;
    _inputs pushBack lbCurSel _control;
} forEach [MP_CONTACT_TYPE,MP_CONTACT_ACTIVITY,MP_CONTACT_CHANNEL,MP_CONTACT_AFFILIATION,MP_CONTACT_ACCURACY,MP_CONTACT_MOVEMENT];
if (_inputs isNotEqualTo (_display getVariable ["mplus_contactInputs",[]])) then {
    _display setVariable ["mplus_contactInputs",_inputs]; [_display] call mplus_fnc_refreshContact;
};
private _position = _display getVariable ["mplus_contactPosition",[]];
if (_display getVariable ["mplus_contactPicking",false]) then {
    private _mouse = getMousePosition;
    (ctrlPosition _panel) params ["_px","_py","_pw","_ph"];
    private _list = _display displayCtrl MP_CONTACT_LIST_PANEL;
    private _overList = false;
    if (!isNull _list && {ctrlShown _list}) then {
        (ctrlPosition _list) params ["_lx","_ly","_lw","_lh"];
        _overList = _mouse select 0 >= _lx && {_mouse select 0 <= _lx+_lw} && {_mouse select 1 >= _ly} && {_mouse select 1 <= _ly+_lh};
    };
    (ctrlPosition _map) params ["_mx","_my","_mw","_mh"];
    if (!_overList && {_mouse select 0 >= _mx} && {_mouse select 0 <= _mx+_mw} && {_mouse select 1 >= _my} && {_mouse select 1 <= _my+_mh} && {
        !(_mouse select 0 >= _px && {_mouse select 0 <= _px+_pw} && {_mouse select 1 >= _py} && {_mouse select 1 <= _py+_ph})
    }) then {
        _map drawIcon [getText (configFile >> "CfgMarkers" >> "mil_unknown" >> "icon"),[1,0.85,0.15,.7],
            _map ctrlMapScreenToWorld _mouse,28,28,0,"Choose contact position",0,.025,"RobotoCondensed","right"];
    };
};
if (_position isNotEqualTo []) then {
    [_map,_position,_selected] call mplus_fnc_drawSelection;
};
