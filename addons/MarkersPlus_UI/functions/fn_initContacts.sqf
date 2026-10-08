// Register server handlers before the UI's hasInterface guard, including dedicated servers.
if (isServer) then {
    missionNamespace setVariable ["mplus_contactServer",createHashMap];
    ["mplus_contactPublish",{
        params ["_unit","_marker","_record","_channel"];
        if (isNull _unit || {!isPlayer _unit} || {!(_channel in [0,1,2,3,4])}) exitWith {};
        private _prefix = format ["_USER_DEFINED #%1/",owner _unit];
        if ((_marker find _prefix) != 0 || {(_marker select [count _marker - 11]) != "/MP_CONTACT"}) exitWith {};
        private _cache = missionNamespace getVariable ["mplus_contactServer",createHashMap];
        private _previous = _cache getOrDefault [_marker,[]];
        if (_record isEqualTo []) exitWith {
            if (_previous isNotEqualTo []) then {
                private _targets = allPlayers select {[_x,_previous select 1] call mplus_fnc_contactAudience};
                ["mplus_contactReceive",[_marker,[]],_targets] call CBA_fnc_targetEvent;
                _cache deleteAt _marker;
            };
        };
        if !([_record] call mplus_fnc_validateContact) exitWith {};
        private _scope = if (_previous isEqualTo []) then {
            [_channel,side group _unit,group _unit,vehicle _unit,owner _unit]
        } else {_previous select 1};
        _cache set [_marker,[_record,_scope,diag_tickTime]];
        private _targets = allPlayers select {[_x,_scope] call mplus_fnc_contactAudience};
        ["mplus_contactReceive",[_marker,_record],_targets] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;
    ["mplus_contactRequest",{
        params ["_unit"];
        if (isNull _unit || {!isPlayer _unit}) exitWith {};
        private _cache = missionNamespace getVariable ["mplus_contactServer",createHashMap];
        private _records = [];
        {
            (_cache get _x) params ["_record","_scope","_published"];
            if (_x in allMapMarkers || {diag_tickTime - _published < 10}) then {
                if ([_unit,_scope] call mplus_fnc_contactAudience) then {_records pushBack [_x,_record]};
            } else {_cache deleteAt _x};
        } forEach +(keys _cache);
        ["mplus_contactSnapshot",[_records],_unit] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;
};
if (!hasInterface) exitWith {};
missionNamespace setVariable ["mplus_contactRecords",createHashMap];
["mplus_contactReceive",{
    params ["_marker","_record"];
    private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
    if (_record isEqualTo []) exitWith {_records deleteAt _marker};
    if ([_record] call mplus_fnc_validateContact) then {_records set [_marker,_record]};
}] call CBA_fnc_addEventHandler;
["mplus_contactSnapshot",{
    params ["_snapshot"];
    private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
    // Replace shared metadata when the map opens, so changed group/side access is respected.
    {if !([_x] call mplus_fnc_isLocalMarker) then {_records deleteAt _x}} forEach +(keys _records);
    {if ([_x select 1] call mplus_fnc_validateContact) then {_records set [_x select 0,_x select 1]}} forEach _snapshot;
}] call CBA_fnc_addEventHandler;
[{!isNull player},{["mplus_contactRequest",[player]] call CBA_fnc_serverEvent}] call CBA_fnc_waitUntilAndExecute;
