private _colors = call compile preprocessFileLineNumbers "\markersplus_ui\functions\fn_markerColors.sqf";
private _classes = _colors apply {_x select 0};
private _names = _colors apply {_x select 1};
["mplus_defaultColor", "LIST", ["Default colour", "Colour used when opening a new marker panel."], ["MarkersPlus","Markers"],
    [_classes,_names,(_classes find "ColorBlack") max 0], 2] call CBA_fnc_addSetting;
["mplus_defaultSize", "SLIDER", ["Default size", "Multiplier applied to the symbol's normal size."], ["MarkersPlus","Markers"],
    [0.25,4,1,2], 2] call CBA_fnc_addSetting;

["mplus_showToolbar", "CHECKBOX", ["Show map toolbar", "Show the marker and contact buttons on the map."], ["MarkersPlus","Interface"],
    true, 2, {if (hasInterface) then {call mplus_fnc_updateInterface}}] call CBA_fnc_addSetting;
["mplus_pauseGestures", "CHECKBOX", ["Pause ACE map gestures", "Pause pointing gestures while a MarkersPlus tool is open."], ["MarkersPlus","Interface"],
    true, 2, {if (hasInterface) then {call mplus_fnc_updateMapGestures}}] call CBA_fnc_addSetting;
private _channels = [[-2,3,1,2,4,0],["Local only (you)","Group","Side","Command","Vehicle","Global (everyone)"],2];
["mplus_defaultChannel", "LIST", ["Default sharing channel", "Sharing for new markers. Falls back to Local when unavailable."], ["MarkersPlus","Markers"],
    _channels, 2] call CBA_fnc_addSetting;
["mplus_rotationDelay", "SLIDER", ["Hold duration before rotation", "Seconds to hold the mouse before aiming a new marker."], ["MarkersPlus","Markers"],
    [0.15,0.75,0.3,2], 2] call CBA_fnc_addSetting;
["mplus_contactChannel", "LIST", ["Default sharing channel", "Sharing for new contact reports. Falls back to Local when unavailable."], ["MarkersPlus","Contact reports"],
    _channels, 2] call CBA_fnc_addSetting;
["mplus_showDisabledReports", "CHECKBOX", ["Show disabled reports in contact list", "Hiding a disabled report from the list leaves its map marker and saved details intact."], ["MarkersPlus","Contact reports"],
    true, 2, {if (hasInterface) then {[findDisplay 12] call mplus_fnc_refreshContactList}}] call CBA_fnc_addSetting;
