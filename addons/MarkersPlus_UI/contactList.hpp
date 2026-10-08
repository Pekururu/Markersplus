class RscListNBox;
class mplus_ContactListPanel: RscControlsGroupNoScrollbars
{
    idc=MP_CONTACT_LIST_PANEL;
    x=0; y=0; w="0.44 * safeZoneW"; h="0.36 * safeZoneH";
    class controls
    {
        class Background: RscText
        {
            idc=-1; text=""; style=0;
            x=0; y=0; w="0.44 * safeZoneW"; h="0.36 * safeZoneH";
            colorBackground[]={0.07,0.08,0.09,0.98};
        };
        class Title: mplus_Text
        {
            idc=-1; text="Contact reports"; font="RobotoCondensedBold";
            x="0.009 * safeZoneW"; y="0.009 * safeZoneH";
            w="0.38 * safeZoneW"; h="0.032 * safeZoneH";
        };
        class Close: mplus_Button
        {
            idc=-1; text="X"; tooltip="Collapse the report list";
            x="0.406 * safeZoneW"; y="0.009 * safeZoneH";
            w="0.025 * safeZoneW"; h="0.032 * safeZoneH";
            onButtonClick="[] call mplus_fnc_openContactList";
        };
        class IdTitle: mplus_Text
        {
            idc=-1; text="IDENTIFICATION"; sizeEx="0.014 * safeZoneH"; font="RobotoCondensedBold";
            x="0.012 * safeZoneW"; y="0.051 * safeZoneH";
            w="0.083 * safeZoneW"; h="0.022 * safeZoneH";
        };
        class TypeTitle: IdTitle { text="TYPE / COUNT"; x="0.096 * safeZoneW"; };
        class ActivityTitle: IdTitle { text="ACTIVITY"; x="0.18 * safeZoneW"; w="0.112 * safeZoneW"; };
        class GridTitle: IdTitle { text="GRID"; x="0.298 * safeZoneW"; w="0.06 * safeZoneW"; };
        class TimeTitle: IdTitle { text="OBSERVED"; x="0.361 * safeZoneW"; w="0.07 * safeZoneW"; };
        class Reports: RscListNBox
        {
            idc=MP_CONTACT_LIST;
            x="0.009 * safeZoneW"; y="0.078 * safeZoneH";
            w="0.422 * safeZoneW"; h="0.229 * safeZoneH";
            columns[]={0,0.20,0.40,0.68,0.83};
            sizeEx="0.016 * safeZoneH"; rowHeight="0.03 * safeZoneH";
            colorText[]={0.94,0.94,0.94,1};
            colorBackground[]={0.10,0.11,0.12,1};
            colorSelectBackground[]={0.28,0.30,0.32,1};
            colorSelectBackground2[]={0.28,0.30,0.32,1};
            drawSideArrows=0; idcLeft=-1; idcRight=-1;
            tooltip="Click a report to center the map and open its details";
            onLBSelChanged="_this call mplus_fnc_selectContactList";
        };
        class Status: mplus_Text
        {
            idc=MP_CONTACT_LIST_STATUS; text=""; sizeEx="0.015 * safeZoneH";
            x="0.009 * safeZoneW"; y="0.321 * safeZoneH";
            w="0.422 * safeZoneW"; h="0.028 * safeZoneH";
        };
    };
};
