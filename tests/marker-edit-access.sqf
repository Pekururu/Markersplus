// Run on a client with Execute Local after loading the rebuilt mod.
// Creates temporary Side-channel markers, reports failures, then cleans up.
private _ownID = getPlayerID player;
private _foreignID = "123456789";
if (_foreignID == _ownID) then {_foreignID = "123456788"};
private _serial = 9000000 + floor random 100000;
private _failures = [];
{
    _x params ["_label", "_ownerID", "_channel", "_type", "_native", "_expected", ["_suffix", ""]];
    private _name = format ["_USER_DEFINED #%1/%2/%3", _ownerID, (_serial + _forEachIndex) toFixed 0, _channel];
    if (!_native) then {_name = "mplus_access_test_" + _name};
    _name = _name + _suffix;
    private _marker = if (_channel == -2) then {
        createMarkerLocal [_name, getPosATL player]
    } else {
        createMarker [_name, getPosATL player, _channel, player]
    };
    _marker setMarkerTypeLocal _type;
    private _actual = [_marker] call mplus_fnc_canEditMarker;
    if (_marker == "" || {_actual != _expected}) then {_failures pushBack _label};
    if (_channel == -2) then {deleteMarkerLocal _marker} else {deleteMarker _marker};
} forEach [
    ["own shared", _ownID, 1, "mplus_aapoint", true, [1] call mplus_fnc_channelAvailable],
    ["foreign shared", _foreignID, 1, "mplus_aapoint", true, [1] call mplus_fnc_channelAvailable],
    ["own personal", _ownID, -2, "mplus_aapoint", true, true],
    ["foreign personal", _foreignID, -2, "mplus_aapoint", true, false],
    ["vanilla icon", _ownID, 1, "mil_dot", true, false],
    ["mission icon", _ownID, 1, "mplus_aapoint", false, false],
    ["contact uses separate permissions", _foreignID, 1, "mplus_aapoint", true, false, "/MP_CONTACT"]
];
if (["mplus_missing_access_test"] call mplus_fnc_canEditMarker) then {_failures pushBack "missing marker"};
hint format ["Marker access failures: %1", _failures];
diag_log format ["[Markersplus] Marker access failures: %1", _failures];
_failures
