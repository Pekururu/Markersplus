// Shared screen-sized highlight: constant stroke and padding at every map zoom.
params ["_map","_position",["_marker",""]];
private _center = _map ctrlMapWorldToScreen _position;
if (count _center < 2) exitWith {};
private _width = 28;
private _height = 28;
private _angle = 0;
if (_marker != "" && {_marker in allMapMarkers}) then {
    private _size = getNumber (configFile >> "CfgMarkers" >> markerType _marker >> "size");
    private _scale = markerSize _marker;
    _width = _size * abs (_scale select 0);
    _height = _size * abs (_scale select 1);
    _angle = markerDir _marker;
};
// Fit the rotated icon's bounds, with twelve pixels of padding on each side.
private _extentX = abs (cos _angle) * _width + abs (sin _angle) * _height;
private _extentY = abs (sin _angle) * _width + abs (cos _angle) * _height;
private _radius = (0.5 * (_extentX max _extentY) + 12) max 28;
// Two adjacent one-pixel outlines give a medium stroke on Arma 2.14 as well.
{
    private _r = _radius + _x;
    private _corners = [[-1,-1],[1,-1],[1,1],[-1,1]] apply {
        _map ctrlMapScreenToWorld [
            (_center select 0) + (_x select 0) * _r * pixelW,
            (_center select 1) + (_x select 1) * _r * pixelH
        ]
    };
    for "_i" from 0 to 3 do {
        _map drawLine [_corners select _i,_corners select ((_i + 1) % 4),[1,0.85,0.15,1]];
    };
} forEach [-0.5,0.5];
