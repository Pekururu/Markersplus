// Versioned, data-only format. Clipboard imports are parsed, never compiled.
params ["_plan",["_checkAssets",false]];
if !(_plan isEqualType [] && {count _plan == 4}) exitWith {"Invalid plan format."};
_plan params ["_version","_terrain","_name","_entries"];
if !(_version in [1,2] && {_terrain isEqualType ""} && {_terrain != ""} && {_name isEqualType ""} && {count _name > 0 && {count _name <= 80}} && {_entries isEqualType []}) exitWith {"Invalid plan header or unsupported version."};
if (count _entries == 0 || {count _entries > 5000}) exitWith {"A plan must contain 1 to 5000 markers."};
private _error = "";
{
    private _length = [11,12] select (_version == 2);
    if !(_x isEqualType [] && {count _x == _length}) exitWith {_error = "Invalid marker record."};
    _x params ["_alpha","_brush","_color","_dir","_line","_pos","_shadow","_shape","_size","_text","_type"];
    if !(_alpha isEqualType 0 && {_dir isEqualType 0} && {_shadow isEqualType true} && {_brush isEqualType ""} && {_color isEqualType ""} && {_text isEqualType ""} && {_type isEqualType ""} && {_shape in ["ICON","RECTANGLE","ELLIPSE","POLYLINE"]}) exitWith {_error = "Invalid marker properties."};
    if !(_pos isEqualType [] && {count _pos in [2,3]} && {_pos findIf {!(_x isEqualType 0) || {!finite _x}} < 0} && {_size isEqualType []} && {count _size == 2} && {_size findIf {!(_x isEqualType 0) || {!finite _x} || {_x < 0}} < 0} && {_line isEqualType []} && {count _line <= 20000} && {_line findIf {!(_x isEqualType 0) || {!finite _x}} < 0} && {finite _alpha} && {finite _dir} && {_alpha >= 0 && {_alpha <= 1}}) exitWith {_error = "Invalid marker coordinates or size."};
    if (_shape == "POLYLINE" && {count _line < 4 || {count _line % 2 != 0}}) exitWith {_error = "Invalid line coordinates."};
    if (_version == 2) then {
        private _contact = _x select 11;
        if !(_contact isEqualType []) exitWith {_error = "Invalid contact record."};
        if (_contact isNotEqualTo [] && {_shape != "ICON" || {!([_contact] call mplus_fnc_validateContact)}}) exitWith {
            _error = "Invalid contact report in this plan.";
        };
    };
    if (_error != "") exitWith {};
    if (_checkAssets) then {
        if (_shape == "ICON" && {!isClass (configFile >> "CfgMarkers" >> _type)}) exitWith {_error = format ["Missing marker type: %1. Load its addon first.",_type]};
        if (!isClass (configFile >> "CfgMarkerColors" >> _color)) exitWith {_error = format ["Missing colour: %1.",_color]};
        if (_shape in ["RECTANGLE","ELLIPSE"] && {!isClass (configFile >> "CfgMarkerBrushes" >> _brush)}) exitWith {_error = format ["Missing area brush: %1.",_brush]};
    };
    if (_error != "") exitWith {};
} forEach _entries;
_error
