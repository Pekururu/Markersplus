#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (_display getVariable ["mplus_initializing",true]) exitWith {};
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
private _grid = _panel controlsGroupCtrl MP_GRID;
private _selected = _display getVariable ["mplus_selectedType","mplus_aapoint"];
private _search = toLower ctrlText (_panel controlsGroupCtrl MP_SEARCH);
private _categories = _panel controlsGroupCtrl MP_CATEGORY;
private _category = _categories lbData (lbCurSel _categories);
{if (!isNull _x) then {ctrlDelete _x}} forEach (_display getVariable ["mplus_gridTiles",[]]);
private _markers = (missionNamespace getVariable ["mplus_markerLibrary",[]]) select {
    _x params ["_sortName","_class","_name","_icon","_markerCategory"];
    (_category == "" || {_category == _markerCategory} || {_category == "favorites" && {_class in (profileNamespace getVariable ["mplus_favorites",[]])}}) && {
        _search == "" || {(_sortName find _search) >= 0} || {(toLower _class find _search) >= 0}
    }
};
// Filtering while editing must not silently choose and save another symbol.
if ((_display getVariable ["mplus_selectedMarker",""]) == "" && {_markers findIf {(_x select 1) == _selected} < 0}) then {
    _selected = if (_markers isEqualTo []) then {""} else {(_markers select 0) select 1};
};
_display setVariable ["mplus_selectedType",_selected];
private _tiles = [];
{
    _x params ["_sortName","_class","_name","_icon"];
    private _tile = _display ctrlCreate ["mplus_IconTile",-1,_grid];
    _tile setVariable ["mplus_type",_class];
    _tile ctrlSetText _icon;
    private _favorite = _class in (profileNamespace getVariable ["mplus_favorites",[]]);
    _tile ctrlSetTooltip format ["%1%2 | Right-click to %3 favorite",if (_favorite) then {"* "} else {""},_name,if (_favorite) then {"remove"} else {"add"}];
    if (_favorite) then {_tile ctrlSetTextColor [1,0.85,0.35,1]};
    _tile ctrlSetPosition [(_forEachIndex % 5) * 0.042 * safeZoneW,
        floor (_forEachIndex / 5) * 0.050 * safeZoneH,0.038 * safeZoneW,0.046 * safeZoneH];
    _tile ctrlCommit 0;
    if (_class == _selected) then {_tile ctrlSetBackgroundColor [0.40,0.32,0.10,1]};
    _tile ctrlAddEventHandler ["MouseButtonDown",{
        params ["_tile","_button"];
        if (_button != 1) exitWith {false};
        [_tile] call mplus_fnc_toggleFavorite;
        true
    }];
    _tile ctrlAddEventHandler ["ButtonClick",{_this call mplus_fnc_chooseSymbol}];
    _tile ctrlAddEventHandler ["MouseEnter",{
        private _tile = _this select 0;
        [ctrlParent _tile,_tile getVariable ["mplus_type",""]] call mplus_fnc_showPurpose;
    }];
    _tile ctrlAddEventHandler ["MouseExit",{[ctrlParent (_this select 0)] call mplus_fnc_showPurpose}];
    _tiles pushBack _tile;
} forEach _markers;
_display setVariable ["mplus_gridTiles",_tiles];
// Filtering must not disable duplicating a selected personal vanilla icon.
(_panel controlsGroupCtrl MP_PLACE) ctrlEnable (_selected != "");
private _empty = _panel controlsGroupCtrl MP_GRID_EMPTY;
_empty ctrlShow (_tiles isEqualTo []);
_empty ctrlSetText (if (_category == "favorites" && {_search == ""}) then {
    (["No favorites yet.","Choose All markers and right-click an icon to add it."] joinString toString [10])
} else {(["No matching markers.","Clear the search or choose another category."] joinString toString [10])});
if (_tiles isNotEqualTo []) then {
    private _hint = if ((_display getVariable ["mplus_selectedMarker",""]) != "") then {
        "Edits save automatically. Alt-drag moves."
    } else {
        if (_display getVariable ["mplus_placing",false]) then {"Click places; hold + drag rotates. Esc cancels."} else {"Choose an icon, then click the map."}
    };
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText _hint;
} else {
    [_display,false] call mplus_fnc_setPlacement;
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText (if ((_display getVariable ["mplus_selectedMarker",""]) != "") then {"Edits save automatically. Duplicate copies this marker."} else {"Right-click an icon to toggle favorites."});
};
[_display] call mplus_fnc_showPurpose;
