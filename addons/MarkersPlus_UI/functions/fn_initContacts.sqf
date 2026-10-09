// Register server handlers before the UI's hasInterface guard, including dedicated servers.
if (isServer) then {
    missionNamespace setVariable ["mplus_contactServer",createHashMap];
    missionNamespace setVariable ["mplus_contactServerRevision",0];
    ["mplus_contactPublish",{
        params ["_unit","_marker","_record","_channel"];
        if (isNull _unit || {!isPlayer _unit} || {!(_channel in [0,1,2,3,4])}) exitWith {};
        if !([_marker] call mplus_fnc_isContactName) exitWith {};
        private _cache = missionNamespace getVariable ["mplus_contactServer",createHashMap];
        private _previous = _cache getOrDefault [_marker,[]];
        private _creator = (_marker find format ["_USER_DEFINED #%1/",owner _unit]) == 0 || {
            (_marker find format ["_USER_DEFINED #%1/",getPlayerID _unit]) == 0
        };
        private _allowed = if (_previous isEqualTo []) then {_creator} else {
            [_unit,_previous select 1] call mplus_fnc_contactAudience
        };
        private _deleted = _previous isNotEqualTo [] && {(_previous select 0) isEqualTo []};
        private _valid = _record isEqualTo [] || {[_record] call mplus_fnc_validateContact};
        private _originalChannel = if (_previous isEqualTo []) then {
            parseNumber ((_marker splitString "/") select 2)
        } else {(_previous select 1) select 0};
        if (!_allowed || {!_valid} || {_channel != _originalChannel} || {_deleted && {_record isNotEqualTo []}}) exitWith {
            diag_log format ["[MarkersPlus] Contact publication rejected: %1; owner=%2; allowed=%3; valid=%4; channel=%5; deleted=%6",_marker,owner _unit,_allowed,_valid,_channel,_deleted];
            ["mplus_contactRejected",[_marker],_unit] call CBA_fnc_targetEvent;
        };
        private _scope = if (_previous isEqualTo []) then {
            [_channel,side group _unit,group _unit,vehicle _unit,owner _unit]
        } else {_previous select 1};
        private _revision = (missionNamespace getVariable ["mplus_contactServerRevision",0]) + 1;
        missionNamespace setVariable ["mplus_contactServerRevision",_revision];
        // Retain deletion tombstones so delayed updates cannot resurrect reports.
        _cache set [_marker,[_record,_scope,_revision]];
        private _targets = allPlayers select {[_x,_scope] call mplus_fnc_contactAudience};
        ["mplus_contactReceive",[_marker,_record,_scope,_revision],_targets] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;
    ["mplus_contactRequest",{
        params ["_unit"];
        if (isNull _unit || {!isPlayer _unit}) exitWith {};
        private _cache = missionNamespace getVariable ["mplus_contactServer",createHashMap];
        private _records = [];
        {
            (_cache get _x) params ["_record","_scope","_revision"];
            // A dedicated server's marker list is not a reliable deletion signal.
            if ([_unit,_scope] call mplus_fnc_contactAudience) then {_records pushBack [_x,_record,_scope,_revision]};
        } forEach +(keys _cache);
        ["mplus_contactSnapshot",[_records],_unit] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;
};
if (!hasInterface) exitWith {};
missionNamespace setVariable ["mplus_contactRecords",createHashMap];
missionNamespace setVariable ["mplus_contactScopes",createHashMap];
missionNamespace setVariable ["mplus_contactRevisions",createHashMap];
missionNamespace setVariable ["mplus_contactPending",createHashMap];
missionNamespace setVariable ["mplus_contactDeferred",createHashMap];
["mplus_contactReceive",{
    _this call mplus_fnc_receiveContact;
}] call CBA_fnc_addEventHandler;
["mplus_contactSnapshot",{
    params ["_snapshot"];
    private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
    private _scopes = missionNamespace getVariable ["mplus_contactScopes",createHashMap];
    // Drop access that actually changed, not records omitted by an older snapshot.
    {
        private _scope = _scopes getOrDefault [_x,[]];
        if (_scope isNotEqualTo [] && {!([player,_scope] call mplus_fnc_contactAudience)}) then {_records deleteAt _x};
    } forEach +(keys _records);
    {
        _x params ["_marker","_record",["_scope",[]],["_revision",-1]];
        [_marker,_record,_scope,_revision,true] call mplus_fnc_receiveContact;
    } forEach _snapshot;
}] call CBA_fnc_addEventHandler;
["mplus_contactRejected",{
    params ["_marker"];
    (missionNamespace getVariable ["mplus_contactPending",createHashMap]) deleteAt _marker;
    (missionNamespace getVariable ["mplus_contactDeferred",createHashMap]) deleteAt _marker;
    diag_log format ["[MarkersPlus] Server rejected contact change: %1. Requesting authoritative details.",_marker];
    ["mplus_contactRequest",[player]] call CBA_fnc_serverEvent;
}] call CBA_fnc_addEventHandler;
[{!isNull player},{["mplus_contactRequest",[player]] call CBA_fnc_serverEvent}] call CBA_fnc_waitUntilAndExecute;
