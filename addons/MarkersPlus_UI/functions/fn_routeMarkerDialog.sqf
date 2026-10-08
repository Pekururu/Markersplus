disableSerialization;
params ["_dialog"];
private _mapDisplay = displayParent _dialog;
if (isNull _mapDisplay || {ctrlIDD _mapDisplay != 12}) exitWith {false};
private _mouseOver = ctrlMapMouseOver (_mapDisplay displayCtrl 51);
if ((_mouseOver param [0,""]) != "marker") exitWith {false};
private _marker = _mouseOver param [1,""];
if !([_marker] call mplus_fnc_isOwnMarker || {[_marker] call mplus_fnc_isContact}) exitWith {false};
_dialog setVariable ["mplus_routed",true];
[{
    params ["_dialog","_marker"];
    if (!isNull _dialog) then {_dialog closeDisplay 2};
    if (visibleMap && {[_marker] call mplus_fnc_isContact}) exitWith {[_marker] call mplus_fnc_openContacts};
    if (visibleMap && {[_marker] call mplus_fnc_isOwnMarker}) then {
        [true] call mplus_fnc_togglePanel;
        [findDisplay 12,_marker] call mplus_fnc_selectMarker;
    };
},[_dialog,_marker]] call CBA_fnc_execNextFrame;
true
