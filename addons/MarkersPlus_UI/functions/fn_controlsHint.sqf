disableSerialization;
params ["_control",["_tool","markers"]];
private _lines = ["Controls"];
{
    _x params ["_action","_label"];
    private _entry = ["MarkersPlus",_action] call CBA_fnc_getKeybind;
    private _keys = [];
    if (!isNil "_entry") then {
        {
            _x params ["_key","_modifiers"];
            if (_key >= 0) then {
                private _parts = [];
                if (_modifiers select 1) then {_parts pushBack "Ctrl"};
                if (_modifiers select 0) then {_parts pushBack "Shift"};
                if (_modifiers select 2) then {_parts pushBack "Alt"};
                _parts pushBack (keyName _key);
                _keys pushBack (_parts joinString "+");
            };
        } forEach (_entry select 8);
    };
    _lines pushBack format ["%1: %2",_label,if (_keys isEqualTo []) then {"Unbound"} else {_keys joinString ", "}];
} forEach [["togglePanel","Toggle marker panel"],["contactReport","Open contact report"],["contactList","Toggle contact list"],["savedPlans","Open saved plans"],["focusSearch","Focus marker search"]];
_lines pushBack "";
if (_tool == "markers") then {
    _lines append ["Click: place marker",format ["Hold %1 s and aim: rotate",missionNamespace getVariable ["mplus_rotationDelay",0.3]],"Alt + double-click: next numbered marker","Right-click an icon: toggle favorite","Delete: delete selected marker"];
};
if (_tool == "contacts") then {_lines append ["Click map: choose report location","Click a report marker: open details","List: browse received reports","Update report: submit changes"]};
if (_tool != "plans") then {_lines append ["Alt + drag: ACE marker movement","Esc: cancel placement/picking, then close"]};
_lines pushBack "Configure shortcuts in Controls > Configure Addons > MarkersPlus.";
_control ctrlSetTooltip (_lines joinString toString [10]);
