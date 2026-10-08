#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
private _editing = (_display getVariable ["mplus_selectedMarker",""]) != "";
// Keep the footer anchored. Only reserve the action row when it is visible.
private _labelY = [0.412,0.376] select _editing;
private _colorY = _labelY + 0.052;
private _sizeY = _colorY + 0.052;
private _descriptionY = _labelY - 0.040;
private _nameY = _descriptionY - 0.023;
{
    _x params ["_id","_y"];
    private _control = _panel controlsGroupCtrl _id;
    private _position = ctrlPosition _control;
    _position set [1,_y * safeZoneH];
    _control ctrlSetPosition _position;
    _control ctrlCommit 0;
} forEach [
    [MP_FAVORITE,_nameY],[MP_PURPOSE_NAME,_nameY],[MP_PURPOSE,_descriptionY],
    [MP_LABEL_TITLE,_labelY],[MP_LABEL,_labelY],
    [MP_COLOR_TITLE,_colorY - 0.022],[MP_CHANNEL_TITLE,_colorY - 0.022],
    [MP_COLOR,_colorY],[MP_CHANNEL,_colorY],
    [MP_SIZE_TITLE,_sizeY - 0.022],[MP_DIRECTION_TITLE,_sizeY - 0.022],
    [MP_SIZE,_sizeY],[MP_DIRECTION,_sizeY]
];
private _grid = _panel controlsGroupCtrl MP_GRID;
private _position = ctrlPosition _grid;
_position set [3,(_nameY - 0.008 - 0.086) * safeZoneH];
_grid ctrlSetPosition _position;
_grid ctrlCommit 0;
