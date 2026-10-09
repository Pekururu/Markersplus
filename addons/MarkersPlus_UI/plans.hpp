class RscListbox;
class mplus_Plans
{
    idd=MP_PLANS_DISPLAY;
    movingEnable=0;
    enableSimulation=1;
    onLoad="uiNamespace setVariable ['mplus_plansDisplay',_this select 0]; call mplus_fnc_updateMapGestures; [_this select 0] call mplus_fnc_refreshPlans";
    onUnload="uiNamespace setVariable ['mplus_plansDisplay',displayNull]";
    class controls
    {
        class Background: RscText
        {
            idc=-1; x="safeZoneX + 0.29 * safeZoneW"; y="safeZoneY + 0.22 * safeZoneH";
            w="0.42 * safeZoneW"; h="0.56 * safeZoneH";
            colorBackground[]={0.07,0.08,0.09,0.99};
        };
        class Title: mplus_Text
        {
            idc=-1; text="MarkersPlus - Saved map plans";
            font="RobotoCondensedBold";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.23 * safeZoneH";
            w="0.30 * safeZoneW"; h="0.03 * safeZoneH";
        };
        class ControlsHint: mplus_Text
        {
            idc=MP_PLAN_CONTROLS; text="Controls"; sizeEx="0.013 * safeZoneH";
            colorText[]={0.63,0.65,0.62,1};
            x="safeZoneX + 0.62 * safeZoneW"; y="safeZoneY + 0.23 * safeZoneH";
            w="0.041 * safeZoneW"; h="0.03 * safeZoneH";
            onMouseEnter="[_this select 0,'plans'] call mplus_fnc_controlsHint";
        };
        class Close: mplus_Button
        {
            idc=2; text="X";
            x="safeZoneX + 0.67 * safeZoneW"; y="safeZoneY + 0.23 * safeZoneH";
            w="0.03 * safeZoneW"; h="0.03 * safeZoneH";
            onButtonClick="(ctrlParent (_this select 0)) closeDisplay 2";
        };
        class Terrain: mplus_Combo
        {
            idc=MP_PLAN_TERRAIN; tooltip="Plans are grouped by terrain. Load on the original terrain.";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.27 * safeZoneH";
            w="0.40 * safeZoneW"; h="0.03 * safeZoneH";
            onLBSelChanged="private _d=ctrlParent (_this select 0); if !(_d getVariable ['mplus_plansInit',true]) then {[_d,false] call mplus_fnc_refreshPlans}";
        };
        class Plans: RscListbox
        {
            idc=MP_PLAN_LIST; tooltip="Select a plan; double-click loads it using Load as below"; sizeEx="0.018 * safeZoneH";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.31 * safeZoneH";
            w="0.40 * safeZoneW"; h="0.215 * safeZoneH";
            onLBDblClick="[ctrlParent (_this select 0),'load'] call mplus_fnc_planAction";
            onLBSelChanged="[ctrlParent (_this select 0),'select'] call mplus_fnc_planAction";
        };
        class Empty: mplus_Text
        {
            idc=81117; text=""; style=18;
            x="safeZoneX + 0.32 * safeZoneW"; y="safeZoneY + 0.36 * safeZoneH";
            w="0.36 * safeZoneW"; h="0.10 * safeZoneH";
        };
        class Details: mplus_Text
        {
            idc=MP_PLAN_DETAILS; text="No saved plans yet.";
            sizeEx="0.015 * safeZoneH";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.530 * safeZoneH";
            w="0.40 * safeZoneW"; h="0.025 * safeZoneH";
        };
        class NameTitle: mplus_Text
        {
            idc=-1; text="Name";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.564 * safeZoneH";
            w="0.045 * safeZoneW"; h="0.03 * safeZoneH";
        };
        class ChannelTitle: NameTitle
        {
            text="Load as"; y="safeZoneY + 0.604 * safeZoneH";
            w="0.055 * safeZoneW";
        };
        class Name: mplus_Edit
        {
            idc=MP_PLAN_NAME; text=""; maxChars=80; tooltip="Name for saving your current markers. Existing names require a second click to replace.";
            x="safeZoneX + 0.347 * safeZoneW"; y="safeZoneY + 0.564 * safeZoneH";
            w="0.243 * safeZoneW"; h="0.03 * safeZoneH";
        };
        class Save: mplus_Button
        {
            idc=81110; text="Save map";
            tooltip="Save your own icons, lines and areas on this terrain";
            x="safeZoneX + 0.60 * safeZoneW"; y="safeZoneY + 0.564 * safeZoneH";
            w="0.10 * safeZoneW"; h="0.03 * safeZoneH";
            onButtonClick="[ctrlParent (_this select 0),'save'] call mplus_fnc_planAction";
        };
        class Channel: mplus_Combo
        {
            idc=MP_PLAN_CHANNEL; tooltip="Sharing when loading. Local only keeps the plan private.";
            x="safeZoneX + 0.357 * safeZoneW"; y="safeZoneY + 0.604 * safeZoneH";
            w="0.133 * safeZoneW"; h="0.03 * safeZoneH";
        };
        class Load: Save
        {
            idc=81111; text="Load plan"; tooltip="Add the selected plan to this map using the chosen sharing channel";
            x="safeZoneX + 0.50 * safeZoneW"; y="safeZoneY + 0.604 * safeZoneH";
            w="0.095 * safeZoneW";
            onButtonClick="[ctrlParent (_this select 0),'load'] call mplus_fnc_planAction";
        };
        class Undo: Load
        {
            idc=81112; text="Undo load"; tooltip="Remove only the markers created by the last load";
            x="safeZoneX + 0.605 * safeZoneW";
            onButtonClick="[ctrlParent (_this select 0),'undo'] call mplus_fnc_planAction";
        };
        class Import: Save
        {
            idc=81113; text="Import"; tooltip="Import a plan from clipboard text";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.644 * safeZoneH";
            w="0.125 * safeZoneW";
            onButtonClick="[ctrlParent (_this select 0),'import'] call mplus_fnc_planAction";
        };
        class Export: Import
        {
            idc=81114; text="Export"; tooltip="Copy the selected plan to the clipboard";
            x="safeZoneX + 0.4375 * safeZoneW";
            onButtonClick="[ctrlParent (_this select 0),'export'] call mplus_fnc_planAction";
        };
        class Delete: Import
        {
            idc=81115; text="Delete plan"; tooltip="Remove the saved plan; placed markers remain";
            x="safeZoneX + 0.575 * safeZoneW";
            onButtonClick="[ctrlParent (_this select 0),'delete'] call mplus_fnc_planAction";
        };
        class Status: mplus_Text
        {
            idc=MP_PLAN_STATUS; style=16; sizeEx="0.016 * safeZoneH";
            text="Select a plan, then Load plan. Double-click also loads. Local only keeps it private.";
            x="safeZoneX + 0.30 * safeZoneW"; y="safeZoneY + 0.685 * safeZoneH";
            w="0.40 * safeZoneW"; h="0.075 * safeZoneH";
        };
    };
};
