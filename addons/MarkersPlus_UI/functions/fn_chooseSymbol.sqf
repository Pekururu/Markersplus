#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_tile"];
private _display = ctrlParent _tile;
if (_display getVariable ["mplus_initializing",true]) exitWith {};
private _type = _tile getVariable ["mplus_type",""];
if (_type == "") exitWith {};
_display setVariable ["mplus_selectedType",_type];
{
    private _selected = (_x getVariable ["mplus_type",""]) == _type;
    _x ctrlSetBackgroundColor ([[0.14,0.15,0.16,1],[0.40,0.32,0.10,1]] select _selected);
} forEach (_display getVariable ["mplus_gridTiles",[]]);
[_display,_type] call mplus_fnc_showPurpose;
if ((_display getVariable ["mplus_selectedMarker",""]) == "") then {
    _display setVariable ["mplus_duplicateStyle",[]];
    (_display displayCtrl MP_PANEL controlsGroupCtrl MP_TITLE) ctrlSetText "Markers";
    [_display,true] call mplus_fnc_setPlacement;
} else {[_display] call mplus_fnc_liveEdit};
