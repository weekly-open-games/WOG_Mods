/*
	Name: WMT_fnc_PrecompileMain

	Author(s):
		Ezhuk

	Description:
		Compile functions

	Parameters:
		Nothing

	Returns:
		Nothing
*/


// General
WMT_fnc_Announcement                 = compileScript ["WMT_Main\functions\fn_Announcement.sqf", true];
WMT_fnc_ArrayToString                = compileScript ["WMT_Main\functions\fn_ArrayToString.sqf", true];
WMT_fnc_GetVehicles                  = compileScript ["WMT_Main\functions\fn_GetVehicles.sqf", true];
WMT_fnc_BriefingTimer                = compileScript ["WMT_Main\functions\fn_BriefingTimer.sqf", true];
WMT_fnc_BriefingPlayerCount          = compileScript ["WMT_Main\functions\fn_BriefingPlayerCount.sqf", true];
WMT_fnc_Respawn                      = compileScript ["WMT_Main\functions\fn_Respawn.sqf", true];


// Module Main
WMT_fnc_InitModuleMain               = compileScript ["WMT_Main\functions\moduleMain\fn_InitModuleMain.sqf", true];

WMT_fnc_BriefingMissionParameters    = compileScript ["WMT_Main\functions\moduleMain\fn_BriefingMissionParameters.sqf", true];
WMT_fnc_DefaultFreqsClient           = compileScript ["WMT_Main\functions\moduleMain\fn_DefaultFreqsClient.sqf", true];
WMT_fnc_DefaultFreqsServer           = compileScript ["WMT_Main\functions\moduleMain\fn_DefaultFreqsServer.sqf", true];
WMT_fnc_DisableAI                    = compileScript ["WMT_Main\functions\moduleMain\fn_DisableAI.sqf", true];
WMT_fnc_DisableTI                    = compileScript ["WMT_Main\functions\moduleMain\fn_DisableTI.sqf", true];
WMT_fnc_DisableFuelStations          = compileScript ["WMT_Main\functions\moduleMain\fn_DisableFuelStations.sqf", true];
WMT_fnc_HandlerAdminPanel            = compileScript ["WMT_Main\functions\moduleMain\fn_HandlerAdminPanel.sqf", true];
WMT_fnc_HandlerFeedback              = compileScript ["WMT_Main\functions\moduleMain\fn_HandlerFeedback.sqf", true];
WMT_fnc_HandlerMenu                  = compileScript ["WMT_Main\functions\moduleMain\fn_HandlerMenu.sqf", true];
WMT_fnc_HandlerOptions               = compileScript ["WMT_Main\functions\moduleMain\fn_HandlerOptions.sqf", true];
WMT_fnc_HeavyLossesCheck             = compileScript ["WMT_Main\functions\moduleMain\fn_HeavyLossesCheck.sqf", true];
WMT_fnc_CheckRatiosForSides             = compileScript ["WMT_Main\functions\moduleMain\fn_CheckRatiosForSides.sqf", true];
WMT_fnc_HideSideMarkers              = compileScript ["WMT_Main\functions\moduleMain\fn_HideSideMarkers.sqf", true];
WMT_fnc_HideUserMarkers              = compileScript ["WMT_Main\functions\moduleMain\fn_HideUserMarkers.sqf", true];
WMT_fnc_IndetifyTheBody              = compileScript ["WMT_Main\functions\moduleMain\fn_IndetifyTheBody.sqf", true];
WMT_fnc_NameTag                      = compileScript ["WMT_Main\functions\moduleMain\fn_NameTag.sqf", true];
WMT_fnc_KeyHandlerShowCrew           = compileScript ["WMT_Main\functions\moduleMain\fn_KeyHandlerShowCrew.sqf", true];
WMT_fnc_PlayerKilled                 = compileScript ["WMT_Main\functions\moduleMain\fn_PlayerKilled.sqf", true];
WMT_fnc_PrepareBriefingInfo          = compileScript ["WMT_Main\functions\moduleMain\fn_PrepareBriefingInfo.sqf", true];
WMT_fnc_Reequip                      = compileScript ["WMT_Main\functions\moduleMain\fn_Reequip.sqf", true];
WMT_fnc_ReequipStart                 = compileScript ["WMT_Main\functions\moduleMain\fn_ReequipStart.sqf", true];
WMT_fnc_ShowBriefingInfo             = compileScript ["WMT_Main\functions\moduleMain\fn_ShowBriefingInfo.sqf", true];
WMT_fnc_ShowCrew                     = compileScript ["WMT_Main\functions\moduleMain\fn_ShowCrew.sqf", true];
WMT_fnc_ShowStatistic                = compileScript ["WMT_Main\functions\moduleMain\fn_ShowStatistic.sqf", true];
WMT_fnc_SquadInfoExt                 = compileScript ["WMT_Main\functions\moduleMain\fn_SquadInfoExt.sqf", true];
WMT_fnc_UpdateMainActions            = compileScript ["WMT_Main\functions\moduleMain\fn_UpdateMainActions.sqf", true];
WMT_fnc_BriefingMissionExtendedTasks = compileScript ["WMT_Main\functions\moduleMain\fn_BriefingMissionExtendedTasks.sqf", true];


// Module Time
WMT_fnc_InitModuleTime               = compileScript ["WMT_Main\functions\moduleTime\fn_InitModuleTime.sqf", true];

WMT_fnc_EndMissionByTime             = compileScript ["WMT_Main\functions\moduleTime\fn_EndMissionByTime.sqf", true];
WMT_fnc_FreezePlayerClient           = compileScript ["WMT_Main\functions\moduleTime\fn_FreezePlayerClient.sqf", true];
WMT_fnc_FreezeUI                     = compileScript ["WMT_Main\functions\moduleTime\fn_FreezeUI.sqf", true];
WMT_fnc_FreezeVoteStart              = compileScript ["WMT_Main\functions\moduleTime\fn_FreezeVoteStart.sqf", true];
WMT_fnc_FreezeVoteWait               = compileScript ["WMT_Main\functions\moduleTime\fn_FreezeVoteWait.sqf", true];
WMT_fnc_FreezeVoteInfo               = compileScript ["WMT_Main\functions\moduleTime\fn_FreezeVoteInfo.sqf", true];
WMT_fnc_PrepareTime_client           = compileScript ["WMT_Main\functions\moduleTime\fn_PrepareTime_client.sqf", true];
WMT_fnc_PrepareTime_server           = compileScript ["WMT_Main\functions\moduleTime\fn_PrepareTime_server.sqf", true];
WMT_fnc_RemoveBots                   = compileScript ["WMT_Main\functions\moduleTime\fn_RemoveBots.sqf", true];


// Module Start Position
WMT_fnc_InitModuleStartPosition      = compileScript ["WMT_Main\functions\moduleStartPosition\fn_InitModuleStartPosition.sqf", true];
WMT_fnc_startPosition_server         = compileScript ["WMT_Main\functions\moduleStartPosition\fn_startPosition_server.sqf", true];
WMT_fnc_startPosition_client         = compileScript ["WMT_Main\functions\moduleStartPosition\fn_startPosition_client.sqf", true];
WMT_fnc_chooseMarker_handler         = compileScript ["WMT_Main\functions\moduleStartPosition\fn_chooseMarker_handler.sqf", true];
WMT_fnc_GetItemConfigEntry           = compileScript ["WMT_Main\functions\fn_GetItemConfigEntry.sqf", true];
