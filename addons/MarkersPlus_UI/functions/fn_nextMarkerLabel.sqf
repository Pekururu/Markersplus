// Increment a trailing whole number without losing leading zeros or precision.
params ["_label"];
if (_label == "") exitWith {["1"]};
private _chars = toArray _label;
private _start = count _chars;
while {_start > 0 && {(_chars select (_start - 1)) in [48,49,50,51,52,53,54,55,56,57]}} do {
    _start = _start - 1;
};
if (_start == count _chars) exitWith {[]};
private _carry = true;
for "_i" from (count _chars - 1) to _start step -1 do {
    if (_carry) then {
        private _digit = _chars select _i;
        if (_digit == 57) then {_chars set [_i,48]} else {
            _chars set [_i,_digit + 1];
            _carry = false;
        };
    };
};
if (_carry) then {_chars insert [_start,[49]]};
private _next = toString _chars;
if (count _next > 100) exitWith {[]};
[_next]
