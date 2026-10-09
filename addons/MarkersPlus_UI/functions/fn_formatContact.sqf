// Return [short map label, full readable report]. Values are player-entered observations.
params ["_record","_position"];
_record params ["_version","_type","_count","_activity","_affiliation","_accuracy","_movement","_note","_time","_reporter","_origin","_date"];
private _civilianPeople = _affiliation == "Civilians" && {_type == "Infantry"};
private _types = call mplus_fnc_contactTypes;
private _index = _types findIf {(_x select 0) == _type};
private _definition = _types select (_index max 0);
private _description = if (_civilianPeople) then {"people"} else {toLower (_definition select 1)};
private _quantity = if (_count == "") then {"Count unknown"} else {_count};
private _labelType = _definition select 2;
if (_civilianPeople) then {_labelType = "PERS"};
private _hasNote = (toArray _note) findIf {!(_x in [9,10,13,32])} >= 0;
if (_hasNote) then {_labelType = _labelType + "*"};
private _activityText = if (_activity == "Unknown") then {"Activity unknown"} else {_activity};
if (_activity == "Moving" && {_movement != "Unknown"}) then {_activityText = _activityText + " " + _movement};
// The marker's colour/frame carries identification; text carries the observation.
private _labelParts = [format ["%1 %2",if (_count == "") then {"?"} else {_count},_labelType]];
private _labelActivity = switch _activity do {
    case "Stationary": {"STATIC"};
    case "Moving": {if (_movement == "Unknown") then {"MOV"} else {"MOV " + _movement}};
    case "Firing": {"FIRING"};
    default {""};
};
if (_labelActivity != "") then {_labelParts pushBack _labelActivity};
_labelParts pushBack _time;
if (_record param [12,false]) then {_labelParts pushBack "DISABLED"};
private _label = _labelParts joinString " | ";
private _bearing = round (_origin getDir _position);
_bearing = _bearing % 360;
private _bearingText = str _bearing;
while {count _bearingText < 3} do {_bearingText = "0" + _bearingText};
private _distance = 50 * round ((_origin distance2D _position) / 50);
private _lines = [format ["Contact: %1 %2. Identification: %3.",_quantity,_description,toLower _affiliation],
    format ["Grid %1. %2. Position %3.",mapGridPosition _position,_activityText,toLower _accuracy],
    format ["Observed %1 (mission time), %2-%3-%4.",_time,_date select 0,_date select 1,_date select 2],
    format ["Reporter: %1.",_reporter],
    format ["Map bearing %1 degrees | approx. %2 m from reporter's recorded grid %3.",_bearingText,_distance,mapGridPosition _origin]];
if (_hasNote) then {_lines pushBack ("Note: " + _note)};
if (_record param [12,false]) then {_lines insert [0,["Status: DISABLED. Contact marked as taken care of."]]};
[toUpper _label,toUpper (_lines joinString toString [10])]
