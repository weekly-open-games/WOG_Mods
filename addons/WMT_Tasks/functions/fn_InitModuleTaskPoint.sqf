/*
     Name: WMT_fnc_InitModuleTaskPoint

     Author(s):
        Ezhuk
*/

#include "defines.sqf"

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (_activated) then {
    //===============================================================
    //                             Server part
    //===============================================================
    if (isServer) then {
        if (isNil "WMT_Local_PointArray") then {
            WMT_Local_PointArray = [];
        };
        WMT_Local_PointArray set [count WMT_Local_PointArray, _logic];

        [_logic, _units, DELAY] spawn {
            private _func_create_trigger = {
                private _marker = _this select 0;
                private _markerPos = markerPos _marker;
                private _markerDir = markerDir _marker;
                private _markerSize = markerSize _marker;
                private _isRectangle = (markerShape _marker) == "RECTANGLE";

                private _trigger = createTrigger ["EmptyDetector", [_markerPos select 0,_markerPos select 1], false];
                _trigger setTriggerArea  [_markerSize select 0,_markerSize select 1,_markerDir,_isRectangle];
                _trigger setTriggerActivation["ANY","PRESENT",true];
                _trigger setTriggerStatements ["this", "", ""];
                _trigger
            };

            private _func_sideToColor = {
                switch (_this) do
                {
                    case east:       {"ColorOpfor"};
                    case west:       {"ColorBlufor"};
                    case resistance: {"ColorIndependent"};
                    case civilian:   {"ColorCivilian"};
                    default          {"ColorBlack"}
                };
            };

            private _getUnitList = {
                params ["_arrTrg"];
                private ["_unitList", "_lst", "_unit"];
                private _unitList = [];

                if (count _arrTrg > 0) then {
                    // Add units from first trigger in list
                    _unitList = list (_arrTrg select 0);
                    for "_i" from 1 to ((count _arrTrg)-1) do {
                        _lst = list (_arrTrg select _i);
                        for "_k" from 0 to ((count _lst)-1) do {
                            _unit = _lst select _k;
                            // Checking the  double detection
                            if !(_unit in _unitList) then {
                                // Push in unit list
                                _unitList = _unitList + [_unit];
                            };
                        };
                    };
                };
                _unitList
            };

            private _getCountUnits = {
                params ["_arrTrg", "_minZ", "_maxZ"];

                private _sideUnits = [0,0,0,0,0];
                {
                    private ["_side", "_unit", "_id"];
                    _unit = _x;
                    private _pos  = if (surfaceIsWater getPos _unit) then {getPosASL _unit} else {getPosATL _unit};

                    if (_pos select 2 > _minZ && _pos select 2 < _maxZ) then {
                        _side = side _unit;
                        _id = [east, west, resistance, civilian] find _side;

                        if (_id != -1 ) then {
                            _sideUnits set [_id, (_sideUnits select _id) + ({isPlayer _x && alive _x && !(_x getVariable ["ACE_isUnconscious", false])} count (crew _unit))];
                        };
                    };
                } forEach ([_arrTrg] call _getUnitList);

                _sideUnits
            };

            private _fnc_blinkMarker = {
                params ["_start", "_color", "_arrMarkers", "_logic"];

                if (!_start) exitWith {
                    _logic setVariable ["WMT_BlinkingMarker", false];
                };
                _logic setVariable ["WMT_BlinkingMarker", true];

                private _origMarkersParams = [];
                {
                    _origMarkersParams pushBack [markerAlpha _x, markerBrush _x];

                    _x setMarkerBrushLocal "FDiagonal";
                    _x setMarkerColor _color;
                } forEach _arrMarkers;

                while {_logic getVariable ["WMT_BlinkingMarker", false]} do {
                    {
                        _x setMarkerAlpha 1;
                    } forEach _arrMarkers;
                    sleep 0.4;

                    {
                        _x setMarkerAlpha 0;
                    } forEach _arrMarkers;
                    sleep 0.4;
                };

                private _curOwner  = _logic getVariable "WMT_PointOwner";
                private _ownerColor = switch (_curOwner) do
                {
                    case west:       {"ColorBlufor"};
                    case east:       {"ColorOpfor"};
                    case resistance: {"ColorIndependent"};
                    case civilian:   {"ColorCivilian"};
                    default          {"ColorBlack"}
                };

                {
                    _x setMarkerAlphaLocal ((_origMarkersParams select _forEachIndex) select 0);
                    _x setMarkerBrushLocal ((_origMarkersParams select _forEachIndex) select 1);
                    _x setMarkerColor _ownerColor;
                } forEach _arrMarkers;
            };

            params ["_logic", "", "_delay"];

            private _markerStr    = _logic getVariable "Marker";
            private _markerText   = _logic getVariable ["MarkerText", ""];
            private _owner        = [east,west,resistance,civilian,sideLogic] select (_logic getVariable "Owner");
            private _message      = _logic getVariable "Message";
            private _defCount     = _logic getVariable "DefCount";
            private _lock         = _logic getVariable "Lock";
            private _minHeight    = _logic getVariable "MinHeight";
            private _maxHeight    = _logic getVariable "MaxHeight";
            private _autoLose     = _logic getVariable "AutoLose";
            private _timer        = _logic getVariable ["Timer",0];
            private _captureCount = _logic getVariable "CaptureCount";
            private _easyCapture  = _logic getVariable "EasyCapture";
            private _advantage    = _logic getVariable "AdvantagePercent";
            private _notice       = _logic getVariable ["Notice",1];

            private _condition = compile (_logic getVariable ["Condition","true"]);

            // Remove spaces
            _markerStr = toString ((toArray _markerStr) - [32]);

            private _arrMarkers = [_markerStr,","] call Bis_fnc_splitString;
            private _arrTrgs    = [];
            private _brush      = ["Solid", "SolidBorder"] select (count _arrMarkers == 1);

            // Init point
            for "_i" from 0 to ((count _arrMarkers)-1) do {
                private _marker = _arrMarkers select _i;

                _marker setMarkerColorLocal (_owner call _func_sideToColor);
                _marker setMarkerBrushLocal _brush;
                if ((markerText _marker) isNotEqualTo "") then {
                    _markerText = markerText _marker;
                };
                _marker setMarkerText _markerText;

                _arrTrgs set [count _arrTrgs, ([_marker] call _func_create_trigger)];
            };

            // Set variable
            _logic setVariable ["WMT_PointOwner", _owner, true];

            sleep _delay;

            private _locked = false;
            private _timeB  = -1;
            private _typeB  = 0;

            while {!_locked} do {
                private _unitCount = [_arrTrgs, _minHeight, _maxHeight] call _getCountUnits;
                private _curOwner  = _logic getVariable "WMT_PointOwner";

                private _dc = _unitCount select ([east, west, resistance, civilian, sideLogic] find _curOwner);
                private _cs = sideLogic;
                private _cc = 0;

                // Calculate units and detect side that have more units in zone
                {
                    if (_curOwner != _x) then {
                        if (_cc < _unitCount select _foreachindex) then {
                            _cc = _unitCount select _foreachindex;
                            _cs = _x;
                        };
                    };
                } forEach [east, west, resistance];

                private _captured = 0;

                //Checking conditions
                switch (true) do {
                    // Standart
                    case (_dc < _defCount && _cc >= _captureCount && _defCount != -1 && _captureCount != -1) : {
                        _captured = 1;
                    };
                    // Easy capture
                    case (_dc == 0 && _easyCapture == 1 && _cc > 0) : {
                        _captured = 2;
                    };
                    // Auto lose
                    case (_dc == 0 && _autoLose != -1) : {
                        _cs = [east, west, resistance, civilian, sideLogic] select _autoLose;
                        if (_cs != _curOwner) then {
                            _captured = 3;
                        };
                    };
                    // Advantage
                    case (_cc > 0 && {_advantage > 0 && {_dc * _advantage <= _cc}}) : {
                        _captured = 4;
                    };
                };

                if (_captured > 0 && (call _condition)) then {
                    if (_typeB == 0) then {
                        // Timecount
                        _timeB = diag_tickTime;
                        _typeB = _captured;

                        if (_notice == 1 && _timer > 0) then {
                            ["WMT_CapturingStarted",[_markerText,str _timer]] call bis_fnc_showNotification;
                            missionNamespace setVariable ["WMT_Global_Notice_ZoneCapturingStarted", [_markerText, str _timer], true];
                            [true, (_cs call _func_sideToColor), _arrMarkers, _logic] spawn _fnc_blinkMarker;
                            _logic setVariable ["WMT_CapturingInProgress", true];
                            _logic setVariable ["ZoneCapturedSuccesfully", false];
                        };
                    };

                    if (diag_tickTime - _timeB >= _timer) then {
                        // Capture the zone
                        _logic setVariable ["WMT_PointOwner", _cs, true];
                        [false, [], _arrMarkers, _logic] spawn _fnc_blinkMarker;
                        {_x setMarkerColor (_cs call _func_sideToColor)} forEach _arrMarkers;

                        if (_message != "") then {
                            WMT_Global_Notice_ZoneCaptured = [_cs, _logic];
                            publicVariable "WMT_Global_Notice_ZoneCaptured";

                            [_cs, _message] call WMT_fnc_ShowTaskNotification;
                        };

                        if (_lock == 1) then {
                            _locked = true;
                        };
                        _logic setVariable ["ZoneCapturedSuccesfully", true];
                    };
                } else {
                    // Stop timecount
                    _timeB = -1;
                    _typeB = 0;
                    if (_logic getVariable ["WMT_CapturingInProgress", false] && !(_logic getVariable ["ZoneCapturedSuccesfully", false])) then {
                        ["WMT_CapturingAborted"] call bis_fnc_showNotification;
                        missionNamespace setVariable ["WMT_Global_Notice_ZoneCapturingAborted", true, true];
                        [false, [], _arrMarkers, _logic] spawn _fnc_blinkMarker;
                        _logic setVariable ["WMT_CapturingInProgress", false];
                    } else {
                        [false, [], _arrMarkers, _logic] spawn _fnc_blinkMarker;
                    };
                };

                sleep 3.12;
            };

            //Remove trigers
            {deleteVehicle  _x} forEach _arrTrgs;

            _logic setVariable ["WMT_TaskEnd", true, true];
        };
    };
    //===============================================================
    //                             Client part
    //===============================================================
    if (!isDedicated) then {
        if (isNil "WMT_PointLogics") then { WMT_PointLogics = []; };
        WMT_PointLogics pushBack _logic;
        if (isNil "WMT_ZonesPerimeterPoints") then { WMT_ZonesPerimeterPoints = createHashMap; };
        private _markerStr = _logic getVariable "Marker";
        private _arrMarkers = _markerStr splitString ",";
        {
            private _points = [_x, 10] call HIA3_spectator_fnc_getMarkerPerimPoints;
            WMT_ZonesPerimeterPoints set [_x, _points];
        } forEach _arrMarkers;

        if (isNil "WMT_ClientInit_Point") then {
            WMT_ClientInit_Point = true;

            "WMT_Global_Notice_ZoneCaptured" addPublicVariableEventHandler {
                if (count (_this select 1) == 2) then {
                    private ["_side", "_logic", "_msg"];

                    _side  = (_this select 1) select 0;
                    _logic = (_this select 1) select 1;

                    _msg = _logic getVariable "Message";

                    [_side, _msg] call WMT_fnc_ShowTaskNotification;
                };
            };
            "WMT_Global_Notice_ZoneCapturingStarted" addPublicVariableEventHandler {
                ["WMT_CapturingStarted", (_this select 1)] call bis_fnc_showNotification;
            };
            "WMT_Global_Notice_ZoneCapturingAborted" addPublicVariableEventHandler {
                ["WMT_CapturingAborted"] call bis_fnc_showNotification;
            };
        };
    };
};
