#include "\markersplus_ui\script_component.hpp"
disableSerialization;
private _display = findDisplay 12;
if (isNull _display) exitWith {};
{(_display displayCtrl _x) ctrlShow (missionNamespace getVariable ["mplus_showToolbar",true])} forEach [MP_BUTTON,MP_CONTACT_BUTTON];
