/*Event system by Sunehildeep V2.1

Credits - Sunehildeep*/

//=====================Includes=================
#include <a_samp>
#include <izcmd>

//==============Defines================
#define COLOR_YELLOW 0xFFFF00AA
#if !defined isnull
#define isnull(%1) \
((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

//================= Variables =================
enum {
    DIALOG_EVENT,
    DIALOG_WEAPS,
    DIALOG_WEAP,
    DIALOG_WEAP1,
    DIALOG_WEAP2,
    DIALOG_HEALTH,
    DIALOG_ARMOUR,
    DIALOG_VEHICLE,
    DIALOG_ANNINFO
};


enum EventInfo {
    Float:x_min,
    Float:x_max,
    Float:y_min,
    Float:letter_x,
    Float:letter_y,
    eWeaps[3] = 0,
    Float:eHealth,
    Float:eArmour,
    eVeh = 0,
    Float:eX,
    Float:eY,
    Float:eZ,
    eLock,
    eFreeze,
    eStart,
    eAnnounce,
    Text:eTD,
    Text:eTD2,
    Text:textdraw_0,
    Text:textdraw_1,
    Text:textdraw_2,
    Text:textdraw_3,
    Text:textdraw_4,
    Text:textdraw_5,
    Text:textdraw_6,
    Text:textdraw_7,
    Text:textdraw_8,
    Text:textdraw_9,
    Text:textdraw_10,
    Text:textdraw_11,
    Text:textdraw_12,
    Text:textdraw_13,
    Text:textdraw_14,
    Text:textdraw_15,
    Text:textdraw_16,
    Text:textdraw_17,
    Text:textdraw_18,
    Text:textdraw_19,
    Text:textdraw_20,
    Text:textdraw_21,
    Text:textdraw_22,
    Text:textdraw_23,
    Text:textdraw_24,
    bool:PlayersTPED,
    IsJoining[MAX_PLAYERS],
	pVeh[MAX_PLAYERS]
};
new eInfo[EventInfo];
new Visible[MAX_PLAYERS];

//================Public functions==================
public OnFilterScriptInit()
{
    eInfo[eWeaps][0] = 0;
    eInfo[eWeaps][1] = 0;
    eInfo[eWeaps][2] = 0;
    eInfo[eHealth] = 0;
    eInfo[eArmour] = 0;
    eInfo[eVeh] = 0;
    eInfo[eX] = 0.00000;
    eInfo[eY] = 0.00000;
    eInfo[eZ] = 0.00000;
    eInfo[eLock] = 0;
    eInfo[eStart] = 0;
    eInfo[eAnnounce] = 0;
    eInfo[eFreeze] = 0;
    eInfo[PlayersTPED] = false;
    for(new i = 0; i < 3;i++) eInfo[eWeaps][i] = 0;
    eInfo[x_min] = 415.5;
    eInfo[x_max] = 636.5;
    eInfo[y_min] = 300.5;
    eInfo[letter_x] = 0.45;
    eInfo[letter_y] = 1.6;

    CreateTDS();
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == eInfo[textdraw_13])
    {
        ShowPlayerDialog(playerid,DIALOG_WEAP,DIALOG_STYLE_INPUT,"Event Weapon 1","Enter the Weapon ID for the 1st weapon","Okay","Back");
    }
    if(clickedid == eInfo[textdraw_16])
    {
        ShowPlayerDialog(playerid,DIALOG_HEALTH,DIALOG_STYLE_INPUT,"Event Health","Enter the player's health for the event","Okay","Back");
    }
    if(clickedid == eInfo[textdraw_17])
    {
        ShowPlayerDialog(playerid,DIALOG_ARMOUR,DIALOG_STYLE_INPUT,"Event Health","Enter the player's armour for the event","Okay","Back");
    }
    if(clickedid == eInfo[textdraw_14])
    {
        ShowPlayerDialog(playerid,DIALOG_WEAP1,DIALOG_STYLE_INPUT,"Event Weapon 2","Enter the Weapon ID for the 2nd weapon","Okay","Back");
    }
    if(clickedid == eInfo[textdraw_15])
    {
        ShowPlayerDialog(playerid,DIALOG_WEAP2,DIALOG_STYLE_INPUT,"Event Weapon 3","Enter the Weapon ID for the 3rd weapon","Okay","Back");
    }
    if(clickedid == eInfo[textdraw_18])
    {
        ShowPlayerDialog(playerid,DIALOG_VEHICLE,DIALOG_STYLE_INPUT,"Event Vehicle","Enter the vehicle id for the event","Okay","Back");
    }
    if(clickedid == eInfo[textdraw_19])
    {
        GetPlayerPos(playerid, eInfo[eX], eInfo[eY], eInfo[eZ]);
        TextDrawSetString(eInfo[textdraw_19],"Set");
    }
    if(clickedid == eInfo[textdraw_20])
    {
        if(eInfo[eStart] == 1)
        {
            switch(eInfo[eLock])
            {
                case 0:
                {
                    eInfo[eLock] = 1;
                    SendClientMessageToAll(COLOR_YELLOW,"[EVENT] The event has been locked.");
                    TextDrawSetString(eInfo[textdraw_20],"Yes");
                }
                case 1:
                {
                    eInfo[eLock] = 0;
                    SendClientMessageToAll(COLOR_YELLOW,"[EVENT] The event has been unlocked.");
                    TextDrawSetString(eInfo[textdraw_20],"No");
                }
            }
        }
        else
        {
            SendClientMessage(playerid,COLOR_YELLOW,"Event should be started first.");
            eInfo[eLock] = 0;
        }
    }
    if(clickedid == eInfo[textdraw_11])
    {
        if(eInfo[eAnnounce] == 1 && eInfo[eLock] == 0)
        {
            switch(eInfo[eStart])
            {
                case 0:
                {
                    eInfo[eStart] = 1;
                    SendClientMessageToAll(COLOR_YELLOW,"[EVENT] An event has been started kindly see the event information box for more details.");
                    TextDrawSetString(eInfo[textdraw_11], "Cancel Event");
                }
                case 1:
                {
                    eInfo[eStart] = 0;
                    SendClientMessageToAll(COLOR_YELLOW,"[EVENT] The event has been cancelled.");
                    TextDrawSetString(eInfo[textdraw_11], "Start Event");
                    TextDrawHideForAll(eInfo[eTD]);
			        TextDrawHideForAll(eInfo[eTD2]);
			        eInfo[eWeaps][0] = 0;
			        eInfo[eWeaps][1] = 0;
			        eInfo[eWeaps][2] = 0;
			        eInfo[eHealth] = 0;
			        eInfo[eArmour] = 0;
			        eInfo[eVeh] = 0;
			        eInfo[eX] = 0.00000;
			        eInfo[eY] = 0.00000;
			        eInfo[eZ] = 0.00000;
			        eInfo[eLock] = 0;
			        eInfo[eStart] = 0;
			        eInfo[eAnnounce] = 0;
			        eInfo[eFreeze] = 0;
			        eInfo[PlayersTPED] = false;
			        
			        TextDrawSetString(eInfo[textdraw_21], "No");
                }
            }
        }
        else
        {
            SendClientMessage(playerid,COLOR_YELLOW,"Event should be announced/unlocked first.");
        }
    }
    if(clickedid == eInfo[textdraw_21])
    {
        switch(eInfo[eAnnounce])
        {
            case 0: ShowPlayerDialog(playerid,DIALOG_ANNINFO,DIALOG_STYLE_INPUT,"Event Announce","Type in event info to announce","Okay","Back");
            case 1:
            {
                eInfo[eAnnounce] = 0;
                TextDrawHideForAll(eInfo[eTD]);
                TextDrawHideForAll(eInfo[eTD2]);
                TextDrawSetString(eInfo[textdraw_21], "No");
            }
        }
    }
    if(clickedid == eInfo[textdraw_24])
    {
        if(eInfo[eLock] == 1 && eInfo[PlayersTPED] == false)
        {
            new count = 0;
            for(new i = 0, t = GetPlayerPoolSize(); i <= t; i++) if(eInfo[IsJoining][i] == 1)
            {
                ResetPlayerWeapons(i);
                SetPlayerPos(i,eInfo[eX],eInfo[eY],eInfo[eZ]);
                SetPlayerHealth(i,eInfo[eHealth]);
                SetPlayerArmour(i,eInfo[eArmour]);
                GivePlayerWeapon(i,eInfo[eWeaps][0],9999);
                GivePlayerWeapon(i,eInfo[eWeaps][1],9999);
                GivePlayerWeapon(i,eInfo[eWeaps][2],9999);
                if(eInfo[eVeh] != 0)
				{
					GiveVehicle(playerid,eInfo[eVeh]);
				}
                if(eInfo[eFreeze] == 1)
                {
                    TogglePlayerControllable(playerid,0);
                }
                count++;
            }
            if(!count) return SendClientMessage(playerid, COLOR_YELLOW, "No player has joined the event yet.");
			SendClientMessageToAll(COLOR_YELLOW, "All the event players have been teleported.");
            eInfo[PlayersTPED] = true;
        }
        else if(eInfo[eLock] == 0)
        {
            SendClientMessage(playerid,COLOR_YELLOW,"The event isn't locked!");
        }
        else if(eInfo[PlayersTPED] == true)
        {
            SendClientMessage(playerid,COLOR_YELLOW,"The player's are already teleported!");
        }
    }
    if(clickedid == eInfo[textdraw_12])
    {
        for(new i;i<MAX_PLAYERS;i++) if(eInfo[IsJoining][i] == 1 && IsPlayerConnected(i))
        {
            DestroyVehicle(eInfo[pVeh][i]);
            eInfo[IsJoining][i] = 0;
            SpawnPlayer(i);
        }
        TextDrawHideForAll(eInfo[eTD]);
        TextDrawHideForAll(eInfo[eTD2]);
        eInfo[eWeaps][0] = 0;
        eInfo[eWeaps][1] = 0;
        eInfo[eWeaps][2] = 0;
        eInfo[eHealth] = 0;
        eInfo[eArmour] = 0;
        eInfo[eVeh] = 0;
        eInfo[eX] = 0.00000;
        eInfo[eY] = 0.00000;
        eInfo[eZ] = 0.00000;
        eInfo[eLock] = 0;
        eInfo[eStart] = 0;
        eInfo[eAnnounce] = 0;
        eInfo[eFreeze] = 0;
        eInfo[PlayersTPED] = false;
        
        TextDrawSetString(eInfo[textdraw_21], "No");
    }
    if(clickedid == eInfo[textdraw_23])
    {
        switch(eInfo[eFreeze])
        {
            case 0:
            {
                eInfo[eFreeze] = 1;
                TextDrawSetString(eInfo[textdraw_23], "Yes");
            }
            case 1:
            {
                eInfo[eFreeze] = 0;
                TextDrawSetString(eInfo[textdraw_23], "No");
            }
        }
    }



    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_HEALTH:
        {
            if(response)
            {
                eInfo[eHealth] = floatstr(inputtext);
                TextDrawSetString(eInfo[textdraw_16],inputtext);
            }
        }
        case DIALOG_ARMOUR:
        {
            if(response)
            {
                eInfo[eArmour] = floatstr(inputtext);
                TextDrawSetString(eInfo[textdraw_17],inputtext);
            }
        }
        case DIALOG_VEHICLE:
        {
            if(response)
            {
                eInfo[eVeh] = strval(inputtext);
                TextDrawSetString(eInfo[textdraw_18],inputtext);
            }
        }
        case DIALOG_WEAP:
        {
            if(response)
            {
                eInfo[eWeaps][0] = strval(inputtext);
                TextDrawSetString(eInfo[textdraw_13],inputtext);
            }
        }
        case DIALOG_WEAP1:
        {
            if(response)
            {
                eInfo[eWeaps][1] = strval(inputtext);
                TextDrawSetString(eInfo[textdraw_14],inputtext);
            }
        }
        case DIALOG_WEAP2:
        {
            if(response)
            {
                eInfo[eWeaps][2] = strval(inputtext);
                TextDrawSetString(eInfo[textdraw_15],inputtext);
            }
        }
        case DIALOG_ANNINFO:
        {
            if(response)
            {
                eInfo[eAnnounce] = 1;
                TextDrawShowForAll(eInfo[eTD]);
                TextDrawShowForAll(eInfo[eTD2]);
                TextDrawSetString(eInfo[eTD2], "EVENT INFO");
                TextDrawSetString(eInfo[eTD], inputtext);
                TextDrawSetString(eInfo[textdraw_21], "Yes");

            }
        }
    }
    return 1;
}

//==================Commands===================
CMD:event(playerid)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_YELLOW,"You are not allowed to use this command.");
    switch(Visible[playerid])
    {
        case 0: { ShowEventTD(playerid); Visible[playerid] = 1; }
        case 1: { HideEventTD(playerid); CancelSelectTextDraw(playerid); Visible[playerid] = 0; }
    }
    return 1;
}

CMD:joinevent(playerid)
{
    if(eInfo[eStart] != 1) return SendClientMessage(playerid,COLOR_YELLOW,"There is no active event yet.");

    if(eInfo[eLock] != 1 && eInfo[IsJoining][playerid] == 0)
    {
        eInfo[IsJoining][playerid] = 1;
        SendClientMessage(playerid,COLOR_YELLOW,"[EVENT] Kindly wait for the teleportation.");
    }
    else if(eInfo[eLock] == 1)
    {
        SendClientMessage(playerid,COLOR_YELLOW,"The event has been locked, you can't join it now!");
    }
    return 1;
}
//----------------------------------- STOCKS
stock ShowEventTD(playerid)
{
    TextDrawShowForPlayer(playerid, eInfo[textdraw_0]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_1]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_2]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_3]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_4]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_5]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_6]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_7]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_8]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_9]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_10]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_11]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_12]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_13]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_14]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_15]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_16]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_17]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_18]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_19]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_20]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_21]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_22]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_23]);
    TextDrawShowForPlayer(playerid, eInfo[textdraw_24]);
    SelectTextDraw(playerid, 0xFF0000FF);
    return 1;
}

stock HideEventTD(playerid)
{
    TextDrawHideForPlayer(playerid, eInfo[textdraw_0]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_1]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_2]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_3]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_4]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_5]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_6]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_7]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_8]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_9]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_10]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_11]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_12]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_13]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_14]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_15]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_16]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_17]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_18]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_19]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_20]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_21]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_22]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_23]);
    TextDrawHideForPlayer(playerid, eInfo[textdraw_24]);
    return 1;
}

stock GiveVehicle(playerid,vehicleid)
{
    if(!IsPlayerInAnyVehicle(playerid))
    {
        new Float:x, Float:y, Float:z, Float:angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);
        eInfo[pVeh][playerid] = CreateVehicle(vehicleid, x, y, z, angle, -1, -1, -1);
        SetVehicleVirtualWorld(eInfo[pVeh][playerid], GetPlayerVirtualWorld(playerid));
        SetVehiclePos(eInfo[pVeh][playerid], eInfo[eX], eInfo[eY], eInfo[eZ]);
        LinkVehicleToInterior(eInfo[pVeh][playerid], GetPlayerInterior(playerid));
        PutPlayerInVehicle(playerid, eInfo[pVeh][playerid], 0);
    }
    return 1;
}

stock CreateTDS()
{
    eInfo[eTD] = TextDrawCreate(eInfo[x_min], eInfo[y_min] + eInfo[letter_y] / 0.135 + 5.0, " 1~n~ 2~n~ 3~n~ 4~n~ 5~n~ 6~n~ 7~n~ 8~n~ 9~n~ 10");
    TextDrawLetterSize(eInfo[eTD], eInfo[letter_x] * 0.8, eInfo[letter_y] * 0.8);
    TextDrawTextSize(eInfo[eTD], eInfo[x_max], 0.0);
    TextDrawAlignment(eInfo[eTD], 1);
    TextDrawUseBox(eInfo[eTD], true);
    TextDrawBoxColor(eInfo[eTD], 0xFF060635);
    TextDrawFont(eInfo[eTD], 1);
    TextDrawColor(eInfo[eTD], -1);
    TextDrawSetShadow(eInfo[eTD], 0);
    TextDrawSetOutline(eInfo[eTD], 1);
    TextDrawSetProportional(eInfo[eTD], 1);
    TextDrawBackgroundColor(eInfo[eTD], 0x33);

    eInfo[eTD2] = TextDrawCreate(((eInfo[x_max] + eInfo[x_min]) / 2.0), eInfo[y_min], "TEST INFO");
    TextDrawLetterSize(eInfo[eTD2], eInfo[letter_x], eInfo[letter_y]);
    TextDrawTextSize(eInfo[eTD2], 0.0, eInfo[x_max] - eInfo[x_min]);
    TextDrawAlignment(eInfo[eTD2], 2);
    TextDrawUseBox(eInfo[eTD2], true);
    TextDrawBoxColor(eInfo[eTD2], 0xFF0606FF);
    TextDrawFont(eInfo[eTD2], 1);
    TextDrawColor(eInfo[eTD2], -1);
    TextDrawSetShadow(eInfo[eTD2], 0);
    TextDrawSetOutline(eInfo[eTD2], 1);
    TextDrawSetProportional(eInfo[eTD2], 1);
    TextDrawBackgroundColor(eInfo[eTD2], 0x33);


    eInfo[textdraw_0] = TextDrawCreate(324.000000, 64.000000, "_");
    TextDrawFont(eInfo[textdraw_0], 1);
    TextDrawLetterSize(eInfo[textdraw_0], 0.600000, 35.999923);
    TextDrawTextSize(eInfo[textdraw_0], 298.500000, 175.000000);
    TextDrawSetOutline(eInfo[textdraw_0], 1);
    TextDrawSetShadow(eInfo[textdraw_0], 0);
    TextDrawAlignment(eInfo[textdraw_0], 2);
    TextDrawColor(eInfo[textdraw_0], -1);
    TextDrawBackgroundColor(eInfo[textdraw_0], 255);
    TextDrawBoxColor(eInfo[textdraw_0], 135);
    TextDrawUseBox(eInfo[textdraw_0], 1);
    TextDrawSetProportional(eInfo[textdraw_0], 1);
    TextDrawSetSelectable(eInfo[textdraw_0], 0);

    eInfo[textdraw_1] = TextDrawCreate(324.000000, 63.000000, "Event System");
    TextDrawFont(eInfo[textdraw_1], 1);
    TextDrawLetterSize(eInfo[textdraw_1], 0.329165, 1.850000);
    TextDrawTextSize(eInfo[textdraw_1], 400.000000, 172.500000);
    TextDrawSetOutline(eInfo[textdraw_1], 2);
    TextDrawSetShadow(eInfo[textdraw_1], 0);
    TextDrawAlignment(eInfo[textdraw_1], 2);
    TextDrawColor(eInfo[textdraw_1], -8388353);
    TextDrawBackgroundColor(eInfo[textdraw_1], 255);
    TextDrawBoxColor(eInfo[textdraw_1], 50);
    TextDrawUseBox(eInfo[textdraw_1], 1);
    TextDrawSetProportional(eInfo[textdraw_1], 1);
    TextDrawSetSelectable(eInfo[textdraw_1], 0);

    eInfo[textdraw_2] = TextDrawCreate(282.000000, 113.000000, "Event Weapon I:");
    TextDrawFont(eInfo[textdraw_2], 1);
    TextDrawLetterSize(eInfo[textdraw_2], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_2], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_2], 1);
    TextDrawSetShadow(eInfo[textdraw_2], 0);
    TextDrawAlignment(eInfo[textdraw_2], 2);
    TextDrawColor(eInfo[textdraw_2], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_2], 255);
    TextDrawBoxColor(eInfo[textdraw_2], 50);
    TextDrawUseBox(eInfo[textdraw_2], 0);
    TextDrawSetProportional(eInfo[textdraw_2], 1);
    TextDrawSetSelectable(eInfo[textdraw_2], 0);

    eInfo[textdraw_3] = TextDrawCreate(283.000000, 133.000000, "Event Weapon II:");
    TextDrawFont(eInfo[textdraw_3], 1);
    TextDrawLetterSize(eInfo[textdraw_3], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_3], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_3], 1);
    TextDrawSetShadow(eInfo[textdraw_3], 0);
    TextDrawAlignment(eInfo[textdraw_3], 2);
    TextDrawColor(eInfo[textdraw_3], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_3], 255);
    TextDrawBoxColor(eInfo[textdraw_3], 50);
    TextDrawUseBox(eInfo[textdraw_3], 0);
    TextDrawSetProportional(eInfo[textdraw_3], 1);
    TextDrawSetSelectable(eInfo[textdraw_3], 0);

    eInfo[textdraw_4] = TextDrawCreate(284.000000, 152.000000, "Event Weapon III:");
    TextDrawFont(eInfo[textdraw_4], 1);
    TextDrawLetterSize(eInfo[textdraw_4], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_4], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_4], 1);
    TextDrawSetShadow(eInfo[textdraw_4], 0);
    TextDrawAlignment(eInfo[textdraw_4], 2);
    TextDrawColor(eInfo[textdraw_4], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_4], 255);
    TextDrawBoxColor(eInfo[textdraw_4], 50);
    TextDrawUseBox(eInfo[textdraw_4], 0);
    TextDrawSetProportional(eInfo[textdraw_4], 1);
    TextDrawSetSelectable(eInfo[textdraw_4], 0);

    eInfo[textdraw_5] = TextDrawCreate(278.000000, 170.000000, "Default Health:");
    TextDrawFont(eInfo[textdraw_5], 1);
    TextDrawLetterSize(eInfo[textdraw_5], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_5], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_5], 1);
    TextDrawSetShadow(eInfo[textdraw_5], 0);
    TextDrawAlignment(eInfo[textdraw_5], 2);
    TextDrawColor(eInfo[textdraw_5], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_5], 255);
    TextDrawBoxColor(eInfo[textdraw_5], 50);
    TextDrawUseBox(eInfo[textdraw_5], 0);
    TextDrawSetProportional(eInfo[textdraw_5], 1);
    TextDrawSetSelectable(eInfo[textdraw_5], 0);

    eInfo[textdraw_6] = TextDrawCreate(280.000000, 189.000000, "Default Armour:");
    TextDrawFont(eInfo[textdraw_6], 1);
    TextDrawLetterSize(eInfo[textdraw_6], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_6], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_6], 1);
    TextDrawSetShadow(eInfo[textdraw_6], 0);
    TextDrawAlignment(eInfo[textdraw_6], 2);
    TextDrawColor(eInfo[textdraw_6], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_6], 255);
    TextDrawBoxColor(eInfo[textdraw_6], 50);
    TextDrawUseBox(eInfo[textdraw_6], 0);
    TextDrawSetProportional(eInfo[textdraw_6], 1);
    TextDrawSetSelectable(eInfo[textdraw_6], 0);

    eInfo[textdraw_7] = TextDrawCreate(276.000000, 208.000000, "Event Vehicle:");
    TextDrawFont(eInfo[textdraw_7], 1);
    TextDrawLetterSize(eInfo[textdraw_7], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_7], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_7], 1);
    TextDrawSetShadow(eInfo[textdraw_7], 0);
    TextDrawAlignment(eInfo[textdraw_7], 2);
    TextDrawColor(eInfo[textdraw_7], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_7], 255);
    TextDrawBoxColor(eInfo[textdraw_7], 50);
    TextDrawUseBox(eInfo[textdraw_7], 0);
    TextDrawSetProportional(eInfo[textdraw_7], 1);
    TextDrawSetSelectable(eInfo[textdraw_7], 0);

    eInfo[textdraw_8] = TextDrawCreate(277.000000, 227.000000, "Event Position:");
    TextDrawFont(eInfo[textdraw_8], 1);
    TextDrawLetterSize(eInfo[textdraw_8], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_8], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_8], 1);
    TextDrawSetShadow(eInfo[textdraw_8], 0);
    TextDrawAlignment(eInfo[textdraw_8], 2);
    TextDrawColor(eInfo[textdraw_8], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_8], 255);
    TextDrawBoxColor(eInfo[textdraw_8], 50);
    TextDrawUseBox(eInfo[textdraw_8], 0);
    TextDrawSetProportional(eInfo[textdraw_8], 1);
    TextDrawSetSelectable(eInfo[textdraw_8], 0);

    eInfo[textdraw_9] = TextDrawCreate(275.000000, 247.000000, "Event Locked:");
    TextDrawFont(eInfo[textdraw_9], 1);
    TextDrawLetterSize(eInfo[textdraw_9], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_9], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_9], 1);
    TextDrawSetShadow(eInfo[textdraw_9], 0);
    TextDrawAlignment(eInfo[textdraw_9], 2);
    TextDrawColor(eInfo[textdraw_9], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_9], 255);
    TextDrawBoxColor(eInfo[textdraw_9], 50);
    TextDrawUseBox(eInfo[textdraw_9], 0);
    TextDrawSetProportional(eInfo[textdraw_9], 1);
    TextDrawSetSelectable(eInfo[textdraw_9], 0);

    eInfo[textdraw_10] = TextDrawCreate(285.000000, 267.000000, "Event Announced:");
    TextDrawFont(eInfo[textdraw_10], 1);
    TextDrawLetterSize(eInfo[textdraw_10], 0.320832, 1.599997);
    TextDrawTextSize(eInfo[textdraw_10], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_10], 1);
    TextDrawSetShadow(eInfo[textdraw_10], 0);
    TextDrawAlignment(eInfo[textdraw_10], 2);
    TextDrawColor(eInfo[textdraw_10], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_10], 255);
    TextDrawBoxColor(eInfo[textdraw_10], 50);
    TextDrawUseBox(eInfo[textdraw_10], 0);
    TextDrawSetProportional(eInfo[textdraw_10], 1);
    TextDrawSetSelectable(eInfo[textdraw_10], 0);

    eInfo[textdraw_11] = TextDrawCreate(321.000000, 297.000000, "Start Event");
    TextDrawFont(eInfo[textdraw_11], 1);
    TextDrawLetterSize(eInfo[textdraw_11], 0.320832, 1.599998);
    TextDrawTextSize(eInfo[textdraw_11], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_11], 1);
    TextDrawSetShadow(eInfo[textdraw_11], 0);
    TextDrawAlignment(eInfo[textdraw_11], 2);
    TextDrawColor(eInfo[textdraw_11], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_11], 255);
    TextDrawBoxColor(eInfo[textdraw_11], 50);
    TextDrawUseBox(eInfo[textdraw_11], 1);
    TextDrawSetProportional(eInfo[textdraw_11], 1);
    TextDrawSetSelectable(eInfo[textdraw_11], 1);

    eInfo[textdraw_12] = TextDrawCreate(321.000000, 365.000000, "Finish Event");
    TextDrawFont(eInfo[textdraw_12], 1);
    TextDrawLetterSize(eInfo[textdraw_12], 0.320832, 1.599998);
    TextDrawTextSize(eInfo[textdraw_12], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_12], 1);
    TextDrawSetShadow(eInfo[textdraw_12], 0);
    TextDrawAlignment(eInfo[textdraw_12], 2);
    TextDrawColor(eInfo[textdraw_12], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_12], 255);
    TextDrawBoxColor(eInfo[textdraw_12], 50);
    TextDrawUseBox(eInfo[textdraw_12], 1);
    TextDrawSetProportional(eInfo[textdraw_12], 1);
    TextDrawSetSelectable(eInfo[textdraw_12], 1);

    eInfo[textdraw_13] = TextDrawCreate(371.000000, 114.000000, "100");
    TextDrawFont(eInfo[textdraw_13], 1);
    TextDrawLetterSize(eInfo[textdraw_13], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_13], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_13], 1);
    TextDrawSetShadow(eInfo[textdraw_13], 0);
    TextDrawAlignment(eInfo[textdraw_13], 2);
    TextDrawColor(eInfo[textdraw_13], -1);
    TextDrawBackgroundColor(eInfo[textdraw_13], 255);
    TextDrawBoxColor(eInfo[textdraw_13], 50);
    TextDrawUseBox(eInfo[textdraw_13], 0);
    TextDrawSetProportional(eInfo[textdraw_13], 1);
    TextDrawSetSelectable(eInfo[textdraw_13], 1);

    eInfo[textdraw_14] = TextDrawCreate(371.000000, 134.000000, "100");
    TextDrawFont(eInfo[textdraw_14], 1);
    TextDrawLetterSize(eInfo[textdraw_14], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_14], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_14], 1);
    TextDrawSetShadow(eInfo[textdraw_14], 0);
    TextDrawAlignment(eInfo[textdraw_14], 2);
    TextDrawColor(eInfo[textdraw_14], -1);
    TextDrawBackgroundColor(eInfo[textdraw_14], 255);
    TextDrawBoxColor(eInfo[textdraw_14], 50);
    TextDrawUseBox(eInfo[textdraw_14], 0);
    TextDrawSetProportional(eInfo[textdraw_14], 1);
    TextDrawSetSelectable(eInfo[textdraw_14], 1);

    eInfo[textdraw_15] = TextDrawCreate(371.000000, 153.000000, "100");
    TextDrawFont(eInfo[textdraw_15], 1);
    TextDrawLetterSize(eInfo[textdraw_15], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_15], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_15], 1);
    TextDrawSetShadow(eInfo[textdraw_15], 0);
    TextDrawAlignment(eInfo[textdraw_15], 2);
    TextDrawColor(eInfo[textdraw_15], -1);
    TextDrawBackgroundColor(eInfo[textdraw_15], 255);
    TextDrawBoxColor(eInfo[textdraw_15], 50);
    TextDrawUseBox(eInfo[textdraw_15], 0);
    TextDrawSetProportional(eInfo[textdraw_15], 1);
    TextDrawSetSelectable(eInfo[textdraw_15], 1);

    eInfo[textdraw_16] = TextDrawCreate(375.000000, 172.000000, "100.0");
    TextDrawFont(eInfo[textdraw_16], 1);
    TextDrawLetterSize(eInfo[textdraw_16], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_16], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_16], 1);
    TextDrawSetShadow(eInfo[textdraw_16], 0);
    TextDrawAlignment(eInfo[textdraw_16], 2);
    TextDrawColor(eInfo[textdraw_16], -1);
    TextDrawBackgroundColor(eInfo[textdraw_16], 255);
    TextDrawBoxColor(eInfo[textdraw_16], 50);
    TextDrawUseBox(eInfo[textdraw_16], 0);
    TextDrawSetProportional(eInfo[textdraw_16], 1);
    TextDrawSetSelectable(eInfo[textdraw_16], 1);

    eInfo[textdraw_17] = TextDrawCreate(375.000000, 190.000000, "100.0");
    TextDrawFont(eInfo[textdraw_17], 1);
    TextDrawLetterSize(eInfo[textdraw_17], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_17], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_17], 1);
    TextDrawSetShadow(eInfo[textdraw_17], 0);
    TextDrawAlignment(eInfo[textdraw_17], 2);
    TextDrawColor(eInfo[textdraw_17], -1);
    TextDrawBackgroundColor(eInfo[textdraw_17], 255);
    TextDrawBoxColor(eInfo[textdraw_17], 50);
    TextDrawUseBox(eInfo[textdraw_17], 0);
    TextDrawSetProportional(eInfo[textdraw_17], 1);
    TextDrawSetSelectable(eInfo[textdraw_17], 1);

    eInfo[textdraw_18] = TextDrawCreate(375.000000, 209.000000, "700");
    TextDrawFont(eInfo[textdraw_18], 1);
    TextDrawLetterSize(eInfo[textdraw_18], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_18], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_18], 1);
    TextDrawSetShadow(eInfo[textdraw_18], 0);
    TextDrawAlignment(eInfo[textdraw_18], 2);
    TextDrawColor(eInfo[textdraw_18], -1);
    TextDrawBackgroundColor(eInfo[textdraw_18], 255);
    TextDrawBoxColor(eInfo[textdraw_18], 50);
    TextDrawUseBox(eInfo[textdraw_18], 0);
    TextDrawSetProportional(eInfo[textdraw_18], 1);
    TextDrawSetSelectable(eInfo[textdraw_18], 1);

    eInfo[textdraw_19] = TextDrawCreate(375.000000, 228.000000, "Unknown");
    TextDrawFont(eInfo[textdraw_19], 1);
    TextDrawLetterSize(eInfo[textdraw_19], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_19], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_19], 1);
    TextDrawSetShadow(eInfo[textdraw_19], 0);
    TextDrawAlignment(eInfo[textdraw_19], 2);
    TextDrawColor(eInfo[textdraw_19], -1);
    TextDrawBackgroundColor(eInfo[textdraw_19], 255);
    TextDrawBoxColor(eInfo[textdraw_19], 50);
    TextDrawUseBox(eInfo[textdraw_19], 0);
    TextDrawSetProportional(eInfo[textdraw_19], 1);
    TextDrawSetSelectable(eInfo[textdraw_19], 1);

    eInfo[textdraw_20] = TextDrawCreate(375.000000, 248.000000, "No");
    TextDrawFont(eInfo[textdraw_20], 1);
    TextDrawLetterSize(eInfo[textdraw_20], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_20], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_20], 1);
    TextDrawSetShadow(eInfo[textdraw_20], 0);
    TextDrawAlignment(eInfo[textdraw_20], 2);
    TextDrawColor(eInfo[textdraw_20], -1);
    TextDrawBackgroundColor(eInfo[textdraw_20], 255);
    TextDrawBoxColor(eInfo[textdraw_20], 50);
    TextDrawUseBox(eInfo[textdraw_20], 0);
    TextDrawSetProportional(eInfo[textdraw_20], 1);
    TextDrawSetSelectable(eInfo[textdraw_20], 1);

    eInfo[textdraw_21] = TextDrawCreate(375.000000, 268.000000, "No");
    TextDrawFont(eInfo[textdraw_21], 1);
    TextDrawLetterSize(eInfo[textdraw_21], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_21], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_21], 1);
    TextDrawSetShadow(eInfo[textdraw_21], 0);
    TextDrawAlignment(eInfo[textdraw_21], 2);
    TextDrawColor(eInfo[textdraw_21], -1);
    TextDrawBackgroundColor(eInfo[textdraw_21], 255);
    TextDrawBoxColor(eInfo[textdraw_21], 50);
    TextDrawUseBox(eInfo[textdraw_21], 0);
    TextDrawSetProportional(eInfo[textdraw_21], 1);
    TextDrawSetSelectable(eInfo[textdraw_21], 1);

    eInfo[textdraw_22] = TextDrawCreate(281.000000, 95.000000, "Freeze Players:");
    TextDrawFont(eInfo[textdraw_22], 1);
    TextDrawLetterSize(eInfo[textdraw_22], 0.320832, 1.599998);
    TextDrawTextSize(eInfo[textdraw_22], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_22], 1);
    TextDrawSetShadow(eInfo[textdraw_22], 0);
    TextDrawAlignment(eInfo[textdraw_22], 2);
    TextDrawColor(eInfo[textdraw_22], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_22], 255);
    TextDrawBoxColor(eInfo[textdraw_22], 50);
    TextDrawUseBox(eInfo[textdraw_22], 0);
    TextDrawSetProportional(eInfo[textdraw_22], 1);
    TextDrawSetSelectable(eInfo[textdraw_22], 0);

    eInfo[textdraw_23] = TextDrawCreate(371.000000, 97.000000, "No");
    TextDrawFont(eInfo[textdraw_23], 1);
    TextDrawLetterSize(eInfo[textdraw_23], 0.366667, 1.600000);
    TextDrawTextSize(eInfo[textdraw_23], 8.500000, 61.500000);
    TextDrawSetOutline(eInfo[textdraw_23], 1);
    TextDrawSetShadow(eInfo[textdraw_23], 0);
    TextDrawAlignment(eInfo[textdraw_23], 2);
    TextDrawColor(eInfo[textdraw_23], -1);
    TextDrawBackgroundColor(eInfo[textdraw_23], 255);
    TextDrawBoxColor(eInfo[textdraw_23], 50);
    TextDrawUseBox(eInfo[textdraw_23], 0);
    TextDrawSetProportional(eInfo[textdraw_23], 1);
    TextDrawSetSelectable(eInfo[textdraw_23], 1);

    eInfo[textdraw_24] = TextDrawCreate(321.000000, 330.000000, "Get Event Players");
    TextDrawFont(eInfo[textdraw_24], 1);
    TextDrawLetterSize(eInfo[textdraw_24], 0.320832, 1.599998);
    TextDrawTextSize(eInfo[textdraw_24], 8.500000, 86.500000);
    TextDrawSetOutline(eInfo[textdraw_24], 1);
    TextDrawSetShadow(eInfo[textdraw_24], 0);
    TextDrawAlignment(eInfo[textdraw_24], 2);
    TextDrawColor(eInfo[textdraw_24], 1687547391);
    TextDrawBackgroundColor(eInfo[textdraw_24], 255);
    TextDrawBoxColor(eInfo[textdraw_24], 50);
    TextDrawUseBox(eInfo[textdraw_24], 1);
    TextDrawSetProportional(eInfo[textdraw_24], 1);
    TextDrawSetSelectable(eInfo[textdraw_24], 1);

}



