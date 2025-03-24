/*
     Name: WMT_fnc_InitModuleTaskArrive

     Author(s):
        Ezhuk
*/
#include "defines.sqf"

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if(_activated) then {
    //===============================================================
    //                             Server part
    //===============================================================
    if(isServer) then {
        [_logic, _units, DELAY] spawn {
            params ["_logic", "_units", "_delay"];
            private ["_marker", "_message", "_count", "_winner", "_condition"];
            _marker = _logic getVariable "Marker";
            _message= _logic getVariable "Message";
            _count  = _logic getVariable "Count";
            _winner    = [east,west,resistance,civilian,sideLogic] select (_logic getVariable "Winner");

            _condition = compile (_logic getVariable ["Condition","true"]);

            private ["_countArrived", "_objs", "_tempObjs"];
            _countArrived = 0;
            _objs = _units;

            sleep _delay;

            while { !(_countArrived>=_count && call _condition) } do
            {
                _tempObjs = _objs;
                {
                    if ([_x,_marker] call WMT_fnc_IsTheUnitInsideMarker) then {
                        private ["_name", "_text"];
                        _countArrived = _countArrived + 1;
                        _objs = _objs - [_x];

                        WMT_Global_Notice_ObjectArrived = [_winner, _x];
                        publicVariable "WMT_Global_Notice_ObjectArrived";

                        _name = _x getVariable ["WMT_DisplayName", getText (configOf _x >> "displayName")];
                        _text = _name + " " + localize "STR_WMT_Arrived";

                        [_winner, _text] call WMT_fnc_ShowTaskNotification;

                    };
                } forEach _tempObjs;

                sleep 4.13;
            };

            if ( {typeOf _x == "WMT_Task_Compose"} count synchronizedObjects _logic == 0) then {
                // End mission
                [[_winner, _message], {_this call WMT_fnc_EndMission;}] remoteExec ["bis_fnc_spawn"];
            } else {
                _logic setVariable ["WMT_TaskEnd", true, true];
            };
        };
    };
    //===============================================================
    //                             Client part
    //===============================================================
    if(!isDedicated) then {
        if(isNil "WMT_ClientInit_Arrive") then {
            WMT_ClientInit_Arrive = true;
            "WMT_Global_Notice_ObjectArrived" addPublicVariableEventHandler {
                if(count (_this select 1) == 2) then {
                    private ["_winner", "_obj", "_name", "_text"];

                    _winner = (_this select 1) select 0;
                    _obj    = (_this select 1) select 1;

                    _name = _obj getVariable ["WMT_DisplayName", getText (configOf _obj >> "displayName")];
                    _text = _name + " " + localize "STR_WMT_Arrived";

                    [_winner, _text] call WMT_fnc_ShowTaskNotification;
                };
            };
        };
    };
};
