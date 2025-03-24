/*
    Name: WMT_fnc_HandlerOptions

    Author(s):
        Ezhuk

    Description:
        Handler function for main menu

    Parameters:
        0 - STR: type of event
        1 - ARRAY: argument from event

    Returns:
        BOOL: for standart handlers
*/
#include "defines_IDC.sqf"

private _event = _this select 0;
private _arg = _this select 1;
private _return = false;

switch (_event) do
{
    case "init": {
        private _dialog = _arg select 0;
        disableSerialization;
        uiNamespace setVariable ["WMT_Dialog_Menu", _dialog];
        private _sliderSpeed = 50 + floor (random 150);
        (_dialog displayCtrl IDC_OPTIONS_PRESET_1_SLIDER) sliderSetSpeed [_sliderSpeed,_sliderSpeed];
        (_dialog displayCtrl IDC_OPTIONS_PRESET_1_SLIDER) sliderSetRange [100,wmt_param_MaxViewDistance];
        (_dialog displayCtrl IDC_OPTIONS_PRESET_2_SLIDER) sliderSetSpeed [_sliderSpeed,_sliderSpeed];
        (_dialog displayCtrl IDC_OPTIONS_PRESET_2_SLIDER) sliderSetRange [100,wmt_param_MaxViewDistance];
        (_dialog displayCtrl IDC_OPTIONS_PRESET_3_SLIDER) sliderSetSpeed [_sliderSpeed,_sliderSpeed];
        (_dialog displayCtrl IDC_OPTIONS_PRESET_3_SLIDER) sliderSetRange [100,wmt_param_MaxViewDistance];

        (_dialog displayCtrl IDC_OPTIONS_TERRAIN_SLIDER) sliderSetSpeed [_sliderSpeed,_sliderSpeed];
        (_dialog displayCtrl IDC_OPTIONS_TERRAIN_SLIDER) sliderSetRange [wmt_param_MaxViewDistance,wmt_param_MaxViewDistanceTerrain];

        (_dialog displayCtrl IDC_OPTIONS_MUTING_SLIDER) sliderSetSpeed [0.01,0.01];
        (_dialog displayCtrl IDC_OPTIONS_MUTING_SLIDER) sliderSetRange [0.01,0.6];

        ['update'] call WMT_fnc_HandlerOptions;
    };
    case "close": {
        uiNamespace setVariable ["WMT_Dialog_Menu", nil];
    };
    case "setDistance": {
        private _slider = _arg select 0;
        private _index = _arg select 1;
        private _dist = _slider select 1;
        private _dialog = uiNamespace getVariable "WMT_Dialog_Menu";
        //private _ctrlVar = IDC_OPTIONS_PRESET_1_VALUE + _index;  // FIX view distance slider value abuse
        private _ctrlSlider = IDC_OPTIONS_PRESET_1_SLIDER + _index;

        _dist = (floor(_dist/10))*10;

        WMT_Options_ViewDistance set [_index, _dist];

        //(_dialog displayCtrl _ctrlVar) ctrlSetText str(wmt_param_MaxViewDistance min _dist); // FIX view distance slider value abuse
        (_dialog displayCtrl _ctrlSlider) sliderSetPosition (wmt_param_MaxViewDistance min _dist);

        if (_index == 0) then {
            (_dialog displayCtrl IDC_OPTIONS_TERRAIN_SLIDER) sliderSetRange [_dist,wmt_param_MaxViewDistanceTerrain];
        };

        profileNamespace setVariable ['WMT_Profile_ViewDistance_Presets', WMT_Options_ViewDistance];
        ['updateViewDistance'] call WMT_fnc_HandlerOptions;
    };
    case "setDistanceTerrain": {
        private _slider = _arg select 0;
        private _dist = _slider select 1;
        private _dialog = uiNamespace getVariable "WMT_Dialog_Menu";
        //private _ctrlVar = IDC_OPTIONS_TERRAIN_VALUE; // FIX view distance slider value abuse
        private _ctrlSlider = IDC_OPTIONS_TERRAIN_SLIDER;

        _dist = (floor(_dist/10))*10;

        WMT_Options_ViewDistanceTerrain = _dist;

        //(_dialog displayCtrl _ctrlVar) ctrlSetText str(wmt_param_MaxViewDistanceTerrain min _dist); // FIX view distance slider value abuse
        (_dialog displayCtrl _ctrlSlider) sliderSetPosition (wmt_param_MaxViewDistanceTerrain min _dist);

        profileNamespace setVariable ['WMT_Profile_ViewDistance_Terrain', WMT_Options_ViewDistanceTerrain];
        ['updateViewDistance'] call WMT_fnc_HandlerOptions;
    };
    case "setMutingLevel": {
        private _slider = _arg select 0;
        private _lvl = _slider select 1;
        private _dialog = uiNamespace getVariable "WMT_Dialog_Menu";

        _lvl = parseNumber (_lvl toFixed 2);

        WMT_Options_Muting = _lvl;

        (_dialog displayCtrl IDC_OPTIONS_MUTING_SLIDER) sliderSetPosition (WMT_Options_Muting);
        (_dialog displayCtrl IDC_OPTIONS_MUTING_VALUE)  ctrlSetText str(WMT_Options_Muting);

        profileNamespace setVariable ['WMT_Profile_Muting', WMT_Options_Muting];

        /*if (WMT_Options_Muted) then {
            0.1 fadeSound WMT_Options_Muting;
            missionNamespace setVariable ["AGM_Hearing_disableVolumeUpdate", true];
            missionNamespace setVariable ["ACE_Hearing_disableVolumeUpdate", true];
            WMT_SoundCurrentLevel = WMT_Options_Muting;
        };*/
    };
    case "update": {
        private _dialog = uiNamespace getVariable "WMT_Dialog_Menu";

        /*(_dialog displayCtrl IDC_OPTIONS_FOOT_VAR) ctrlSetText str(wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 0));
        (_dialog displayCtrl IDC_OPTIONS_VEH_VAR) ctrlSetText str(wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 1));*/ // Not implemented


        (_dialog displayCtrl IDC_OPTIONS_PRESET_1_SLIDER) sliderSetPosition (wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 0));
        (_dialog displayCtrl IDC_OPTIONS_PRESET_2_SLIDER) sliderSetPosition (wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 1));
        (_dialog displayCtrl IDC_OPTIONS_PRESET_3_SLIDER) sliderSetPosition (wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 2));
        (_dialog displayCtrl IDC_OPTIONS_TERRAIN_SLIDER)  sliderSetPosition (wmt_param_MaxViewDistanceTerrain min WMT_Options_ViewDistanceTerrain);
        (_dialog displayCtrl IDC_OPTIONS_MUTING_SLIDER)   sliderSetPosition (WMT_Options_Muting);

        /*(_dialog displayCtrl IDC_OPTIONS_PRESET_1_VALUE) ctrlSetText str(wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 0));
        (_dialog displayCtrl IDC_OPTIONS_PRESET_2_VALUE) ctrlSetText str(wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 1));
        (_dialog displayCtrl IDC_OPTIONS_PRESET_3_VALUE) ctrlSetText str(wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select 2));
        (_dialog displayCtrl IDC_OPTIONS_TERRAIN_VALUE)  ctrlSetText str(wmt_param_MaxViewDistanceTerrain min WMT_Options_ViewDistanceTerrain);*/ // FIX view distance slider value abuse
        (_dialog displayCtrl IDC_OPTIONS_MUTING_VALUE)   ctrlSetText str(WMT_Options_Muting);

        (_dialog displayCtrl IDC_OPTIONS_CHECK_NICKNAME) cbSetChecked ((profileNamespace getVariable ['WMT_ShowNickNameOption', 1]) == 1);
        (_dialog displayCtrl IDC_OPTIONS_CHECK_FRZBEEP)  cbSetChecked ((profileNamespace getVariable ['WMT_BeepAfterFreezeOption', 0]) == 1);
        (_dialog displayCtrl IDC_OPTIONS_SAVE_TERRAIN)   cbSetChecked ((profileNamespace getVariable ['WMT_Profile_ViewDistance_TerraineSave', 0]) == 1);
    };
    case "updateViewDistance": {
        private _dist = wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select WMT_Options_ViewDistance_Preset);
        private _distterrain = (wmt_param_MaxViewDistanceTerrain min WMT_Options_ViewDistanceTerrain);

        if (WMT_Options_ViewDistance_Preset == 0) then {
            setObjectViewDistance _dist;
            setViewDistance _distterrain;
        } else {
            setObjectViewDistance _dist;
            setViewDistance _dist;
        };
    };
    case "preinit": {
        private["_dist"];

        WMT_Options_ViewDistance = profileNamespace getVariable ['WMT_Profile_ViewDistance_Presets', [wmt_param_MaxViewDistance,wmt_param_MaxViewDistance,wmt_param_MaxViewDistance]];

        if (profileNamespace getVariable ['WMT_Profile_ViewDistance_TerraineSave', 0] == 1) then {
            WMT_Options_ViewDistanceTerrain = wmt_param_MaxViewDistanceTerrain min (profileNamespace getVariable ['WMT_Profile_ViewDistance_Terrain', wmt_param_MaxViewDistanceTerrain]);
        } else {
            WMT_Options_ViewDistanceTerrain = wmt_param_MaxViewDistance;
        };

        WMT_Options_Muting = profileNamespace getVariable ['WMT_Profile_Muting',0.6];
        WMT_Options_ViewDistance_Preset = 0;

        WMT_Options_Muted = false;
        WMT_SoundCurrentLevel = 1;

        // Set max distance in first preset
        WMT_Options_ViewDistance set [0, wmt_param_MaxViewDistance];

        //["updateViewDistance"] spawn WMT_fnc_handlerOptions;

        // Set low view distance on spawn (Trying to gain FPS and reduce player drops on mission start)
        setObjectViewDistance (300 min wmt_param_MaxViewDistance);
        setViewDistance (300 min wmt_param_MaxViewDistanceTerrain);
    };
    case 'action_vd_preset': {
        WMT_Options_ViewDistance_Preset = _arg;
        //hint format ["%1:\n%2", localize"STR_WMT_ViewDistance", wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select WMT_Options_ViewDistance_Preset)];

        /* private _color = [1,1,1];
        switch (WMT_Options_ViewDistance_Preset) do {
            case (0): {
                //Red
                _color = [0.847,0.106,0.376,0.7];
            };
            case (1): {
                //Yellow
                _color = [1,0.757,0.027,0.7];
            };
            case (2): {
                //Blue
                _color = [0.118,0.53,0.898,0.7];
            };
            default {};
        }; */

        [[str(WMT_Options_ViewDistance_Preset + 1), 2.5, [1,1,1,0.7]], true, 0.5] call WMT_fnc_Hint;
        playSound "soundClick";

        //hint format [localize"STR_WMT_ViewDistanceHint", (WMT_Options_ViewDistance_Preset + 1)];

        private _dist = wmt_param_MaxViewDistance min (WMT_Options_ViewDistance select WMT_Options_ViewDistance_Preset);
        private _distterrain = (wmt_param_MaxViewDistanceTerrain min WMT_Options_ViewDistanceTerrain);

        if (WMT_Options_ViewDistance_Preset == 0) then {
            setViewDistance _distterrain;
            setObjectViewDistance _dist;
        } else {
           setViewDistance _dist;
           setObjectViewDistance _dist;
        };
    };
    case 'action_muting': {
        WMT_Options_Muted = !WMT_Options_Muted;

        playSound "soundClick";
        if (WMT_Options_Muted) then {
            //hint format [localize "STR_WMT_ReducedSound", WMT_Options_Muting];
            [["\WMT_Main\pic\speaker_low.paa", 1.8, [1,1,1,0.7]], true, 0.5] call WMT_fnc_Hint;
            0.1 fadeSound WMT_Options_Muting;
            missionNamespace setVariable ["AGM_Hearing_disableVolumeUpdate", true];
            missionNamespace setVariable ["ACE_Hearing_disableVolumeUpdate", true];
            WMT_SoundCurrentLevel = WMT_Options_Muting;
            WOG_unmuteNearFiredEH = player addEventHandler ["FiredNear",
            "if (alive player) then {
              if (vehicle player != player) then  {
                if (((driver (vehicle player)) isEqualTo player) ||
                    ((gunner (vehicle player)) isEqualTo player) ||
                    ((commander (vehicle player)) isEqualTo player))
               then { } else {['action_muting'] spawn WMT_fnc_HandlerOptions}}
            else {['action_muting'] spawn WMT_fnc_HandlerOptions}}"];
        } else {
            //hint localize "STR_WMT_RestoredSound";
            [["\WMT_Main\pic\speaker.paa", 1.8, [1,1,1,0.7]], true, 0.5] call WMT_fnc_Hint;
            0.1 fadeSound 1;
            missionNamespace setVariable ["AGM_Hearing_disableVolumeUpdate", false];
            missionNamespace setVariable ["ACE_Hearing_disableVolumeUpdate", false];
            WMT_SoundCurrentLevel = 1;
             player removeEventHandler ["FiredNear", WOG_unmuteNearFiredEH];
        };
    };
    case 'disableOptions' : {
        // 103 CA_ValueVisibility
        // 104 CA_SliderVisibility
        // 308 CA_ValueObjectVisibility
        // 309 CA_SliderObjectVisibility
        private _display = _arg select 0;
        if (not isNil "wmt_Main_ModuleRunning") then {
            {
                (_display displayCtrl _x) ctrlEnable false;
                (_display displayCtrl _x) ctrlSetTooltip localize "STR_WMT_UseWMTOptions"
            } forEach [104, 309];
            {
                (_display displayCtrl _x) ctrlEnable false;
                (_display displayCtrl _x) ctrlShow false;
            } forEach [103,308];
        };
    };
};
_return
