class CfgPatches
{
    class mplus_markers
    {
        author="Pek";
        requiredVersion=2.14;
        requiredAddons[]={"A3_Data_F"};
        units[]={};
        weapons[]={};
    };
};

class cfgMods
{
    class Mod_Base;
    class MarkerPlus: Mod_Base
    {
        dir="MarkersPlus";
        name="MarkersPlus";
        author="Pek";
        picture="";
        logo="\markersplus\data\logo.paa";
        logoOver="\markersplus\data\logoOver.paa";
        logoSmall="\markersplus\data\logo.paa";
        tooltip="Markersplus By Pek";
        tooltipOwned="Markersplus By Pek";
        actionName="Github";
        action="https://github.com/0xBC13FE/Markersplus";
        overview="Markersplus allows platoon/company level Command elements to better manage their markers on the map using different symbols, text and terms.";
        dlcColor[]={0.85,0.4,0,1};
        hideName=0;
        hidePicture=0;
    };
};

class cfgAddons
{
    class PreloadAddons
    {
        class MarkersPlus
        {
            list[]=
            {
                "mplus_markers"
            };
        };
    };
};

class CfgMarkers
{
    // Base Classes
    class mplus_BaseMarker
    {
        name="Base Marker";
        icon="markersplus\data\img\aapoint.paa";
        color[]={0,0,0,1};
        size=32;
        shadow=0;
        scope=0;
        showEditorMarkerColor=1;
        markerClass="mplus_movement";
    };
    class mplus_aapoint: mplus_BaseMarker
    {
        name="Generic Point";
        mplus_purpose="Mark a reference location.";
        icon="markersplus\data\img\aapoint.paa";
        scope=2;
        markerClass="mplus_points";
        size=16;
    };
    class mplus_ambush: mplus_BaseMarker
    {
        name="Ambush";
        mplus_purpose="Mark a planned surprise attack location.";
        icon="markersplus\data\img\ambush.paa";
        scope=2;
        markerClass="mplus_tasks";
        size=40;
    };

    // Tasks - Use inheritance to specify unique icons
    class mplus_attackbyfire: mplus_ambush 
    {
        name="Attack by Fire";
        mplus_purpose="Engage from range without assaulting the objective.";
        icon="markersplus\data\img\attackbyfire.paa";
    };
    class mplus_breach: mplus_ambush 
    {
        name="Breach";
        mplus_purpose="Open a passage through an obstacle.";
        icon="markersplus\data\img\breach.paa";
    };
    class mplus_bypass: mplus_ambush 
    {
        name="Bypass";
        mplus_purpose="Move around an obstacle or enemy position.";
        icon="markersplus\data\img\bypass.paa";
    };
    class mplus_clear: mplus_ambush 
    {
        name="Clear";
        mplus_purpose="Remove enemy forces from an area.";
        icon="markersplus\data\img\clear.paa";
    };
    class mplus_disengage: mplus_ambush 
    {
        name="Disengage";
        mplus_purpose="Break contact with the enemy.";
        icon="markersplus\data\img\disengage.paa";
    };
    class mplus_exfiltrate: mplus_ambush 
    {
        name="Exfiltrate";
        mplus_purpose="Withdraw from an enemy-controlled area.";
        icon="markersplus\data\img\exfiltrate.paa";
    };
    class mplus_followassume: mplus_ambush 
    {
        name="Follow and Assume";
        mplus_purpose="Follow the lead force and take over if needed.";
        icon="markersplus\data\img\followassume.paa";
    };
    class mplus_followsupport: mplus_ambush 
    {
        name="Follow and Support";
        mplus_purpose="Support the lead force and handle bypassed threats.";
        icon="markersplus\data\img\followsupport.paa";
    };
    class mplus_occupy: mplus_ambush 
    {
        name="Occupy";
        mplus_purpose="Move into and establish control of a location.";
        icon="markersplus\data\img\occupy.paa";
    };
    class mplus_retain: mplus_ambush 
    {
        name="Retain";
        mplus_purpose="Keep control of a location.";
        icon="markersplus\data\img\retain.paa";
    };
    class mplus_secure: mplus_ambush 
    {
        name="Secure";
        mplus_purpose="Protect a location from enemy interference.";
        icon="markersplus\data\img\secure.paa";
    };
    class mplus_seize: mplus_ambush 
    {
        name="Seize";
        mplus_purpose="Capture an objective using force.";
        icon="markersplus\data\img\seize.paa";
    };
    class mplus_supportbyfire: mplus_ambush 
    {
        name="Support by Fire";
        mplus_purpose="Cover another force with direct fire.";
        icon="markersplus\data\img\supportbyfire.paa";
    };
    class mplus_block: mplus_ambush 
    {
        name="Block";
        mplus_purpose="Prevent enemy movement along a route.";
        icon="markersplus\data\img\block.paa";
    };
    class mplus_canalize: mplus_ambush 
    {
        name="Canalize";
        mplus_purpose="Channel enemy movement into a chosen area.";
        icon="markersplus\data\img\canalize.paa";
    };
    class mplus_contain: mplus_ambush 
    {
        name="Contain";
        mplus_purpose="Keep enemy forces within an area.";
        icon="markersplus\data\img\contain.paa";
    };
    class mplus_destroy: mplus_ambush 
    {
        name="Destroy";
        mplus_purpose="Render an enemy force combat-ineffective.";
        icon="markersplus\data\img\destroy.paa";
    };
    class mplus_disrupt: mplus_ambush 
    {
        name="Disrupt";
        mplus_purpose="Break up enemy coordination and formations.";
        icon="markersplus\data\img\disrupt.paa";
    };
    class mplus_fix: mplus_ambush 
    {
        name="Fix";
        mplus_purpose="Prevent an enemy force from moving away.";
        icon="markersplus\data\img\fix.paa";
    };
    class mplus_isolate: mplus_ambush 
    {
        name="Isolate";
        mplus_purpose="Cut off enemy support and escape routes.";
        icon="markersplus\data\img\isolate.paa";
    };
    class mplus_interdict: mplus_ambush 
    {
        name="Interdict";
        mplus_purpose="Prevent enemy use of a route or area.";
        icon="markersplus\data\img\interdict.paa";
    };
    class mplus_neutralize: mplus_ambush 
    {
        name="Neutralize";
        mplus_purpose="Temporarily render enemy forces ineffective.";
        icon="markersplus\data\img\neutralize.paa";
    };
    class mplus_supress: mplus_ambush 
    {
        // Keep the original identifier for existing missions.
        name="Suppress";
        mplus_purpose="Reduce enemy fire and observation temporarily.";
        icon="markersplus\data\img\supress.paa";
    };
    class mplus_turn: mplus_ambush 
    {
        name="Turn";
        mplus_purpose="Force enemy movement in another direction.";
        icon="markersplus\data\img\turn.paa";
    };
    class mplus_cordonknock: mplus_ambush 
    {
        name="Cordon and Knock";
        mplus_purpose="Isolate an area for controlled contact with occupants.";
        icon="markersplus\data\img\cordonknock.paa";
    };
    class mplus_cordonsearch: mplus_ambush 
    {
        name="Cordon and Search";
        mplus_purpose="Isolate an area for a search.";
        icon="markersplus\data\img\cordonsearch.paa";
    };
    class mplus_guard: mplus_ambush 
    {
        name="Guard";
        mplus_purpose="Protect the main force by fighting for time.";
        icon="markersplus\data\img\guard.paa";
    };
    class mplus_screen: mplus_ambush 
    {
        name="Screen";
        mplus_purpose="Provide observation and early warning.";
        icon="markersplus\data\img\screen.paa";
    };
    class mplus_cover: mplus_ambush 
    {
        name="Cover";
        mplus_purpose="Protect the main force with an independent security force.";
        icon="markersplus\data\img\cover.paa";
    };

    // Movement and Maneuver
    class mplus_feintattack: mplus_BaseMarker
    {
        name="Feint Attack Arrow";
        mplus_purpose="Show a diversionary attack direction.";
        icon="markersplus\data\img\feintattack.paa";
        scope=2;
        markerClass="mplus_movement";
        size=40;
    };
    class mplus_mainattack: mplus_feintattack 
    {
        name="Main Attack Arrow";
        mplus_purpose="Show the main attack direction.";
        icon="markersplus\data\img\mainattack.paa";
    };
    class mplus_phaseline: mplus_feintattack 
    {
        name="Phase Line";
        mplus_purpose="Mark a reference line for coordinating movement.";
        icon="markersplus\data\img\phaseline.paa";
    };

    // Points
    class mplus_checkpoint: mplus_aapoint 
    {
        name="Checkpoint";
        mplus_purpose="Mark a movement control or reporting point.";
        icon="markersplus\data\img\checkpoint.paa";
        size=40;
    };
    class mplus_linkuppoint: mplus_checkpoint 
    {
        name="Link-up Point";
        mplus_purpose="Mark where friendly forces meet.";
        icon="markersplus\data\img\linkuppoint.paa";
    };
    class mplus_passagepoint: mplus_checkpoint 
    {
        name="Passage Point";
        mplus_purpose="Mark a passage through friendly lines.";
        icon="markersplus\data\img\passagepoint.paa";
    };
    class mplus_rallypoint: mplus_checkpoint 
    {
        name="Rally Point";
        mplus_purpose="Mark where a unit regroups.";
        icon="markersplus\data\img\rallypoint.paa";
    };
    class mplus_releasepoint: mplus_checkpoint 
    {
        name="Release Point";
        mplus_purpose="Mark where elements leave a shared route.";
        icon="markersplus\data\img\releasepoint.paa";
    };
    class mplus_startpoint: mplus_checkpoint 
    {
        name="Start Point";
        mplus_purpose="Mark where controlled movement begins.";
        icon="markersplus\data\img\startpoint.paa";
    };
    class mplus_departurepoint: mplus_checkpoint 
    {
        name="Point of Departure";
        mplus_purpose="Mark where a force begins its advance.";
        icon="markersplus\data\img\departurepoint.paa";
    };
    class mplus_civpoint: mplus_checkpoint 
    {
        name="Civilian Collection Point";
        mplus_purpose="Mark a civilian collection location.";
        icon="markersplus\data\img\civpoint.paa";
    };
    class mplus_detaineepoint: mplus_checkpoint
    {
        name="Detainee Collection Point";
        mplus_purpose="Mark a detainee collection location.";
        icon="markersplus\data\img\detaineepoint.paa";
    };
    class mplus_iprp: mplus_checkpoint 
    {
        name="Isolated Personnel Recovery Point";
        mplus_purpose="Mark a recovery location for isolated personnel.";
        icon="markersplus\data\img\iprp.paa";
    };
    class mplus_sarpoint: mplus_checkpoint 
    {
        name="Search and Rescue Point";
        mplus_purpose="Mark a search and rescue coordination location.";
        icon="markersplus\data\img\sarpoint.paa";
    };
    class mplus_ammopoint: mplus_checkpoint 
    {
        name="Ammunition Supply Point";
        mplus_purpose="Mark an ammunition supply location.";
        icon="markersplus\data\img\ammopoint.paa";
    };
    class mplus_ccppoint: mplus_checkpoint 
    {
        name="Casualty Collection Point";
        mplus_purpose="Mark where casualties gather for evacuation.";
        icon="markersplus\data\img\ccppoint.paa";
    };
    class mplus_medevac: mplus_checkpoint 
    {
        name="Medical Evacuation Point";
        mplus_purpose="Mark a medical evacuation pickup location.";
        icon="markersplus\data\img\medevac.paa";
    };
    class mplus_r3p: mplus_checkpoint 
    {
        name="Rearm, Refuel, and Resupply Point";
        mplus_purpose="Mark a rearm, refuel, and resupply location.";
        icon="markersplus\data\img\r3p.paa";
    };
    class mplus_waypoint: mplus_checkpoint 
    {
        name="Waypoint";
        mplus_purpose="Mark a navigation point along a route.";
        icon="markersplus\data\img\waypoint.paa";
    };
};

class CfgMarkerClasses
{
    class mplus_tasks 
    {
        displayName="(M+) Tasks";
    };
    class mplus_movement 
    {
        displayName="(M+) Movement and Maneuver";
    };
    class mplus_points 
    {
        displayName="(M+) Points";
    };
};
