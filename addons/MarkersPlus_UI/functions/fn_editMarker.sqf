#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display","_action",["_options",[]]];
private _panel = _display displayCtrl MP_PANEL;
if (isNull _panel) exitWith {};
private _marker = _display getVariable ["mplus_selectedMarker",""];
if !([_marker] call mplus_fnc_isOwnMarker) exitWith {
    [_display,""] call mplus_fnc_selectMarker;
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Marker no longer available. Select another.";
};
private _local = [_marker] call mplus_fnc_isLocalMarker;
private _channel = if (_local) then {-2} else {parseNumber ((_marker splitString "/") select 2)};
if !([_channel] call mplus_fnc_channelAvailable) exitWith {
    [_display,false] call mplus_fnc_setPlacement;
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Original sharing channel is unavailable.";
};
switch _action do {
    case "duplicate": {
        [_display] call mplus_fnc_liveEdit;
        // Copy the current saved properties, including appearance not exposed by the panel.
        [_display,_marker] call mplus_fnc_selectMarker;
        private _style = [(markerSize _marker) select 0,+(markerSize _marker),markerAlpha _marker,markerShadow _marker];
        private _options = [_display] call mplus_fnc_readOptions;
        if (_options isEqualTo []) exitWith {
            (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Choose a size between 0.25 and 4 to duplicate this marker.";
        };
        [_display,""] call mplus_fnc_selectMarker;
        _display setVariable ["mplus_duplicateStyle",_style];
        [_display,true] call mplus_fnc_setPlacement;
        (_panel controlsGroupCtrl MP_TITLE) ctrlSetText "MarkersPlus: Copy";
        (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Click to place the copy. Hold + drag rotates. Esc cancels.";
    };
    case "update": {
        if (_options isEqualTo []) exitWith {};
        _options params ["_type","_text","_color","_size","_direction"];
        _marker setMarkerTypeLocal _type;
        _marker setMarkerColorLocal _color;
        _marker setMarkerSizeLocal [_size,_size];
        _marker setMarkerDirLocal _direction;
        if (_local) then {_marker setMarkerTextLocal _text} else {_marker setMarkerText _text};
        [_marker] call mplus_fnc_syncAceMarker;
        (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Changes saved automatically. Alt-drag moves.";
    };
    case "delete": {
        if (_local) then {deleteMarkerLocal _marker} else {deleteMarker _marker};
        [_display,""] call mplus_fnc_selectMarker;
        (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Marker deleted.";
    };
};
