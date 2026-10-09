class mplus_ContactPanel: RscControlsGroupNoScrollbars
{
 idc=MP_CONTACT_PANEL; x=0; y=0; w="0.24 * safeZoneW"; h="0.64 * safeZoneH";
 class controls {
class Background: RscText { idc=-1; text=""; x="0 * safeZoneW"; y="0 * safeZoneH"; w="0.24 * safeZoneW"; h="0.64 * safeZoneH"; colorBackground[]={0.07,0.08,0.09,0.98}; };
class Title: mplus_Text { idc=MP_CONTACT_TITLE; text="Contact report"; x="0.009 * safeZoneW"; y="0.009 * safeZoneH"; w="0.099 * safeZoneW"; h="0.032 * safeZoneH"; font="RobotoCondensedBold"; };
class List: mplus_Button { idc=-1; text="List"; x="0.111 * safeZoneW"; y="0.009 * safeZoneH"; w="0.041 * safeZoneW"; h="0.032 * safeZoneH"; onButtonClick="[] call mplus_fnc_openContactList"; tooltip="Browse contact reports visible to you"; };
class New: mplus_Button { idc=-1; text="New"; x="0.158 * safeZoneW"; y="0.009 * safeZoneH"; w="0.042 * safeZoneW"; h="0.032 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'new'] call mplus_fnc_contactAction"; tooltip="Start a new contact report"; };
class Close: mplus_Button { idc=-1; text="X"; x="0.206 * safeZoneW"; y="0.009 * safeZoneH"; w="0.025 * safeZoneW"; h="0.032 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0)] call mplus_fnc_closeContacts"; tooltip="Close contact tool; unsent changes are discarded"; };
class Location: mplus_Button { idc=MP_CONTACT_LOCATION; text="Click map to set location"; x="0.009 * safeZoneW"; y="0.047 * safeZoneH"; w="0.222 * safeZoneW"; h="0.028 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'pick'] call mplus_fnc_contactAction"; tooltip="Choose or change the reported map position"; };
class IdentificationTitle: mplus_Text { idc=-1; text="Identification"; x="0.009 * safeZoneW"; y="0.08 * safeZoneH"; w="0.108 * safeZoneW"; h="0.02 * safeZoneH"; };
class MovementTitle: mplus_Text { idc=-1; text="Movement direction"; x="0.123 * safeZoneW"; y="0.19 * safeZoneH"; w="0.108 * safeZoneW"; h="0.02 * safeZoneH"; };
class Identification: mplus_Combo { idc=MP_CONTACT_AFFILIATION; text=""; x="0.009 * safeZoneW"; y="0.102 * safeZoneH"; w="0.108 * safeZoneW"; h="0.03 * safeZoneH"; onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; };
class Movement: mplus_Combo { idc=MP_CONTACT_MOVEMENT; text=""; x="0.123 * safeZoneW"; y="0.212 * safeZoneH"; w="0.108 * safeZoneW"; h="0.03 * safeZoneH"; onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; };
class TypeTitle: mplus_Text { idc=-1; text="Type"; x="0.009 * safeZoneW"; y="0.135 * safeZoneH"; w="0.108 * safeZoneW"; h="0.02 * safeZoneH";  };
class CountTitle: mplus_Text { idc=-1; text="Count"; x="0.123 * safeZoneW"; y="0.135 * safeZoneH"; w="0.041 * safeZoneW"; h="0.02 * safeZoneH"; tooltip="Optional: leave blank if the count is unknown"; };
class Estimate: RscCheckbox { idc=MP_CONTACT_ESTIMATE; x="0.166 * safeZoneW"; y="0.135 * safeZoneH"; w="0.012 * safeZoneW"; h="0.02 * safeZoneH"; onCheckedChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; tooltip="Estimated count: displays ~8 on the map and approximately 8 in the report. Blank still means unknown."; };
class EstimateTitle: mplus_Text { idc=-1; text="Estimate"; x="0.18 * safeZoneW"; y="0.135 * safeZoneH"; w="0.051 * safeZoneW"; h="0.02 * safeZoneH"; sizeEx="0.015 * safeZoneH"; };
class ActivityTitle: mplus_Text { idc=-1; text="Activity"; x="0.009 * safeZoneW"; y="0.19 * safeZoneH"; w="0.108 * safeZoneW"; h="0.02 * safeZoneH";  };
class ChannelTitle: mplus_Text { idc=-1; text="Share with"; x="0.123 * safeZoneW"; y="0.08 * safeZoneH"; w="0.108 * safeZoneW"; h="0.02 * safeZoneH";  };
class Type: mplus_Combo { idc=MP_CONTACT_TYPE; text=""; x="0.009 * safeZoneW"; y="0.157 * safeZoneH"; w="0.108 * safeZoneW"; h="0.03 * safeZoneH"; onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; };
class Count: mplus_Edit { idc=MP_CONTACT_COUNT; text=""; x="0.123 * safeZoneW"; y="0.157 * safeZoneH"; w="0.108 * safeZoneW"; h="0.03 * safeZoneH"; onKeyUp="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; maxChars=4; tooltip="Number observed. Blank means unknown."; };
class Activity: mplus_Combo { idc=MP_CONTACT_ACTIVITY; text=""; x="0.009 * safeZoneW"; y="0.212 * safeZoneH"; w="0.108 * safeZoneW"; h="0.03 * safeZoneH"; onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; };
class Channel: mplus_Combo { idc=MP_CONTACT_CHANNEL; text=""; x="0.123 * safeZoneW"; y="0.102 * safeZoneH"; w="0.108 * safeZoneW"; h="0.03 * safeZoneH"; onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; };
class DetailsButton: mplus_Button { idc=MP_CONTACT_DETAILS_BUTTON; text="Details +"; x="0.009 * safeZoneW"; y="0.252 * safeZoneH"; w="0.222 * safeZoneW"; h="0.026 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'details'] call mplus_fnc_contactAction"; };
class Details: RscControlsGroupNoScrollbars {
 idc=MP_CONTACT_DETAILS; x="0.009 * safeZoneW"; y="0.287 * safeZoneH";
 w="0.222 * safeZoneW"; h="0.129 * safeZoneH";
 class controls {
class AccuracyTitle: mplus_Text { idc=-1; text="Location accuracy"; x="0 * safeZoneW"; y="0 * safeZoneH"; w="0.108 * safeZoneW"; h="0.018 * safeZoneH"; sizeEx="0.015 * safeZoneH"; };
class TimeTitle: mplus_Text { idc=-1; text="Observed (HH:MM)"; x="0.114 * safeZoneW"; y="0 * safeZoneH"; w="0.108 * safeZoneW"; h="0.018 * safeZoneH"; sizeEx="0.015 * safeZoneH"; };
class NoteTitle: mplus_Text { idc=-1; text="Note (optional)"; x="0 * safeZoneW"; y="0.052 * safeZoneH"; w="0.108 * safeZoneW"; h="0.018 * safeZoneH"; sizeEx="0.015 * safeZoneH"; };
class Accuracy: mplus_Combo { idc=MP_CONTACT_ACCURACY; text=""; x="0 * safeZoneW"; y="0.02 * safeZoneH"; w="0.108 * safeZoneW"; h="0.028 * safeZoneH"; onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; };
class Time: mplus_Edit { idc=MP_CONTACT_TIME; text=""; x="0.114 * safeZoneW"; y="0.02 * safeZoneH"; w="0.075 * safeZoneW"; h="0.028 * safeZoneH"; onKeyUp="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; maxChars=5; tooltip="Time of observation in the mission clock; editing notes does not reset it"; };
class Now: mplus_Button { idc=MP_CONTACT_NOW; text="Now"; x="0.193 * safeZoneW"; y="0.02 * safeZoneH"; w="0.029 * safeZoneW"; h="0.028 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'now'] call mplus_fnc_contactAction"; sizeEx="0.014 * safeZoneH"; tooltip="Record a new observation time and your current reporter position"; };
class Note: mplus_Edit { idc=MP_CONTACT_NOTE; text=""; x="0 * safeZoneW"; y="0.073 * safeZoneH"; w="0.222 * safeZoneW"; h="0.054 * safeZoneH"; onKeyUp="[ctrlParent (_this select 0)] call mplus_fnc_refreshContact"; style=16; maxChars=200; tooltip="Description, equipment or landmark"; };
}; };
class PreviewTitle: mplus_Text { idc=MP_CONTACT_PREVIEW_TITLE; text="Report preview"; x="0.009 * safeZoneW"; y="0.287 * safeZoneH"; w="0.222 * safeZoneW"; h="0.02 * safeZoneH"; font="RobotoCondensedBold"; sizeEx="0.016 * safeZoneH"; colorText[]={1,0.7294118,0.1490196,1}; };
class PreviewGroup: RscControlsGroup {
 idc=MP_CONTACT_PREVIEW_GROUP; x="0.009 * safeZoneW"; y="0.309 * safeZoneH";
 w="0.222 * safeZoneW"; h="0.231 * safeZoneH";
 class controls {
class Preview: RscStructuredText {
 idc=MP_CONTACT_PREVIEW; text="Pick the observed location on the map.";
 x="0 * safeZoneW"; y="0 * safeZoneH"; w="0.21 * safeZoneW"; h="0.025 * safeZoneH";
 size="0.015 * safeZoneH"; colorBackground[]={0,0,0,0};
 class Attributes { font="RobotoCondensed"; color="#FFFFFF"; align="left"; valign="top"; shadow=0; size=1; };
};
}; };
class Create: mplus_Button { idc=MP_CONTACT_CREATE; text="Create report"; x="0.009 * safeZoneW"; y="0.55 * safeZoneH"; w="0.13 * safeZoneW"; h="0.031 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'submit'] call mplus_fnc_contactAction"; };
class Copy: mplus_Button { idc=MP_CONTACT_COPY; text="Copy report"; x="0.145 * safeZoneW"; y="0.55 * safeZoneH"; w="0.086 * safeZoneW"; h="0.031 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'copy'] call mplus_fnc_contactAction"; };
class Delete: mplus_Button { idc=MP_CONTACT_DELETE; text="Delete"; x="0.009 * safeZoneW"; y="0.603 * safeZoneH"; w="0.065 * safeZoneW"; h="0.028 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'delete'] call mplus_fnc_contactAction"; };
class Disable: mplus_Button { idc=MP_CONTACT_DISABLE; text="Mark as disabled"; x="0.08 * safeZoneW"; y="0.603 * safeZoneH"; w="0.151 * safeZoneW"; h="0.028 * safeZoneH"; onButtonClick="[ctrlParent (_this select 0),'disable'] call mplus_fnc_contactAction"; };
class Status: mplus_Text { idc=MP_CONTACT_STATUS; text="Choose the observed location."; x="0.009 * safeZoneW"; y="0.584 * safeZoneH"; w="0.222 * safeZoneW"; h="0.018 * safeZoneH"; sizeEx="0.013 * safeZoneH"; };
}; };
