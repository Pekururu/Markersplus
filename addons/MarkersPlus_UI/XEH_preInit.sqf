private _colors = call compile preprocessFileLineNumbers "\markersplus_ui\functions\fn_markerColors.sqf";
private _classes = _colors apply {_x select 0};
private _names = _colors apply {_x select 1};
["mplus_defaultColor", "LIST", ["Default colour", "Colour used when opening a new marker panel."], "MarkersPlus",
    [_classes,_names,(_classes find "ColorBlack") max 0], 0] call CBA_fnc_addSetting;
["mplus_defaultSize", "SLIDER", ["Default size", "Multiplier applied to the symbol's normal size."], "MarkersPlus",
    [0.25,4,1,2], 0] call CBA_fnc_addSetting;
