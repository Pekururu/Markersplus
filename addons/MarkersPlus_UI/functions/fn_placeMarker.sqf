#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display","_position",["_directionOverride",-1]];
private _panel = _display displayCtrl MP_PANEL;
private _options = [_display] call mplus_fnc_readOptions;
if (_options isEqualTo []) exitWith {
    [_display,false] call mplus_fnc_setPlacement;
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Choose a marker and size between 0.25 and 4.";
};
if (_directionOverride >= 0) then {_options set [4,_directionOverride]};
_options params ["_type","_text","_color","_size","_direction","_channel"];
if !([_channel] call mplus_fnc_channelAvailable) exitWith {
    [_display,false] call mplus_fnc_setPlacement;
    (_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Channel unavailable. Reopen the panel.";
};
// Native naming lets ACE move both shared and personal markers. Channel -2 in
// the name identifies a personal marker; it is still created/updated locally.
private _name = [_channel] call mplus_fnc_newMarkerName;
private _marker = if (_channel == -2) then {
    createMarkerLocal [_name,_position]
} else {
    createMarker [_name,_position,_channel,player]
};
if (_marker == "") exitWith {(_panel controlsGroupCtrl MP_STATUS) ctrlSetText "Marker could not be created."};
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal _type;
_marker setMarkerColorLocal _color;
_marker setMarkerSizeLocal [_size,_size];
_marker setMarkerDirLocal _direction;
private _copyStyle = _display getVariable ["mplus_duplicateStyle",[]];
if (_copyStyle isNotEqualTo []) then {
    _copyStyle params ["_originalSize","_fullSize","_alpha","_shadow"];
    if (_size == _originalSize) then {_marker setMarkerSizeLocal _fullSize};
    _marker setMarkerAlphaLocal _alpha;
    _marker setMarkerShadowLocal _shadow;
    if (_channel == -2 && {(_type find "mplus_") != 0}) then {
        private _personal = missionNamespace getVariable ["mplus_personalPlanIcons",[]];
        _personal pushBackUnique _marker;
        missionNamespace setVariable ["mplus_personalPlanIcons",_personal];
    };
};
if (_channel == -2) then {_marker setMarkerTextLocal _text} else {
    // One final global update broadcasts the complete configured marker state.
    _marker setMarkerText _text;
};
// Start the next placement with an empty label and north-facing direction.
_options set [1,""];
_options set [4,0];
missionNamespace setVariable ["mplus_lastOptions",_options];
(_panel controlsGroupCtrl MP_LABEL) ctrlSetText "";
(_panel controlsGroupCtrl MP_DIRECTION) ctrlSetText "0";
_display setVariable ["mplus_lastPlaced",diag_tickTime];
ace_markers_userPlacedMarkers pushBackUnique _marker;
[_marker] call mplus_fnc_syncAceMarker;
[_display,false] call mplus_fnc_setPlacement;
private _channels = _panel controlsGroupCtrl MP_CHANNEL;
private _audience = _channels lbText (lbCurSel _channels);
(_panel controlsGroupCtrl MP_STATUS) ctrlSetText format ["Placed: %1",_audience];
