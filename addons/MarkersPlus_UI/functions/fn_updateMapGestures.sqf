#include "\markersplus_ui\script_component.hpp"
disableSerialization;
// ACE map gestures are optional. Suppress their local runtime gate, without
// writing CBA settings or removing ACE's input handlers.
if (!hasInterface || {isNil "ace_map_gestures_enabled"}) exitWith {};
private _display = findDisplay 12;
private _active = !isNull findDisplay MP_PLANS_DISPLAY;
if (!_active && {visibleMap} && {!isNull _display}) then {
    _active = [MP_PANEL,MP_CONTACT_PANEL,MP_CONTACT_LIST_PANEL] findIf {
        private _panel = _display displayCtrl _x;
        !isNull _panel && {ctrlShown _panel}
    } >= 0;
};
private _paused = missionNamespace getVariable ["mplus_mapGesturesPaused",false];
_active = _active && {missionNamespace getVariable ["mplus_pauseGestures",true]};
if (!_active && {!_paused}) exitWith {};
if (_active) then {
    if (!_paused) then {
        missionNamespace setVariable ["mplus_mapGesturesPrevious",ace_map_gestures_enabled];
        missionNamespace setVariable ["mplus_mapGesturesPaused",true];
        private _handle = [{call mplus_fnc_updateMapGestures},0] call CBA_fnc_addPerFrameHandler;
        missionNamespace setVariable ["mplus_mapGesturesHandle",_handle];
    };
    ace_map_gestures_enabled = false;
} else {
    // Read the effective CBA value so a setting changed during editing is honoured.
    private _configured = ["ace_map_gestures_enabled"] call CBA_settings_fnc_get;
    ace_map_gestures_enabled = if (isNil "_configured") then {
        missionNamespace getVariable ["mplus_mapGesturesPrevious",false]
    } else {_configured};
    missionNamespace setVariable ["mplus_mapGesturesPaused",false];
    [missionNamespace getVariable ["mplus_mapGesturesHandle",-1]] call CBA_fnc_removePerFrameHandler;
    missionNamespace setVariable ["mplus_mapGesturesHandle",-1];
};
// Never resume an old held gesture. A fresh map click starts the next one.
ace_map_gestures_EnableTransmit = false;
private _unit = missionNamespace getVariable ["ACE_player",player];
if (!isNull _unit && {!isNil {_unit getVariable "ace_map_gestures_pointPosition"}}) then {
    _unit setVariable ["ace_map_gestures_pointPosition",nil,true];
};
