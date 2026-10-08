params ["_channel"];
private _serial = missionNamespace getVariable ["mplus_markerSerial",0];
private _name = "";
while {_name == "" || {_name in allMapMarkers}} do {
    _serial = _serial + 1;
    _name = format ["_USER_DEFINED #%1/%2/%3",clientOwner,1000000 + _serial,_channel];
};
missionNamespace setVariable ["mplus_markerSerial",_serial];
_name
