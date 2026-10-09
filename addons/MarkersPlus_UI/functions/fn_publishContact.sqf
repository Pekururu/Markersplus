// Protect local submissions from snapshots taken before the server accepted them.
params ["_marker","_record","_channel"];
if (_channel == -2) exitWith {};
(missionNamespace getVariable ["mplus_contactPending",createHashMap]) set [_marker,+_record];
["mplus_contactPublish",[player,_marker,_record,_channel]] call CBA_fnc_serverEvent;
