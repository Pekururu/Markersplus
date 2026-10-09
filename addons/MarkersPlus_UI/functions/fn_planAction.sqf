#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display","_action"];
if (isNull _display || {_display getVariable ["mplus_plansInit",true]}) exitWith {};
private _plans = +(call mplus_fnc_savedPlans);
private _list = _display displayCtrl MP_PLAN_LIST;
private _row = lbCurSel _list;
private _index = if (_row < 0) then {-1} else {_list lbValue _row};
private _plan = if (_index < 0 || {_index >= count _plans}) then {[]} else {_plans select _index};
if (_action == "select") exitWith {
    private _details = "No saved plans on this terrain.";
    if (_plan isNotEqualTo []) then {
        (_display displayCtrl MP_PLAN_NAME) ctrlSetText (_plan select 2);
        private _entries = _plan select 3;
        private _icons = {_x select 7 == "ICON"} count _entries;
        private _lines = {_x select 7 == "POLYLINE"} count _entries;
        private _areas = count _entries - _icons - _lines;
        private _contacts = {count _x == 12 && {(_x select 11) isNotEqualTo []}} count _entries;
        _details = format ["%1 icons (%2 reports) | %3 lines | %4 areas%5",_icons,_contacts,_lines,_areas,
            if ((_plan select 1) != worldName) then {" / Other terrain: load unavailable"} else {""}];
    } else {(_display displayCtrl MP_PLAN_NAME) ctrlSetText ""};
    (_display displayCtrl MP_PLAN_DETAILS) ctrlSetText _details;
};
// Repeating an overwrite/delete within five seconds confirms that exact operation.
private _confirm = {
    params ["_key"];
    private _armed = _display getVariable ["mplus_planConfirm",["",-10]];
    if ((_armed select 0) == _key && {diag_tickTime - (_armed select 1) < 5}) exitWith {
        _display setVariable ["mplus_planConfirm",["",-10]];
        true
    };
    _display setVariable ["mplus_planConfirm",[_key,diag_tickTime]];
    false
};
private _store = {
    params [["_selectPlan",[]]];
    if (_selectPlan isNotEqualTo []) then {
        _display setVariable ["mplus_planSelectName",_selectPlan select 2];
        _display setVariable ["mplus_planSelectTerrain",_selectPlan select 1];
    };
    // First write copies the readable old registry; never overwrite its rollback copy.
    profileNamespace setVariable ["mplus_plans_v2",_plans];
    saveProfileNamespace;
    [_display] call mplus_fnc_refreshPlans;
};
private _result = switch (_action) do {
    case "save": {
        private _chars = toArray ctrlText (_display displayCtrl MP_PLAN_NAME);
        while {count _chars > 0 && {(_chars select 0) in [9,10,13,32]}} do {_chars deleteAt 0};
        while {count _chars > 0 && {(_chars select (count _chars - 1)) in [9,10,13,32]}} do {_chars deleteAt (count _chars - 1)};
        private _name = toString _chars;
        if (_name == "") exitWith {"Enter a plan name first."};
        private _entries = [];
        private _hasContacts = false;
        private _captureError = "";
        private _contactRecords = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
        {
            if ([_x] call mplus_fnc_ownsMapMarker && {markerShape _x in ["ICON","RECTANGLE","ELLIPSE","POLYLINE"]}) then {
                private _contact = [];
                if ([_x] call mplus_fnc_isContact) then {
                    _contact = +(_contactRecords getOrDefault [_x,[]]);
                    if !([_contact] call mplus_fnc_validateContact) then {
                        _captureError = "A contact report has missing details. Reopen its report before saving this plan.";
                    };
                    _hasContacts = true;
                };
                _entries pushBack [markerAlpha _x,markerBrush _x,markerColor _x,markerDir _x,
                    markerPolyline _x,markerPos [_x,true],markerShadow _x,markerShape _x,
                    markerSize _x,markerText _x,markerType _x,_contact];
            };
            if (_captureError != "") exitWith {};
        } forEach allMapMarkers;
        if (_captureError != "") exitWith {_captureError};
        // Ordinary plans still export in v1 format for older builds.
        if (!_hasContacts) then {_entries = _entries apply {_x select [0,11]}};
        private _saved = [[1,2] select _hasContacts,worldName,_name,_entries];
        private _error = [_saved] call mplus_fnc_validatePlan;
        if (_error != "") exitWith {_error};
        private _existing = _plans findIf {(_x select 1) == worldName && {toLower (_x select 2) == toLower _name}};
        if (_existing >= 0 && {!([format ["save:%1:%2",worldName,toLower _name]] call _confirm)}) exitWith {format ["Replace '%1'? Click Save map again within 5 seconds.",_name]};
        if (_existing < 0) then {_plans pushBack _saved} else {_plans set [_existing,_saved]};
        [_saved] call _store;
        format ["Saved '%1': %2 markers, lines and areas in your Arma profile.",_name,count _entries]
    };
    case "load": {
        if (_plan isEqualTo []) exitWith {"Select a plan first."};
        if ((_plan select 1) != worldName) exitWith {"This plan belongs to another terrain. Open that terrain to load it."};
        private _error = [_plan,true] call mplus_fnc_validatePlan;
        if (_error != "") exitWith {_error};
        private _channels = _display displayCtrl MP_PLAN_CHANNEL;
        private _channel = _channels lbValue (lbCurSel _channels);
        if !([_channel] call mplus_fnc_channelAvailable) exitWith {"That channel is unavailable. Choose another channel."};
        private _loaded = [];
        private _contactLoads = [];
        private _failed = false;
        {
            _x params ["_alpha","_brush","_color","_dir","_line","_pos","_shadow","_shape","_size","_text","_type"];
            private _contact = if ((_plan select 0) == 2) then {+(_x select 11)} else {[]};
            private _name = [_channel,_contact isNotEqualTo []] call mplus_fnc_newMarkerName;
            if (_contact isNotEqualTo []) then {
                _text = ([_contact,_pos] call mplus_fnc_formatContact) select 0;
                ([_contact] call mplus_fnc_contactAppearance) params ["_contactType","_contactColor"];
                _type = _contactType;
                _color = _contactColor;
            };
            private _marker = if (_channel == -2) then {createMarkerLocal [_name,_pos]} else {createMarker [_name,_pos,_channel,player]};
            if (_marker == "") exitWith {_failed = true};
            _loaded pushBack [_marker,_channel];
            if (_contact isNotEqualTo []) then {_contactLoads pushBack [_marker,_contact]};
            _marker setMarkerTypeLocal _type;
            _marker setMarkerShapeLocal _shape;
            _marker setMarkerAlphaLocal _alpha;
            _marker setMarkerBrushLocal _brush;
            _marker setMarkerColorLocal _color;
            _marker setMarkerDirLocal _dir;
            _marker setMarkerShadowLocal _shadow;
            _marker setMarkerSizeLocal _size;
            if (_shape == "POLYLINE") then {_marker setMarkerPolylineLocal _line};
            if (_channel == -2) then {_marker setMarkerTextLocal _text} else {_marker setMarkerText _text};
            ace_markers_userPlacedMarkers pushBackUnique _marker;
            if (_channel == -2 && {_shape == "ICON"} && {_contact isEqualTo []}) then {
                private _personal = missionNamespace getVariable ["mplus_personalPlanIcons",[]];
                _personal pushBackUnique _marker;
                missionNamespace setVariable ["mplus_personalPlanIcons",_personal];
            };
            if (_shape == "ICON") then {[_marker] call mplus_fnc_syncAceMarker};
        } forEach (_plan select 3);
        if (_failed) exitWith {
            {
                _x params ["_marker","_loadedChannel"];
                if (_loadedChannel == -2) then {deleteMarkerLocal _marker} else {deleteMarker _marker};
                [_marker,_loadedChannel] call mplus_fnc_forgetContact;
                ace_markers_userPlacedMarkers = ace_markers_userPlacedMarkers - [_marker];
                missionNamespace setVariable ["mplus_personalPlanIcons",(missionNamespace getVariable ["mplus_personalPlanIcons",[]]) - [_marker]];
            } forEach _loaded;
            "Could not create the full plan. This load was removed."
        };
        // Publish structured details only after the complete batch was created.
        // Stored observation time, reporter and origin stay unchanged on reload.
        private _records = missionNamespace getVariable ["mplus_contactRecords",createHashMap];
        {
            _x params ["_marker","_contact"];
            _records set [_marker,_contact];
            if (_channel != -2) then {
                [_marker,_contact,_channel] call mplus_fnc_publishContact;
            };
        } forEach _contactLoads;
        missionNamespace setVariable ["mplus_lastPlanLoad",_loaded];
        (_display displayCtrl 81112) ctrlEnable true;
        format ["Loaded '%1': %2 markers. %3. Undo load removes only this batch.",_plan select 2,count _loaded,_channels lbText (lbCurSel _channels)]
    };
    case "undo": {
        private _batch = missionNamespace getVariable ["mplus_lastPlanLoad",[]];
        if (_batch isEqualTo []) exitWith {"No load to undo in this mission."};
        if (_batch findIf {(_x select 0) in allMapMarkers && {!([_x select 1] call mplus_fnc_channelAvailable)}} >= 0) exitWith {"The loaded channel is currently unavailable. Undo when it is available again."};
        {
            _x params ["_marker","_channel"];
            if (_marker in allMapMarkers) then {
                if (_channel == -2) then {deleteMarkerLocal _marker} else {deleteMarker _marker};
            };
            [_marker,_channel] call mplus_fnc_forgetContact;
            ace_markers_userPlacedMarkers = ace_markers_userPlacedMarkers - [_marker];
            missionNamespace setVariable ["mplus_personalPlanIcons",(missionNamespace getVariable ["mplus_personalPlanIcons",[]]) - [_marker]];
        } forEach _batch;
        missionNamespace setVariable ["mplus_lastPlanLoad",[]];
        (_display displayCtrl 81112) ctrlEnable false;
        "Removed the last loaded batch. Saved plans and other map markers remain."
    };
    case "delete": {
        if (_plan isEqualTo []) exitWith {"Select a plan first."};
        if (!([format ["delete:%1:%2",_plan select 1,_plan select 2]] call _confirm)) exitWith {"Delete this saved plan? Click Delete plan again within 5 seconds."};
        _plans deleteAt _index;
        [] call _store;
        "Saved plan deleted. Placed markers remain."
    };
    case "export": {
        if (_plan isEqualTo []) exitWith {"Select a plan first."};
        copyToClipboard str _plan;
        "Plan copied to clipboard. Share that text to import it into another Arma profile."
    };
    case "import": {
        private _text = copyFromClipboard;
        if (count _text > 2000000) exitWith {"Clipboard plan is too large."};
        private _imported = parseSimpleArray _text;
        private _error = [_imported] call mplus_fnc_validatePlan;
        if (_error != "") exitWith {_error};
        private _existing = _plans findIf {(_x select 1) == (_imported select 1) && {toLower (_x select 2) == toLower (_imported select 2)}};
        if (_existing >= 0 && {!([format ["import:%1",_text]] call _confirm)}) exitWith {"A plan with that name exists. Click Import again within 5 seconds to replace it."};
        if (_existing < 0) then {_plans pushBack _imported} else {_plans set [_existing,_imported]};
        [_imported] call _store;
        format ["Imported '%1'. Select its terrain in the list.",_imported select 2]
    };
    default {""};
};
if (_result != "") then {(_display displayCtrl MP_PLAN_STATUS) ctrlSetText _result};
