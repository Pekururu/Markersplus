// Shared cleanup for report deletion, load rollback and Undo load.
params ["_marker","_channel"];
(missionNamespace getVariable ["mplus_contactRecords",createHashMap]) deleteAt _marker;
if (_channel != -2 && {[_marker] call mplus_fnc_isContactName}) then {
    ["mplus_contactPublish",[player,_marker,[],_channel]] call CBA_fnc_serverEvent;
};
