class CfgPatches
{
    class mplus_ui
    {
        name="MarkersPlus - Placement UI";
        author="Pek";
        requiredVersion=2.14;
        requiredAddons[]={"mplus_markers","A3_UI_F","cba_xeh","cba_keybinding","cba_settings","ace_markers","ace_interact_menu"};
        units[]={};
        weapons[]={};
    };
};

class CfgFunctions
{
    class mplus
    {
        class UI
        {
            file="\markersplus_ui\functions";
            class attachMap {};
            class updateMapGestures {};
            class updateInterface {};
            class controlsHint {};
            class togglePanel {};
            class closePanel {};
            class filterMarkers {};
            class readOptions {};
            class channelAvailable {};
            class setPlacement {};
            class drawPreview {};
            class drawSelection {};
            class handleMapInput {};
            class placeMarker {};
            class placeNumbered {};
            class nextMarkerLabel {};
            class deleteLocalMarker {};
            class isOwnMarker {};
            class markerAtCursor {};
            class selectMarker {};
            class editMarker {};
            class markerColors {};
            class markerColor {};
            class chooseSymbol {};
            class rotationGesture {};
            class showPurpose {};
            class layoutPanel {};
            class routeMarkerDialog {};
            class isLocalMarker {};
            class syncAceMarker {};
            class liveEdit {};
            class readNumber {};
            class toggleFavorite {};
            class ownsMapMarker {};
            class newMarkerName {};
            class openPlans {};
            class refreshPlans {};
            class planAction {};
            class validatePlan {};
            class openContacts {};
            class closeContacts {};
            class contactAction {};
            class readContact {};
            class formatContact {};
            class refreshContact {};
            class contactMapInput {};
            class drawContact {};
            class isContact {};
            class isContactName {};
            class initContacts {};
            class contactAudience {};
            class validateContact {};
            class contactAppearance {};
            class contactTypes {};
            class savedPlans {};
            class forgetContact {};
            class openContactList {};
            class refreshContactList {};
            class selectContactList {};


        };
    };
};

class Extended_PreInit_EventHandlers
{
    class mplus_ui
    {
        init="call compile preprocessFileLineNumbers '\markersplus_ui\XEH_preInit.sqf'";
    };
};
class Extended_PostInit_EventHandlers
{
    class mplus_ui
    {
        init="call compile preprocessFileLineNumbers '\markersplus_ui\XEH_postInit.sqf'";
    };
};

#include "ui.hpp"

// Route our markers before ACE installs its preview/editor handlers.
class RscDisplayInsertMarker
{
    onLoad="if !(_this call mplus_fnc_routeMarkerDialog) then {_this call ace_markers_fnc_initInsertMarker}";
    onUnload="if !((_this select 0) getVariable ['mplus_routed',false]) then {_this call ace_markers_fnc_placeMarker}";
};
