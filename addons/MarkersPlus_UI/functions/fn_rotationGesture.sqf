#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_map","_mouse"];
private _display = ctrlParent _map;
private _down = _display getVariable ["mplus_mouseDown",[]];
if (count _down < 5 || {!(_display getVariable ["mplus_placing",false])} || {_down select 4 != ""} || {diag_tickTime - (_down select 2) < (missionNamespace getVariable ["mplus_rotationDelay",0.3])}) exitWith {[]};
private _anchor = _down select 3;
private _cursor = _map ctrlMapScreenToWorld _mouse;
private _center = _map ctrlMapWorldToScreen _anchor;
private _pixels = [((_mouse select 0) - (_center select 0)) / pixelW,
    ((_mouse select 1) - (_center select 1)) / pixelH];
private _panel = _display displayCtrl MP_PANEL;
private _direction = parseNumber ctrlText (_panel controlsGroupCtrl MP_DIRECTION);
// Ignore tiny movements around the pivot, where the bearing is unstable.
if (_pixels distance2D [0,0] >= 6) then {
    _direction = ((_cursor select 0) - (_anchor select 0)) atan2 ((_cursor select 1) - (_anchor select 1));
};
[_anchor,((_direction % 360) + 360) % 360]
