#include "\markersplus_ui\script_component.hpp"
disableSerialization;
params ["_display"];
if (_display getVariable ["mplus_contactInitializing",true]) exitWith {};
if (isNull (_display displayCtrl MP_CONTACT_PANEL)) exitWith {};
private _expanded = _display getVariable ["mplus_contactDetails",false];
(_display displayCtrl MP_CONTACT_DETAILS) ctrlShow _expanded;
(_display displayCtrl MP_CONTACT_DETAILS_BUTTON) ctrlSetText (["Details +","Details -"] select _expanded);
private _y = [.287,.422] select _expanded;
private _title = _display displayCtrl MP_CONTACT_PREVIEW_TITLE;
private _pos = ctrlPosition _title; _pos set [1,_y * safeZoneH]; _title ctrlSetPosition _pos; _title ctrlCommit 0;
// Change only the displayed wording: keep the stored type, count and activity intact.
private _identification = _display displayCtrl MP_CONTACT_AFFILIATION;
private _affiliation = _identification lbData (lbCurSel _identification);
private _civilian = _affiliation == "Civilians";
private _types = _display displayCtrl MP_CONTACT_TYPE;
private _definitions = call mplus_fnc_contactTypes;
for "_i" from 0 to (lbSize _types - 1) do {
    private _key = _types lbData _i;
    private _index = _definitions findIf {(_x select 0) == _key};
    private _definition = _definitions select (_index max 0);
    _types lbSetText [_i,if (_key == "Infantry" && {_civilian}) then {"People"} else {_definition select 1}];
    private _appearance = [[1,_key,"","",_affiliation]] call mplus_fnc_contactAppearance;
    _types lbSetPicture [_i,getText (configFile >> "CfgMarkers" >> (_appearance select 0) >> "icon")];
};
private _hint = switch (_types lbData (lbCurSel _types)) do {
    case "MotorizedInfantry": {"Motorized infantry: infantry transported by motor vehicles."};
    case "MechanizedInfantry": {"Mechanized infantry: infantry with armoured personnel carriers or infantry fighting vehicles."};
    case "Armour": {"Armour / tanks: a tank or armoured unit. Use Mechanized infantry for infantry with APCs/IFVs, or Artillery for guns and launchers."};
    case "Artillery": {"Artillery: guns, howitzers or rocket artillery, including self-propelled systems. Use Mortars for mortar units."};
    case "Vehicle": {"Vehicle (unspecified): use when the vehicle's role cannot be identified. This does not imply motorized infantry."};
    case "Air": {"Aircraft (unspecified): use when the aircraft type cannot be identified."};
    default {"Choose the observed unit type or role. Use Unknown when it cannot be identified."};
};
if (_civilian) then {_hint = _hint + " Civilian identification is retained; military roles use a generic civilian symbol."};
_types ctrlSetTooltip _hint;
_identification ctrlSetTooltip "Reported allegiance: Unknown, Friendly, Hostile or Civilians. Sharing and observation accuracy stay independent.";
private _position = _display getVariable ["mplus_contactPosition",[]];
private _record = [_display] call mplus_fnc_readContact;
private _missing = _display getVariable ["mplus_contactMissing",false];
private _editable = _display getVariable ["mplus_contactEditable",false];
private _disable = _display displayCtrl MP_CONTACT_DISABLE;
_disable ctrlShow ((_display getVariable ["mplus_contactSelected",""]) != "" && {_editable});
_disable ctrlEnable (!_missing && {_editable});
_disable ctrlSetText (["Mark as disabled","Reactivate"] select (_display getVariable ["mplus_contactDisabled",false]));
_disable ctrlSetTooltip "Change the saved contact's status immediately. Other unsent field changes remain in the form.";
private _valid = _position isNotEqualTo [] && {_record isNotEqualTo []} && {!_missing};
(_display displayCtrl MP_CONTACT_CREATE) ctrlEnable (_valid && {_editable});
(_display displayCtrl MP_CONTACT_COPY) ctrlEnable _valid;
private _activity = _display displayCtrl MP_CONTACT_ACTIVITY;
(_display displayCtrl MP_CONTACT_MOVEMENT) ctrlSetTooltip "Direction the contact is moving; set Activity to Moving to enable this field.";
(_display displayCtrl MP_CONTACT_MOVEMENT) ctrlEnable (_editable && {(_activity lbData (lbCurSel _activity)) == "Moving"});
(_display displayCtrl MP_CONTACT_LOCATION) ctrlSetText (if (_position isEqualTo []) then {"Click map to set location"} else {format ["Grid %1%2",mapGridPosition _position,if (_editable) then {" / change"} else {""}]});
private _preview = text "Pick the observed location on the map.";
if (_missing) then {_preview = text "Full report details are unavailable. Shared details require MarkersPlus on the server and reporting client."} else {
    if (_record isEqualTo []) then {_preview = text "Enter a count using digits, or leave it blank. Observation time must use HH:MM (00:00 to 23:59)."} else {
        if (_position isNotEqualTo []) then {_preview = ([_record,_position] call mplus_fnc_formatContact) select 2};
    };
};
// Fit the content instead of reserving a tall scrollable blank area.
private _text = _display displayCtrl MP_CONTACT_PREVIEW;
_text ctrlSetStructuredText _preview;
private _textHeight = (ctrlTextHeight _text + .006 * safeZoneH) max (.025 * safeZoneH);
_pos = ctrlPosition _text;
_pos set [3,_textHeight];
_text ctrlSetPosition _pos;
_text ctrlCommit 0;
private _previewY = _y + .022;
private _previewGroup = _display displayCtrl MP_CONTACT_PREVIEW_GROUP;
_pos = ctrlPosition _previewGroup;
_pos set [1,_previewY * safeZoneH];
_pos set [3,(.540 - _previewY) * safeZoneH];
_previewGroup ctrlSetPosition _pos;
_previewGroup ctrlCommit 0;
