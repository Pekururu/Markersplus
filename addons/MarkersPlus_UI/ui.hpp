#include "script_component.hpp"

class RscText;
class RscStructuredText;
class RscEdit;
class RscCombo;
class RscControlsGroup;
class RscButton;
class RscCheckbox;
class RscControlsGroupNoScrollbars;

class mplus_Text: RscText
{
    sizeEx="0.018 * safeZoneH";
    shadow=0;
    colorText[]={0.94,0.94,0.94,1};
};
class mplus_Edit: RscEdit
{
    sizeEx="0.018 * safeZoneH";
    colorBackground[]={0.15,0.16,0.17,1};
};
class mplus_Combo: RscCombo
{
    sizeEx="0.018 * safeZoneH";
    wholeHeight="0.25 * safeZoneH";
};
class mplus_Button: RscButton
{
    sizeEx="0.018 * safeZoneH";
};
class mplus_IconTile: RscButton
{
    style=2096; // Picture, keeping its aspect ratio.
    colorText[]={1,1,1,1};
    colorBackground[]={0.14,0.15,0.16,1};
    colorBackgroundActive[]={0.28,0.30,0.32,1};
    colorFocused[]={0.28,0.30,0.32,1};
    shadow=0;
    borderSize=0;
    offsetX=0; offsetY=0;
    offsetPressedX=0; offsetPressedY=0;
};

class mplus_MapTool: mplus_IconTile
{
    colorBackground[]={0.07,0.08,0.09,0.98};
    colorBorder[]={0.28,0.30,0.32,1};
    borderSize=0.001;
};

class mplus_Panel: RscControlsGroupNoScrollbars
{
    idc=MP_PANEL;
    x=0; y=0;
    w="0.24 * safeZoneW";
    h="0.64 * safeZoneH";
    class controls
    {
        class Background: RscText
        {
            idc=-1; x=0; y=0;
            w="0.24 * safeZoneW"; h="0.64 * safeZoneH";
            colorBackground[]={0.07,0.08,0.09,0.98};
        };
        class Title: mplus_Text
        {
            idc=MP_TITLE; text="MarkersPlus";
            font="RobotoCondensedBold";
            x="0.009 * safeZoneW"; y="0.009 * safeZoneH";
            w="0.125 * safeZoneW"; h="0.032 * safeZoneH";
        };
        class Plans: mplus_Button
        {
            idc=MP_PLANS; text="Plans"; tooltip="Save and load your map markers, lines and areas";
            x="0.143 * safeZoneW"; y="0.009 * safeZoneH";
            w="0.057 * safeZoneW"; h="0.032 * safeZoneH";
            onButtonClick="[] call mplus_fnc_openPlans";
        };
        class Close: mplus_Button
        {
            idc=MP_CLOSE; text="X"; tooltip="Close marker panel";
            x="0.206 * safeZoneW"; y="0.009 * safeZoneH";
            w="0.025 * safeZoneW"; h="0.032 * safeZoneH";
            onButtonClick="[ctrlParent (_this select 0)] call mplus_fnc_closePanel";
        };
        class Search: mplus_Edit
        {
            idc=MP_SEARCH; text=""; tooltip="Search markers by name; clear this field to show all results";
            x="0.009 * safeZoneW"; y="0.047 * safeZoneH";
            w="0.133 * safeZoneW"; h="0.030 * safeZoneH";
            onKeyUp="[ctrlParent (_this select 0)] call mplus_fnc_filterMarkers";
        };
        class Category: mplus_Combo
        {
            idc=MP_CATEGORY; tooltip="Marker category";
            x="0.147 * safeZoneW"; y="0.047 * safeZoneH";
            w="0.084 * safeZoneW"; h="0.030 * safeZoneH";
            onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_filterMarkers";
        };
        class Markers: RscControlsGroup
        {
            idc=MP_GRID;
            x="0.009 * safeZoneW"; y="0.086 * safeZoneH";
            w="0.222 * safeZoneW"; h="0.255 * safeZoneH";
            class controls {};
        };
        class GridEmpty: mplus_Text
        {
            idc=MP_GRID_EMPTY; text=""; style=18;
            x="0.015 * safeZoneW"; y="0.155 * safeZoneH";
            w="0.210 * safeZoneW"; h="0.10 * safeZoneH";
            sizeEx="0.017 * safeZoneH";
        };
        class Favorite: mplus_Button
        {
            idc=MP_FAVORITE; text="+"; tooltip="Add selected symbol to favorites; right-click any grid icon also toggles favorites";
            x="0.207 * safeZoneW"; y="0.349 * safeZoneH";
            w="0.024 * safeZoneW"; h="0.022 * safeZoneH";
            onButtonClick="[_this select 0] call mplus_fnc_toggleFavorite";
        };
        class PurposeName: mplus_Text
        {
            idc=MP_PURPOSE_NAME; text="";
            font="RobotoCondensedBold";
            sizeEx="0.017 * safeZoneH";
            x="0.009 * safeZoneW"; y="0.349 * safeZoneH";
            w="0.193 * safeZoneW"; h="0.022 * safeZoneH";
        };
        class Purpose: mplus_Text
        {
            idc=MP_PURPOSE; text="Choose a marker to see its purpose.";
            style=16; sizeEx="0.015 * safeZoneH";
            x="0.009 * safeZoneW"; y="0.372 * safeZoneH";
            w="0.222 * safeZoneW"; h="0.034 * safeZoneH";
        };
        class LabelTitle: mplus_Text
        {
            idc=MP_LABEL_TITLE; text="Label";
            x="0.009 * safeZoneW"; y="0.412 * safeZoneH";
            w="0.039 * safeZoneW"; h="0.028 * safeZoneH";
        };
        class Label: mplus_Edit
        {
            idc=MP_LABEL; text=""; maxChars=100; tooltip="Optional marker label; edits save immediately. Alt-double-click empty map positions to number markers using the current UI settings. A changed label seeds the sequence (e.g. CP 01 becomes CP 02).";
            onKeyUp="[ctrlParent (_this select 0)] call mplus_fnc_liveEdit";
            x="0.053 * safeZoneW"; y="0.412 * safeZoneH";
            w="0.178 * safeZoneW"; h="0.028 * safeZoneH";
        };
        class ColorTitle: mplus_Text
        {
            idc=MP_COLOR_TITLE; text="Colour";
            x="0.009 * safeZoneW"; y="0.442 * safeZoneH";
            w="0.108 * safeZoneW"; h="0.020 * safeZoneH";
        };
        class ChannelTitle: ColorTitle
        {
            idc=MP_CHANNEL_TITLE; text="Share with"; x="0.123 * safeZoneW";
        };
        class Color: mplus_Combo
        {
            idc=MP_COLOR; tooltip="All public marker colours from loaded addons";
            onLBSelChanged="[ctrlParent (_this select 0)] call mplus_fnc_liveEdit";
            x="0.009 * safeZoneW"; y="0.464 * safeZoneH";
            w="0.108 * safeZoneW"; h="0.028 * safeZoneH";
        };
        class Channel: Color
        {
            idc=MP_CHANNEL; tooltip="Sharing channel; locked when editing";
            x="0.123 * safeZoneW";
        };
        class SizeTitle: ColorTitle
        {
            idc=MP_SIZE_TITLE; text="Size"; y="0.494 * safeZoneH"; w="0.108 * safeZoneW";
        };
        class DirectionTitle: SizeTitle
        {
            idc=MP_DIRECTION_TITLE; text="Angle"; x="0.123 * safeZoneW";
        };
        class Size: mplus_Edit
        {
            idc=MP_SIZE; text="1"; maxChars=5; tooltip="Size multiplier from 0.25 to 4";
            onKeyUp="[ctrlParent (_this select 0)] call mplus_fnc_liveEdit";
            x="0.009 * safeZoneW"; y="0.516 * safeZoneH";
            w="0.108 * safeZoneW"; h="0.028 * safeZoneH";
        };
        class Direction: Size
        {
            idc=MP_DIRECTION; text="0"; maxChars=8;
            tooltip="Degrees clockwise from north"; x="0.123 * safeZoneW";
        };
        class Delete: mplus_Button
        {
            idc=MP_DELETE; text="Delete"; tooltip="Delete selected marker";
            x="0.009 * safeZoneW"; y="0.520 * safeZoneH";
            w="0.108 * safeZoneW"; h="0.028 * safeZoneH";
            onButtonClick="[ctrlParent (_this select 0),'delete'] call mplus_fnc_editMarker";
        };
        class New: Delete
        {
            idc=MP_NEW; text="Duplicate"; tooltip="Copy this marker, then click the map to place the copy";
            x="0.123 * safeZoneW";
            onButtonClick="[ctrlParent (_this select 0),'duplicate'] call mplus_fnc_editMarker";
        };
        class Place: mplus_Button
        {
            idc=MP_PLACE; text="Place marker";
            tooltip="Choose a symbol to start directly, or use this button. Esc cancels.";
            x="0.009 * safeZoneW"; y="0.556 * safeZoneH";
            w="0.222 * safeZoneW"; h="0.034 * safeZoneH";
            onButtonClick="private _display=ctrlParent (_this select 0); [_display,!(_display getVariable ['mplus_placing',false])] call mplus_fnc_setPlacement";
        };
        class Status: mplus_Text
        {
            idc=MP_STATUS; text="Choose a symbol, then click the map.";
            style=16; sizeEx="0.015 * safeZoneH";
            x="0.009 * safeZoneW"; y="0.596 * safeZoneH";
            w="0.177 * safeZoneW"; h="0.036 * safeZoneH";
        };
        class ControlsHint: mplus_Text
        {
            idc=MP_CONTROLS; text="Controls"; sizeEx="0.013 * safeZoneH";
            colorText[]={0.63,0.65,0.62,1};
            x="0.19 * safeZoneW"; y="0.596 * safeZoneH";
            w="0.041 * safeZoneW"; h="0.025 * safeZoneH";
            onMouseEnter="[_this select 0,'markers'] call mplus_fnc_controlsHint";
        };
    };
};

#include "plans.hpp"

#include "contacts.hpp"
#include "contactList.hpp"
