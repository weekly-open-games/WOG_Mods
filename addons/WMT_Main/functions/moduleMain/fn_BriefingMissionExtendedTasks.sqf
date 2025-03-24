/*
    Name: WMT_fnc_BriefingMissionExtendedTasks

    Author(s):
        [KND]Liquid

    Description:
        Add extended description of mission tasks to diary. (based on WMT_Task modules)

    Parameters:
        Nothing
    Returns:
        Nothing
*/

if (hasInterface) then {
    private _allModules = entities "Module_F"; // Maybe, testing that WMT_Task loaded before this call, needed. Also 'entities' can be slow.

    private _wmtTaskModules = [];
    {
        private _type = typeOf _x;
        if ((["WMT_Task_Destroy","WMT_Task_Arrive","WMT_Task_Point","WMT_Task_CapturePoint","WMT_Task_VIP","WMT_Task_Compose"] find _type) > -1) then {
            switch (_type) do {
                case "WMT_Task_Compose": {
                    _wmtTaskModules pushBack [1,_x]; //Add priority weights to sort it later.
                };
                case "WMT_Task_Point": {
                    _wmtTaskModules pushBack [3,_x];
                };
                default {
                    _wmtTaskModules pushBack [2,_x];
                };
            };
        };
    } forEach _allModules;

    if (_wmtTaskModules isEqualTo []) exitWith {};

    _wmtTaskModules sort true; // Sorting for correct task order at generated page.

    private _text = "";
    {
        _x params ["","_module"];
        private _winner = _module getVariable ["Winner",nil];
        private _endCount = _module getVariable ["Count",nil];
        private _objects = synchronizedObjects _module select {typeOf _x != "WMT_Task_Compose"};

        if !(isNil "_winner") then {
            switch (_module getVariable "Winner") do {
                case 0: {
                    _winner = localize "STR_WMT_East";
                };
                case 1: {
                    _winner = localize "STR_WMT_West";
                };
                case 2: {
                    _winner = localize "STR_WMT_Resistance";
                };
                case 3: {
                    _winner = localize "STR_WMT_Civilian";
                };
                case 4: {
                    _winner = localize "STR_WMT_Nobody";
                };
            };
        };

        switch (typeOf _module) do {
            case ("WMT_Task_Destroy"): {
                _text = _text + format [localize "STR_WMT_Task_Destroy_Brief", _winner, (count _objects - _endCount), count _objects];
            };
            case ("WMT_Task_Arrive"): {
                private _marker = _module getVariable "Marker";

                _text = _text + format [localize "STR_WMT_Task_Arrive_Brief",_winner, _endCount, count _objects, _marker];
            };
            case ("WMT_Task_Point"): {
                private _marker = _module getVariable "Marker";
                private _advantagePercent = _module getVariable "AdvantagePercent";
                private _defCount = _module getVariable "DefCount";
                private _captureCount = _module getVariable "CaptureCount";
                private _lock = "";
                switch (_module getVariable "Lock") do {
                    case 0: {
                        _lock = localize "STR_WMT_Enable";
                    };
                    case 1: {
                        _lock = localize "STR_WMT_Disable";
                    };
                };
                private _easycapture = "";
                switch (_module getVariable "EasyCapture") do {
                    case 0: {
                        _easyCapture = localize "STR_WMT_Disable";
                    };
                    case 1: {
                        _easyCapture = localize "STR_WMT_Enable";
                    };
                };
                private _autoLose = "";
                switch (_module getVariable "AutoLose") do {
                    case -1: {
                        _autoLose = localize "STR_WMT_Disable";
                    };
                    case 0: {
                        _autoLose = localize "STR_WMT_East";
                    };
                    case 1: {
                        _autoLose = localize "STR_WMT_West";
                    };
                    case 2: {
                        _autoLose = localize "STR_WMT_Resistance";
                    };
                    case 3: {
                        _autoLose = localize "STR_WMT_Civilian";
                    };
                    case 4: {
                        _autoLose = localize "STR_WMT_Nobody";
                    };
                };
                private _timer = _module getVariable "Timer";

                _text = _text + format [localize "STR_WMT_Task_Point_Brief", _marker, _captureCount, _timer, _defCount, _easyCapture, _lock, _autoLose];
                if (_advantagePercent > 0) then {
                    _text = _text + format [localize "STR_WMT_Task_Point_Brief_Advant", _marker, _advantagePercent];
                };
            };
            case ("WMT_Task_CapturePoint"): {
                _text = _text + format [localize "STR_WMT_Task_CapturePoint_Brief", _winner, _endCount];
            };
            case ("WMT_Task_VIP"): {
                private _marker = _module getVariable "Marker";
                private _returnTime = _module getVariable "ReturnTime";

                _text = _text + format [localize "STR_WMT_Task_VIP_Brief", _winner, (count _objects - _endCount), count _objects, _marker, _returnTime];
            };
            case ("WMT_Task_Compose"): {
                _text = _text + format [localize "STR_WMT_Task_Compose_Brief", _winner, _endCount, count _objects];
            };
        };
    } forEach _wmtTaskModules;

    _text = _text + localize "STR_WMT_Tasks_Brief_Notice";

    ["diary",localize "STR_WMT_MissionTasks", _text] call WMT_fnc_CreateDiaryRecord;
};
