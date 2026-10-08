// CfgMarkerColors uses scope 1 for public entries, unlike CfgMarkers.
private _colors = [];
{
    private _name = getText (_x >> "name");
    if (_name == "") then {_name = configName _x};
    _colors pushBack [configName _x,_name];
} forEach ("getNumber (_x >> 'scope') > 0 && {count getArray (_x >> 'color') == 4}" configClasses (configFile >> "CfgMarkerColors"));
_colors
