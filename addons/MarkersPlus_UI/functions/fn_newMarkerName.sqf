params ["_channel",["_contact",false]];
private _serial = missionNamespace getVariable ["mplus_markerSerial",0];
private _name = "";
while {_name == "" || {_name in allMapMarkers} || {_name in (missionNamespace getVariable ["mplus_contactRevisions",createHashMap])}} do {
    _serial = (_serial + 1) % 1000000;
    // Keep the exact native owner/id/channel format. A trailing report tag can
    // make Arma interpret the channel as Global. Reserve numeric report IDs.
    private _id = ([1000000,2000000] select _contact) + _serial;
    // SQF format rounds large numbers into scientific notation. Native IDs
    // must retain every digit for recognition and collision-free serials.
    _name = format ["_USER_DEFINED #%1/%2/%3",clientOwner,_id toFixed 0,_channel];
};
missionNamespace setVariable ["mplus_markerSerial",_serial];
_name
