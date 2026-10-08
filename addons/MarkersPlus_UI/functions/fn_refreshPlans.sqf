#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display",["_rebuildTerrains",true]];
_display setVariable ["mplus_plansInit",true];
private _plans = call mplus_fnc_savedPlans;
private _terrainControl = _display displayCtrl MP_PLAN_TERRAIN;
private _terrain = _display getVariable ["mplus_planSelectTerrain",_terrainControl lbData (lbCurSel _terrainControl)];
_display setVariable ["mplus_planSelectTerrain",nil];
if (_terrain == "") then {_terrain = worldName};
if (_rebuildTerrains) then {
    private _terrains = [worldName];
    {_terrains pushBackUnique (_x select 1)} forEach _plans;
    _terrains sort true;
    lbClear _terrainControl;
    {
        private _label = getText (configFile >> "CfgWorlds" >> _x >> "description");
        if (_label == "") then {_label = _x};
        if (_x == worldName) then {_label = _label + " (current)"};
        private _row = _terrainControl lbAdd _label;
        _terrainControl lbSetData [_row,_x];
        if (_x == _terrain) then {_terrainControl lbSetCurSel _row};
    } forEach _terrains;
    if (lbCurSel _terrainControl < 0) then {_terrainControl lbSetCurSel (_terrains find worldName)};
};
_terrain = _terrainControl lbData (lbCurSel _terrainControl);
private _list = _display displayCtrl MP_PLAN_LIST;
private _selectedName = _display getVariable ["mplus_planSelectName",_list lbData (lbCurSel _list)];
_display setVariable ["mplus_planSelectName",nil];
lbClear _list;
private _rows = [];
{if ((_x select 1) == _terrain) then {_rows pushBack [toLower (_x select 2),_forEachIndex]}} forEach _plans;
_rows sort true;
{
    private _index = _x select 1;
    private _plan = _plans select _index;
    private _row = _list lbAdd format ["%1 (%2)",_plan select 2,count (_plan select 3)];
    _list lbSetValue [_row,_index];
    _list lbSetData [_row,_plan select 2];
    if ((_plan select 2) == _selectedName) then {_list lbSetCurSel _row};
} forEach _rows;
if (lbCurSel _list < 0 && {lbSize _list > 0}) then {_list lbSetCurSel 0};
private _empty = _display displayCtrl 81117;
_empty ctrlShow (lbSize _list == 0);
_empty ctrlSetText (["No saved plans on this terrain.","Place your markers, enter a name below, then Save map.","You can also import a plan from the clipboard."] joinString toString [10]);
private _channels = _display displayCtrl MP_PLAN_CHANNEL;
if (lbSize _channels == 0) then {
    {
        _x params ["_label","_channel"];
        if ([_channel] call mplus_fnc_channelAvailable) then {
            private _row = _channels lbAdd _label;
            _channels lbSetValue [_row,_channel];
        };
    } forEach [["Local only (you)",-2],["Side",1],["Group",3],["Command",2],["Vehicle",4],["Global (everyone)",0]];
    _channels lbSetCurSel 0;
};
(_display displayCtrl 81111) ctrlEnable (_terrain == worldName && {lbSize _list > 0});
(_display displayCtrl 81112) ctrlEnable ((missionNamespace getVariable ["mplus_lastPlanLoad",[]]) isNotEqualTo []);
(_display displayCtrl 81114) ctrlEnable (lbSize _list > 0);
(_display displayCtrl 81115) ctrlEnable (lbSize _list > 0);
_display setVariable ["mplus_plansInit",false];
[_display,"select"] call mplus_fnc_planAction;
