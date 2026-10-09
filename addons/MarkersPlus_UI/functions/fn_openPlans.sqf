#include "\markersplus_ui\script_component.hpp"
disableSerialization;
if (!hasInterface || {isNull player} || {dialog}) exitWith {};
private _display = findDisplay 12;
if (!isNull _display) then {
    [_display] call mplus_fnc_liveEdit;
    [_display,false] call mplus_fnc_setPlacement;
    _display setVariable ["mplus_mouseDown",[]];
};
createDialog "mplus_Plans";
[(findDisplay MP_PLANS_DISPLAY) displayCtrl MP_PLAN_CONTROLS,"plans"] call mplus_fnc_controlsHint;
