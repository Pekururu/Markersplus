// Identification describes reported allegiance, independent of the observer's game faction.
params ["_record"];
private _types = call mplus_fnc_contactTypes;
private _index = _types findIf {(_x select 0) == (_record select 1)};
private _definition = _types select (_index max 0);
private _type = "mil_unknown";
private _color = "ColorUnknown";
switch (_record select 4) do {
    case "Friendly": {
        _type = "b_" + (_definition select 3);
        _color = "ColorBLUFOR";
    };
    case "Hostile": {
        _type = "o_" + (_definition select 3);
        _color = "ColorOPFOR";
    };
    case "Civilians": {
        // Use civilian frames, retaining specialised military types in the label.
        _type = _definition select 4;
        _color = "ColorCivilian";
    };
};
// Fall back safely if the running game's marker set lacks a specialised symbol.
if (!isClass (configFile >> "CfgMarkers" >> _type)) then {
    _type = switch (_record select 4) do {
        case "Friendly": {"b_unknown"};
        case "Hostile": {"o_unknown"};
        case "Civilians": {"c_unknown"};
        default {"mil_unknown"};
    };
};
if (_record param [12,false]) then {_color = "Color6_FD_F"};
[_type,_color]
