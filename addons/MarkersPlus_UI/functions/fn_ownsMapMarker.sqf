// Ownership only: applies to icons, areas and native drawn polylines.
params ["_marker"];
if !(_marker in allMapMarkers) exitWith {false};
private _owners = [str clientOwner];
private _playerID = getPlayerID player;
if (_playerID != "-1") then {_owners pushBackUnique _playerID};
(_marker find format ["mplus_local_%1_",clientOwner]) == 0 || {
    _owners findIf {(_marker find format ["_USER_DEFINED #%1/",_x]) == 0} >= 0
}
