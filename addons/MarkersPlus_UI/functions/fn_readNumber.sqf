params ["_text"];
private _chars = toArray _text;
if ((_chars param [0,0]) == 45) then {_chars deleteAt 0};
if (_chars isEqualTo [] || {_chars findIf {!(_x in [46,48,49,50,51,52,53,54,55,56,57])} >= 0} || {
    {_x == 46} count _chars > 1
} || {{_x >= 48 && {_x <= 57}} count _chars == 0}) exitWith {[]};
[parseNumber _text]
