call mplus_fnc_initContacts;
if (!hasInterface) exitWith {};

// ACE's mover asks this event before broadcasting the final position. Personal
// markers use its drag gesture but commit locally after ACE finishes cleanup.
["ace_markers_markerMoveEnded",{
    params ["_unit","_marker","_originalPos","_finalPos"];
    if (!([_marker] call mplus_fnc_ownsMapMarker) || {!([_marker] call mplus_fnc_isLocalMarker)}) exitWith {};
    [{
        params ["_marker","_position"];
        if (_marker in allMapMarkers) then {_marker setMarkerPosLocal _position};
    },[_marker,+_finalPos]] call CBA_fnc_execNextFrame;
    true // Suppress ACE's global move event for this personal marker.
}] call CBA_fnc_addEventHandler;

private _markers = [];
{
    private _name = getText (_x >> "name");
    _markers pushBack [toLower _name, configName _x, _name, getText (_x >> "icon"), getText (_x >> "markerClass")];
} forEach ("getNumber (_x >> 'scope') == 2 && {(configName _x select [0,6]) == 'mplus_'}" configClasses (configFile >> "CfgMarkers"));
_markers sort true;
missionNamespace setVariable ["mplus_markerLibrary", _markers];
missionNamespace setVariable ["mplus_markerSerial", 0];

["MarkersPlus", "togglePanel", ["Toggle marker panel", "Open or close MarkersPlus while the map is open."], {
    if (!visibleMap || {isNull findDisplay 12}) exitWith {false};
    [] call mplus_fnc_togglePanel;
    true
}, {}, [50,[true,true,false]]] call CBA_fnc_addKeybind;

addMissionEventHandler ["Map", {
    params ["_opened"];
    if (!_opened) exitWith {[findDisplay 12] call mplus_fnc_closePanel; [findDisplay 12] call mplus_fnc_closeContacts};
    ["mplus_contactRequest",[player]] call CBA_fnc_serverEvent;
    [{!isNull findDisplay 12 || {!visibleMap}}, {
        if (visibleMap) then {[findDisplay 12] call mplus_fnc_attachMap};
    }, [], 2] call CBA_fnc_waitUntilAndExecute;
}];
if (visibleMap && {!isNull findDisplay 12}) then {[findDisplay 12] call mplus_fnc_attachMap};

// ACE sends [className], once per controlled class, rather than a unit object.
private _addPlansAction = {
    private _class = _this param [0,""];
    if !(_class isEqualType "") exitWith {};
    if (_class == "") exitWith {};
    private _registered = missionNamespace getVariable ["mplus_plansActionClasses",[]];
    if (_class in _registered) exitWith {};
    private _action = ["mplus_plans","MarkersPlus: Saved map plans","",{
        [] call mplus_fnc_openPlans;
    },{[_player,_target,[]] call ace_common_fnc_canInteractWith}] call ace_interact_menu_fnc_createAction;
    [_class,1,["ACE_SelfActions"],_action] call ace_interact_menu_fnc_addActionToClass;
    private _contactAction = ["mplus_contacts","MarkersPlus: Contact report","",{
        [] call mplus_fnc_openContacts;
    },{[_player,_target,[]] call ace_common_fnc_canInteractWith}] call ace_interact_menu_fnc_createAction;
    [_class,1,["ACE_SelfActions"],_contactAction] call ace_interact_menu_fnc_addActionToClass;
    private _contactList = ["mplus_contactList","MarkersPlus: Contact list","",{
        [] call mplus_fnc_openContactList;
    },{[_player,_target,[]] call ace_common_fnc_canInteractWith}] call ace_interact_menu_fnc_createAction;
    [_class,1,["ACE_SelfActions"],_contactList] call ace_interact_menu_fnc_addActionToClass;
    _registered pushBack _class;
    missionNamespace setVariable ["mplus_plansActionClasses",_registered];
};
["ace_interact_menu_newControllableObject",_addPlansAction] call CBA_fnc_addEventHandler;
if (!isNull player) then {[typeOf player] call _addPlansAction};


["MarkersPlus","contactReport",["Contact report","Open the contact report tool and choose a position on the map."],{
    [] call mplus_fnc_openContacts; true
},{},[-1,[false,false,false]]] call CBA_fnc_addKeybind;
