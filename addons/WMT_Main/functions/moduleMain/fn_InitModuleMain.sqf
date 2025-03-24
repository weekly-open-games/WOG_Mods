/*
    Name: WMT_fnc_InitModuleMain

    Author(s):
        Ezhuk

    Description:
        Initialize main module
*/
#include "defines_IDC.sqf"
#include "..\defines_KEY.sqf"

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if(_activated) then {
    if ( not isNil "wmt_Main_ModuleRunning" ) exitWith {
        diag_log "WMT_fnc_InitModuleMain: double initialization";
    };
    wmt_Main_ModuleRunning = true;

    if (isNil "wmt_param_TI") then {
        wmt_param_TI = _logic getVariable "TI";
    };
    if (isNil "wmt_param_MaxViewDistance") then {
        wmt_param_MaxViewDistance = _logic getVariable "MaxViewDistance";
    };
    if (isNil "wmt_param_MaxViewDistanceTerrain") then {
        wmt_param_MaxViewDistanceTerrain = _logic getVariable ["MaxViewDistanceTerrain", 10000];
    };
    if (isNil "wmt_param_NameTag") then {
        wmt_param_NameTag = _logic getVariable "NameTag";
    };
    if (isNil "wmt_param_IndetifyTheBody") then {
        wmt_param_IndetifyTheBody = _logic getVariable ["IndetifyTheBody",1];
    };
    if (isNil "wmt_param_TotalDominationCoeff") then {
        wmt_param_TotalDominationCoeff = _logic getVariable ["TotalDominationCoeff", -1];
    };
    if (isNil "wmt_param_HeavyLossesCoeff") then {
        wmt_param_HeavyLossesCoeff = _logic getVariable "HeavyLossesCoeff";
    };
    if(isNil "wmt_param_ShowEnemyVehiclesInNotes") then {
        wmt_param_ShowEnemyVehiclesInNotes = _logic getVariable "ShowEnemyVehiclesInNotes";
    };
    if (isNil "wmt_param_GenerateFrequencies") then {
        wmt_param_GenerateFrequencies = _logic getVariable "GenerateFrequencies";
    };
    if (isNil "wmt_param_AI") then {
        wmt_param_AI = _logic getVariable "AI";
    };
    if (isNil "wmt_param_ShowVehiclesBriefing") then {
        wmt_param_ShowVehiclesBriefing = _logic getVariable "ShowVehiclesBriefing";
    };
    if (isNil "wmt_param_ShowSquadsBriefing") then {
        wmt_param_ShowSquadsBriefing = _logic getVariable "ShowSquadsBriefing";
    };
    if (isNil "wmt_param_Statistic") then {
        wmt_param_Statistic = _logic getVariable "Statistic";
    };
    if (isNil "wmt_param_ExtendedBriefing") then {
        wmt_param_ExtendedBriefing = _logic getVariable ["ExtendedBriefing", 1];
    };
    if (isNil "wmt_param_DisableChannels") then {
        wmt_param_DisableChannels = _logic getVariable ["DisableChannels", "0,2,4,5"];
    };
    if (isNil "wmt_param_AutoMedicine") then {
        wmt_param_AutoMedicine = _logic getVariable ["AutoMedicine", true];
    };
    if (isNil "wmt_param_SideChannelByLR") then {
        wmt_param_SideChannelByLR = _logic getVariable ["SideChannelByLR", true];
    };
    if (isNil "wmt_param_DisableFuelStations") then {
        wmt_param_DisableFuelStations = _logic getVariable ["DisableFuelSt", false];
    };
    if (isNil "wmt_param_DisableBreifingMarkerMove") then {
        wmt_param_DisableBreifingMarkerMove = _logic getVariable ["DisableBreifingMarkerMove", false];
    };

    wmt_param_MaxViewDistance  = 10 max wmt_param_MaxViewDistance;
    wmt_param_HeavyLossesCoeff = 0 max wmt_param_HeavyLossesCoeff;

    if (wmt_param_AI==0) then {
        [] call WMT_fnc_DisableAI;
    };

    // Disable channels
    {
        _x enableChannel [false, false];
    } forEach (call compile format ["[%1]", wmt_param_DisableChannels]);

    //================================================
    //                  SERVER
    //================================================
    if (isServer) then {
        [] spawn {
            setViewDistance wmt_param_MaxViewDistance;

            // Set terrain grid for server
            // Not sure if this actually does anything, but why not
            private _precision = 10;
            private _hillyIslands = [
                // "MCN_Aliabad",
                "lingor3",
                "lythium",
                "sara",
                "saralite",
                "Mountains_ACR",
                "sara_dbe1",
                "zargabad",
                "takistan",
                "fata",
                "Shapur_BAF",
                "Altis",
                "Stratis",
                "reshmaan",
                "Napf",
                "NapfWinter",
                "Caribou",
                "tem_anizay",
                "rof_mok",
                "malden",
                // "Farabad",
                "NorthTakistan"
				
            ];

            if (worldName in _hillyIslands) then {
                _precision = 3.125
            };
            setTerrainGrid _precision;

            if (wmt_param_GenerateFrequencies == 1) then {
                [] spawn WMT_fnc_DefaultFreqsServer;
            };

            ["vehicle", [(wmt_param_TI>0)]] call WMT_fnc_DisableTI;

            [wmt_param_HeavyLossesCoeff] spawn WMT_fnc_HeavyLossesCheck;

            // briefing
            if (wmt_param_ExtendedBriefing == 1) then {
                [] spawn wmt_fnc_preparebriefinginfo;
            };

            if (wmt_param_DisableFuelStations) then {
                [] call WMT_fnc_DisableFuelStations;
            };

            addMissionEventHandler ["HandleDisconnect", {
                params ["_unit"];
                _unit disableAI "AUTOTARGET";
                _unit disableAI "TARGET";
                _unit disableAI "FSM";
                _unit disableAI "MOVE";
                _unit stop true;
                _unit setBehaviour "CARELESS";
                _unit allowFleeing 0;
                _unit disableConversation true;
                _unit setVariable ["BIS_noCoreConversations", false];
                _unit setSpeaker "NoVoice";
            }];
        };
    };

    //================================================
    //                  CLIENT
    //================================================
    if (!isDedicated) then {
        [] spawn {
            waitUntil{!isNull player};

            "WMT_fnc_InitModuleMain started" call Bis_fnc_log;

            WMT_Local_PlayerName = name player;

            if (player getVariable ["PlayerName", ""] != WMT_Local_PlayerName) then {
                player setVariable ["PlayerName",WMT_Local_PlayerName,true];
            };

            if (isNil {player getVariable "playerSide"}) then {
                player setVariable ["playerSide",playerSide,true];
            };

            WMT_Local_Killer = [];
            WMT_Local_Kills = [];

            [] call WMT_fnc_HideSideMarkers;
            [] call WMT_fnc_HideUserMarkers;

            ["preinit"] spawn WMT_fnc_handlerOptions;

            // Update information about admin (1 time in 15s)
            ["loop"] spawn WMT_fnc_handlerFeedback;

            // Disable TI with using RscTitle
            if(wmt_param_TI == 2) then {
                IDD_DISABLETI cutRsc ["RscWMTDisableTI","PLAIN"];
            };

            // Show tag with name for near unit
            if(wmt_param_NameTag>0) then {
                IDD_NAMETAG cutRsc ["RscWMTNameTag","PLAIN"];
            };

            // Save positive rating
            player addEventHandler ["HandleRating","if((rating player)<-(_this select 1))then{-(rating player)}else{_this}"];

            // Key binding with cba
            #include "keyBinding.sqf"

            [] spawn WMT_fnc_BriefingTimer;
            [] spawn WMT_fnc_BriefingPlayerCount;

            player addEventHandler ["Killed", "_this spawn WMT_fnc_PlayerKilled"];
            player addEventHandler [
                "HandleDamage",
                { if (alive (_this select 0)) then {WMT_Local_LastDamageSource = effectiveCommander (_this select 3);}; }
            ];

            // Public variable handlers
            "WMT_Global_Announcement" addPublicVariableEventHandler { (_this select 1) call WMT_fnc_Announcement };

            "WMT_Global_ToAdmin" addPublicVariableEventHandler {
                if(serverCommandAvailable("#kick")) then {
                    (_this select 1) call WMT_fnc_Announcement;
                    diag_log (_this select 1);
                };
            };

            // briefing
            [] call WMT_fnc_BriefingMissionParameters;

            if (wmt_param_ExtendedBriefing == 1) then {
                [] spawn wmt_fnc_showbriefinginfo;
                [] call WMT_fnc_BriefingMissionExtendedTasks;
            };

            // Show frequencies
            if (wmt_param_GenerateFrequencies == 1) then {
                [] spawn WMT_fnc_DefaultFreqsClient;
            };

            // swt_markers
            private _arr = [localize "str_channel_global",localize "str_channel_side",localize "str_channel_command",
                            localize "str_channel_group",localize "str_channel_vehicle",localize "str_channel_direct"];
            swt_markers_available_channels = [];
            {
                if ((channelEnabled _forEachIndex) select 0) then {
                    swt_markers_available_channels pushBack _x;
                };
            } forEach _arr;

            [] spawn {
                waitUntil{sleep 0.36; !(isNull (findDisplay 46))};
                // Show list of vehicle crew
                (findDisplay 46) displayAddEventHandler ["MouseZChanged","_this call WMT_fnc_KeyHandlerShowCrew;"];

                // Set terrain grid on initial connection
                private _precision = 10;
                private _hillyIslands = [
                    // "MCN_Aliabad",
                    "lingor3",
                    "lythium",
                    "sara",
                    "saralite",
                    "Mountains_ACR",
                    "sara_dbe1",
                    "zargabad",
                    "takistan",
                    "fata",
                    "Shapur_BAF",
                    "Altis",
                    "Stratis",
                    "reshmaan",
                    "Napf",
					"NapfWinter",					
                    "Caribou",
					"tem_anizay",
					"rof_mok",
					"malden",
					// "Farabad",
					"NorthTakistan"		
			
                ];
                if (worldName in _hillyIslands) then {
                    _precision = 3.125
                };
                setTerrainGrid _precision;

                // Set terrain grid on reconnection
                onPlayerConnected {
                    private _precision = 10;
                    private _hillyIslands = [
                        // "MCN_Aliabad",
                        "lingor3",
                        "lythium",
                        "sara",
                        "saralite",
                        "Mountains_ACR",
                        "sara_dbe1",
                        "zargabad",
                        "takistan",
                        "fata",
                        "Shapur_BAF",
                        "Altis",
                        "Stratis",
                        "reshmaan",
                        "Napf",
						"NapfWinter",						
                        "Caribou",
						"tem_anizay",
						"rof_mok",
						"malden",
						// "Farabad",
						"NorthTakistan"						
                    ];
                    if (worldName in _hillyIslands) then {
                        _precision = 3.125
                    };
                    setTerrainGrid _precision;
                };
            };

            [] call WMT_fnc_UpdateMainActions;
            player addEventHandler ["Respawn", {[] call WMT_fnc_UpdateMainActions;}];
        };

        // Set current group as the basic group
        WMT_Local_Group = group player;
    };
};
