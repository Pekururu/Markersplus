// Both snapshots and live updates use the server's monotonic revision numbers.
params ["_marker","_record",["_scope",[]],["_revision",-1],["_snapshot",false]];
private _pending = missionNamespace getVariable ["mplus_contactPending",createHashMap];
private _deferred = missionNamespace getVariable ["mplus_contactDeferred",createHashMap];
if (_marker in _pending && {_snapshot || {_record isNotEqualTo [] && {(_pending get _marker) isNotEqualTo _record}}}) exitWith {
    private _previous = _deferred getOrDefault [_marker,[[],[],-1]];
    if (_revision > (_previous select 2)) then {_deferred set [_marker,[_record,_scope,_revision]]};
};
// A matching live update acknowledges our submission. A deletion wins over edits.
if (_marker in _pending) then {_pending deleteAt _marker};
private _latest = _deferred getOrDefault [_marker,[[],[],-1]];
_deferred deleteAt _marker;
if ((_latest select 2) > _revision) then {
    _record = _latest select 0;
    _scope = _latest select 1;
    _revision = _latest select 2;
};
private _revisions = missionNamespace getVariable ["mplus_contactRevisions",createHashMap];
if (_revision < (_revisions getOrDefault [_marker,-1])) exitWith {};
if (_record isNotEqualTo [] && {!([_record] call mplus_fnc_validateContact)}) exitWith {
    diag_log format ["[MarkersPlus] Invalid shared contact record: %1",_marker];
};
private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
private _scopes = missionNamespace getVariable ["mplus_contactScopes",createHashMap];
_revisions set [_marker,_revision];
if (_scope isNotEqualTo []) then {_scopes set [_marker,_scope]};
if (_scope isNotEqualTo [] && {!([player,_scope] call mplus_fnc_contactAudience)}) exitWith {_records deleteAt _marker};
if (_record isEqualTo []) exitWith {_records deleteAt _marker};
_records set [_marker,_record];
