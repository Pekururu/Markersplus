// Scope saved with the report: [channel,side,group,vehicle,creatorOwner].
params ["_unit","_scope"];
if (isNull _unit || {!isPlayer _unit}) exitWith {false};
_scope params ["_channel","_side","_group","_vehicle","_creator"];
if (owner _unit == _creator) exitWith {true};
switch _channel do {
    case 0: {true};
    case 1: {side group _unit == _side};
    case 2: {side group _unit == _side && {leader group _unit == _unit}};
    case 3: {!isNull _group && {group _unit == _group}};
    case 4: {!isNull _vehicle && {vehicle _unit == _vehicle}};
    default {false};
}
