#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (isNull _display || {isNull (_display displayCtrl 51)}) exitWith {};
if (!isNull (_display displayCtrl MP_BUTTON)) exitWith {};
// Use pixel aspect ratio so each button stays square at any screen resolution.
private _height = .040 * safeZoneH;
private _width = _height * pixelW / pixelH;
private _gap = .006 * safeZoneH;
private _right = safeZoneX + safeZoneW - _width - .012 * safeZoneW;
private _top = safeZoneY + (safeZoneH - 2 * _height - _gap) / 2;
private _button = _display ctrlCreate ["mplus_MapTool",MP_BUTTON];
_button ctrlSetPosition [_right,_top,_width,_height];
_button ctrlSetText "\markersplus_ui\data\marker_tool.paa";
_button ctrlSetTooltip "Marker library";
_button ctrlCommit 0;
_button ctrlAddEventHandler ["ButtonClick", {[] call mplus_fnc_togglePanel}];
private _contactButton = _display ctrlCreate ["mplus_MapTool",MP_CONTACT_BUTTON];
_contactButton ctrlSetPosition [_right,_top + _height + _gap,_width,_height];
_contactButton ctrlSetText "\markersplus_ui\data\contact_tool.paa";
_contactButton ctrlSetTooltip "Contact report";
_contactButton ctrlCommit 0;
_contactButton ctrlAddEventHandler ["ButtonClick",{[] call mplus_fnc_openContacts}];
call mplus_fnc_updateInterface;
// Input persists when the panel is closed so selecting a marker can open it.
private _map = _display displayCtrl 51;
_map ctrlAddEventHandler ["MouseButtonDown",{["down",_this] call mplus_fnc_handleMapInput}];
_map ctrlAddEventHandler ["MouseButtonUp",{["up",_this] call mplus_fnc_handleMapInput}];
_map ctrlAddEventHandler ["MouseButtonDblClick",{["double",_this] call mplus_fnc_handleMapInput}];
_display displayAddEventHandler ["KeyDown", {
    params ["_display","_key"];
    if (_key != 211 || {!visibleMap}) exitWith {false};
    // Leave Delete available for editing labels, searches, and numeric fields.
    if (ctrlType (focusedCtrl _display) == 2) exitWith {false};
    [_display] call mplus_fnc_deleteLocalMarker
}];
