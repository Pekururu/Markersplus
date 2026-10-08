#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display",["_type",""]];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
if (_type == "") then {_type = _display getVariable ["mplus_selectedType",""]};
private _text = "No matching markers.";
private _name = "";
if (_type != "") then {
    private _config = configFile >> "CfgMarkers" >> _type;
    _name = getText (_config >> "name");
    _text = getText (_config >> "mplus_purpose");
    if (_text == "") then {_text = "Map icon. Choose a symbol to change its type."};
};
(_panel controlsGroupCtrl MP_PURPOSE_NAME) ctrlSetText _name;
(_panel controlsGroupCtrl MP_PURPOSE) ctrlSetText _text;

private _selectedType = _display getVariable ["mplus_selectedType",""];
private _favoriteButton = _panel controlsGroupCtrl MP_FAVORITE;
_favoriteButton setVariable ["mplus_type",_selectedType];
private _favorite = _selectedType in (profileNamespace getVariable ["mplus_favorites",[]]);
_favoriteButton ctrlSetText (["+","*"] select _favorite);
_favoriteButton ctrlSetTooltip (["Add selected symbol to favorites","Remove selected symbol from favorites"] select _favorite);
_favoriteButton ctrlEnable ((_selectedType find "mplus_") == 0);
