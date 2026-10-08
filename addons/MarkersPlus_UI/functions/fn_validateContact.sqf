params ["_record"];
if !(_record isEqualType [] && {count _record == 12}) exitWith {false};
_record params ["_version","_type","_count","_activity","_affiliation","_accuracy","_movement","_note","_time","_reporter","_origin","_date"];
_version isEqualTo 1 && {_type in ((call mplus_fnc_contactTypes) apply {_x select 0})} &&
{_count isEqualType "" && {_count == "" || {count _count <= 4 && {((toArray _count) findIf {_x < 48 || {_x > 57}}) < 0}}}} &&
{_activity in ["Unknown","Stationary","Moving","Firing"]} && {_affiliation in ["Unknown","Friendly","Hostile","Civilians"]} &&
{_accuracy in ["Estimated","Precise"]} && {_movement in ["Unknown","N","NE","E","SE","S","SW","W","NW"]} &&
{_note isEqualType "" && {count _note <= 200}} && {_reporter isEqualType "" && {count _reporter <= 200}} &&
{_time isEqualType "" && {count _time == 5} && {(_time select [2,1]) == ":"} &&
{(toArray ((_time select [0,2]) + (_time select [3,2]))) findIf {_x < 48 || {_x > 57}} < 0} &&
{parseNumber (_time select [0,2]) < 24} && {parseNumber (_time select [3,2]) < 60}} &&
{_origin isEqualType [] && {count _origin in [2,3]} && {_origin findIf {!(_x isEqualType 0) || {!finite _x}} < 0}} &&
{_date isEqualType [] && {count _date == 5} && {_date findIf {!(_x isEqualType 0) || {!finite _x}} < 0}}
