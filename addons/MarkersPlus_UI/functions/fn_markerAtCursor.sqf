disableSerialization;
params ["_map",["_mouse",getMousePosition]];
private _closest = "";
private _distance = 1e10;
{
    if (([_x] call mplus_fnc_isOwnMarker || {[_x] call mplus_fnc_isContact && {
        [_x] call mplus_fnc_ownsMapMarker || {_x in (missionNamespace getVariable ["mplus_contactRecords",createHashMap])}
    }}) && {markerAlpha _x > 0}) then {
        private _screen = _map ctrlMapWorldToScreen (markerPos _x);
        private _pixels = [((_mouse select 0) - (_screen select 0)) / pixelW,
            ((_mouse select 1) - (_screen select 1)) / pixelH];
        private _d = _pixels distance2D [0,0];
        private _radius = 6 + 0.5 * getNumber (configFile >> "CfgMarkers" >> markerType _x >> "size") * (selectMax (markerSize _x));
        if (_d < _radius && {_d < _distance}) then {_closest = _x; _distance = _d};
    };
} forEach allMapMarkers;
_closest
