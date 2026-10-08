params ["_channel"];
if (_channel == -2) exitWith {true}; // Personal marker, not a broadcast channel.
if !(_channel in [0,1,2,3,4]) exitWith {false};
if (isNull player) exitWith {false};
if (_channel == 4 && {vehicle player == player}) exitWith {false};
private _enabled = channelEnabled _channel;
// Arma 2.20 adds a separate marker flag. Earlier versions use the chat flag.
_enabled param [2, _enabled param [0,false]]
