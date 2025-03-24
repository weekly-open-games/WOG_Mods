////////////////////////////////////////////////////////////////////
//DeRap: config.bin
//Produced from mikero's Dos Tools Dll version 9.98
//https://mikero.bytex.digital/Downloads
//'now' is Mon Mar 24 19:33:06 2025 : 'file' last modified on Thu Jan 01 03:00:00 1970
////////////////////////////////////////////////////////////////////

#define _ARMA_

class ArgumentsBaseUnits;
class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	class WMT_Task_Destroy: Module_F
	{
		scope = 2;
		author = "Ezhuk";
		displayName = "Task: Destroy";
		category = "WMT";
		function = "WMT_fnc_InitModuleTaskDestroy";
		icon = "\WMT_Tasks\pic\destroy.paa";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class Condition
			{
				displayName = "$STR_WMT_Condition";
				description = "$STR_WMT_Condition_Desc";
				typeName = "STRING";
				defaultValue = "true";
			};
			class Count
			{
				displayName = "$STR_WMT_ObjectCount";
				description = "$STR_WMT_ObjectCount_Destroy_Desc";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class Winner
			{
				displayName = "$STR_WMT_WinnerSide";
				description = "";
				typeName = "NUMBER";
				class values
				{
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
						default = 1;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Message
			{
				displayName = "$STR_WMT_Message";
				description = "$STR_WMT_Message_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Notice
			{
				displayName = "$STR_WMT_Notice";
				description = "$STR_WMT_Notice_Destroy_Desc";
				typeName = "NUMBER";
				class values
				{
					class Enable
					{
						name = "$STR_WMT_Enable";
						value = 1;
						default = 1;
					};
					class Disable
					{
						name = "$STR_WMT_Disable";
						value = 0;
					};
				};
			};
		};
	};
	class WMT_Task_Arrive: Module_F
	{
		scope = 2;
		author = "Ezhuk";
		displayName = "Task: Arrive";
		category = "WMT";
		function = "WMT_fnc_initModuleTaskArrive";
		icon = "\WMT_Tasks\pic\arrive.paa";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class Marker
			{
				displayName = "$STR_WMT_Marker";
				description = "$STR_WMT_Marker_Arrived_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Count
			{
				displayName = "$STR_WMT_ObjectCount";
				description = "$STR_WMT_ObjectCount_Arrive_Desc";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class Winner
			{
				displayName = "$STR_WMT_WinnerSide";
				description = "";
				typeName = "NUMBER";
				class values
				{
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
						default = 1;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Message
			{
				displayName = "$STR_WMT_Message";
				description = "$STR_WMT_Message_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Notice
			{
				displayName = "$STR_WMT_Notice";
				description = "$STR_WMT_Notice_Arrive_Desc";
				typeName = "NUMBER";
				class values
				{
					class Enable
					{
						name = "$STR_WMT_Enable";
						value = 1;
						default = 1;
					};
					class Disable
					{
						name = "$STR_WMT_Disable";
						value = 0;
					};
				};
			};
			class Condition
			{
				displayName = "$STR_WMT_Condition";
				description = "$STR_WMT_Condition_Desc";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};
	class WMT_Task_Point: Module_F
	{
		scope = 2;
		author = "Ezhuk";
		displayName = "Task: Point";
		category = "WMT";
		function = "WMT_fnc_InitModuleTaskPoint";
		icon = "\WMT_Tasks\pic\point.paa";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class Marker
			{
				displayName = "$STR_WMT_Marker";
				description = "$STR_WMT_Marker_Point_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class MarkerText
			{
				displayName = "$STR_WMT_MarkerText";
				description = "$STR_WMT_MarkerText_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Owner
			{
				displayName = "$STR_WMT_DefaultSide";
				description = "$STR_WMT_DefaultSide_Desc";
				typeName = "NUMBER";
				class values
				{
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
						default = 1;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Message
			{
				displayName = "$STR_WMT_Message";
				description = "$STR_WMT_Message_Point_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class AdvantagePercent
			{
				displayName = "$STR_WMT_AdvantagePercent";
				description = "$STR_WMT_AdvantagePercent_desc";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class DefCount
			{
				displayName = "$STR_WMT_DefCount";
				description = "$STR_WMT_DefCount_desc";
				typeName = "NUMBER";
				defaultValue = 3;
			};
			class CaptureCount
			{
				displayName = "$STR_WMT_CaptureCount";
				description = "$STR_WMT_CaptureCount_Desc";
				typeName = "NUMBER";
				defaultValue = 4;
			};
			class Lock
			{
				displayName = "$STR_WMT_Lock";
				description = "$STR_WMT_Lock_Desc";
				typeName = "NUMBER";
				class values
				{
					class Enable
					{
						name = "$STR_WMT_Enable";
						value = 1;
						default = 1;
					};
					class Disable
					{
						name = "$STR_WMT_Disable";
						value = 0;
					};
				};
			};
			class EasyCapture
			{
				displayName = "$STR_WMT_EasyCapture";
				description = "$STR_WMT_EasyCapture_Desc";
				typeName = "NUMBER";
				class values
				{
					class Enable
					{
						name = "$STR_WMT_Enable";
						value = 1;
						default = 1;
					};
					class Disable
					{
						name = "$STR_WMT_Disable";
						value = 0;
					};
				};
			};
			class MinHeight
			{
				displayName = "$STR_WMT_MinHeight";
				description = "";
				typeName = "NUMBER";
				defaultValue = -5;
			};
			class MaxHeight
			{
				displayName = "$STR_WMT_MaxHeight";
				description = "";
				typeName = "NUMBER";
				defaultValue = 30;
			};
			class AutoLose
			{
				displayName = "$STR_WMT_AutoLose";
				description = "$STR_WMT_AutoLose_Desc";
				typeName = "NUMBER";
				class values
				{
					class No
					{
						name = "$STR_WMT_Disable";
						value = -1;
						default = 1;
					};
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Timer
			{
				displayName = "$STR_WMT_TimerInSec";
				description = "";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class Condition
			{
				displayName = "$STR_WMT_Condition";
				description = "$STR_WMT_Condition_Desc";
				typeName = "STRING";
				defaultValue = "true";
			};
			class Notice
			{
				displayName = "$STR_WMT_Notice";
				description = "$STR_WMT_Notice_Point_Desc";
				typeName = "NUMBER";
				class values
				{
					class Enable
					{
						name = "$STR_WMT_Enable";
						value = 1;
						default = 1;
					};
					class Disable
					{
						name = "$STR_WMT_Disable";
						value = 0;
					};
				};
			};
		};
	};
	class WMT_Task_CapturePoint: Module_F
	{
		scope = 2;
		author = "Ezhuk";
		displayName = "Task: Captue points";
		category = "WMT";
		function = "WMT_fnc_InitModuleTaskCapturePoints";
		icon = "\WMT_Tasks\pic\capture.paa";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class Winner
			{
				displayName = "$STR_WMT_WinnerSide";
				description = "";
				typeName = "NUMBER";
				class values
				{
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
						default = 1;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Count
			{
				displayName = "$STR_WMT_PointCount";
				description = "$STR_WMT_PointCount_Desc";
				typeName = "NUMBER";
				defaultValue = 1;
			};
			class Message
			{
				displayName = "$STR_WMT_Message";
				description = "$STR_WMT_Message_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Condition
			{
				displayName = "$STR_WMT_Condition";
				description = "$STR_WMT_Condition_Desc";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};
	class WMT_Task_VIP: Module_F
	{
		scope = 2;
		author = "Ezhuk";
		displayName = "Task: VIP";
		category = "WMT";
		function = "WMT_fnc_InitModuleTaskVIP";
		icon = "\WMT_Tasks\pic\vip.paa";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class Marker
			{
				displayName = "$STR_WMT_Marker";
				description = "$STR_WMT_Marker_VIP_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Winner
			{
				displayName = "$STR_WMT_WinnerSide";
				description = "";
				typeName = "NUMBER";
				class values
				{
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
						default = 1;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Count
			{
				displayName = "$STR_WMT_CountVIP";
				description = "$STR_WMT_CountVIP_Desc";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class Message
			{
				displayName = "$STR_WMT_Message";
				description = "$STR_WMT_Message_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class ReturnTime
			{
				displayName = "$STR_WMT_ReturnTime";
				description = "";
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class Notice
			{
				displayName = "$STR_WMT_Notice";
				description = "";
				typeName = "NUMBER";
				class values
				{
					class Enable
					{
						name = "$STR_WMT_Enable";
						value = 1;
						default = 1;
					};
					class Disable
					{
						name = "$STR_WMT_Disable";
						value = 0;
					};
				};
			};
			class Condition
			{
				displayName = "$STR_WMT_Condition";
				description = "$STR_WMT_Condition_Desc";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};
	class WMT_Task_Compose: Module_F
	{
		scope = 2;
		author = "Ezhuk";
		displayName = "Task: Compose";
		category = "WMT";
		function = "WMT_fnc_InitModuleTaskCompose";
		icon = "\WMT_Tasks\pic\compose.paa";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class Winner
			{
				displayName = "$STR_WMT_WinnerSide";
				description = "";
				typeName = "NUMBER";
				class values
				{
					class Empty
					{
						name = "$STR_WMT_Nobody";
						value = 4;
						default = 1;
					};
					class East
					{
						name = "$STR_WMT_East";
						value = 0;
					};
					class West
					{
						name = "$STR_WMT_West";
						value = 1;
					};
					class Guer
					{
						name = "$STR_WMT_Resistance";
						value = 2;
					};
					class Civ
					{
						name = "$STR_WMT_Civilian";
						value = 3;
					};
				};
			};
			class Count
			{
				displayName = "$STR_WMT_ComposeCount";
				description = "$STR_WMT_ComposeCount_Desc";
				typeName = "NUMBER";
				defaultValue = 1;
			};
			class Message
			{
				displayName = "$STR_WMT_Message";
				description = "$STR_WMT_Message_Desc";
				typeName = "STRING";
				defaultValue = "";
			};
			class Condition
			{
				displayName = "$STR_WMT_Condition";
				description = "$STR_WMT_Condition_Desc";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};
};
class CfgFunctions
{
	class WMT
	{
		class Tasks
		{
			file = "WMT_Tasks\functions";
			class PrecompileTask
			{
				preInit = 1;
			};
			class IsTheUnitInsideMarker{};
			class ShowTaskNotification{};
		};
	};
};
class CfgPatches
{
	class WMT_Tasks
	{
		units[] = {"WMT_Task_Destroy","WMT_Task_Arrive","WMT_Task_Point","WMT_Task_CapturePoint","WMT_Task_VIP","WMT_Task_Compose"};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"WMT_Main"};
		authors[] = {"Ezhuk","Zealot"};
		authorUrl = "https://github.com/iEzhuk/WMT_MapTools";
		version = "1.5.0";
		versionStr = "1.5.0";
		versionAr[] = {1,5,0};
	};
};
class CfgFactionClasses
{
	class WMT
	{
		displayName = "WMT";
		priority = 0;
		side = 7;
	};
};
class CfgNotifications
{
	class WMT_CapturingStarted
	{
		title = "$STR_WMT_CapturingStarted";
		iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
		description = "$STR_WMT_CapturingStarted_Desc";
		priority = 1;
		colorIconPicture[] = {0.98,0.73,0.01,1};
		duration = 3;
	};
	class WMT_CapturingAborted
	{
		title = "$STR_WMT_CapturingAborted";
		iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIconCanceled_ca.paa";
		description = "$STR_WMT_CapturingAborted_Desc";
		priority = 2;
		colorIconPicture[] = {0.98,0.98,0.98,1};
		duration = 3;
	};
};
