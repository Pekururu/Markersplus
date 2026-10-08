#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {[]};
private _type = _display getVariable ["mplus_selectedType",""];
if (_type == "") exitWith {[]};
private _size = parseNumber ctrlText (_panel controlsGroupCtrl MP_SIZE);
if (_size < 0.25 || {_size > 4}) exitWith {[]};
private _direction = parseNumber ctrlText (_panel controlsGroupCtrl MP_DIRECTION);
_direction = ((_direction % 360) + 360) % 360;
private _colors = _panel controlsGroupCtrl MP_COLOR;
private _channels = _panel controlsGroupCtrl MP_CHANNEL;
private _options = [_type,ctrlText (_panel controlsGroupCtrl MP_LABEL),_colors lbData (lbCurSel _colors),
    _size,_direction,_channels lbValue (lbCurSel _channels)];
_display setVariable ["mplus_selectedType",_type];
_options
