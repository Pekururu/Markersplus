#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_tile"];
private _type = _tile getVariable ["mplus_type",""];
if (_type == "") exitWith {};
private _favorites = +(profileNamespace getVariable ["mplus_favorites",[]]);
if (_type in _favorites) then {_favorites deleteAt (_favorites find _type)} else {_favorites pushBack _type};
profileNamespace setVariable ["mplus_favorites",_favorites];
saveProfileNamespace;
// Delete/rebuild the clicked tile only after its event has finished.
[{params ["_display"]; if (!isNull _display) then {[_display] call mplus_fnc_filterMarkers}},[ctrlParent _tile]] call CBA_fnc_execNextFrame;
