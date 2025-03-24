/*
     Name: WMT_fnc_InitModuleTaskCompose

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
        if(isNil "WMT_Local_PointArray") then {
            WMT_Local_PointArray = [];
        };
        [_logic, DELAY] spawn {
            params ["_logic", "_delay"];
            private _winner = [east,west,resistance,civilian,sideLogic] select (_logic getVariable "Winner");
            private _count = _logic getVariable "Count";
            private _msg = _logic getVariable "Message";

            private _condition = compile (_logic getVariable ["Condition","true"]);
            private _tasks = [];

            {
                if (typeOf _x in ["WMT_Task_Destroy","WMT_Task_Arrive","WMT_Task_Point","WMT_Task_CapturePoint","WMT_Task_VIP"]) then {
                    _tasks pushBack _x;
                };
            } forEach (synchronizedObjects _logic);

            sleep _delay;

            private _points = WMT_Local_PointArray;

            while { !(({_x getVariable ["WMT_TaskEnd", false]} count _tasks >= _count) && (call _condition)) } do {
                sleep 2.3;
            };

            // End mission
            [[_winner, _msg], {_this call WMT_fnc_EndMission;}] remoteExec ["bis_fnc_spawn"];
        };
    };
};
