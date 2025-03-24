/*
    Name: WMT_fnc_FreezePlayerClient

    Author(s):
        Zealot

    Description:

    Parameters:
        0 - size of start zone

    Returns:
        Nothing
*/
params [["_frzdistance", 150]];

wmt_frzdistance = _frzdistance;
wmt_frzmaxdistance = wmt_frzdistance + 20;

if (isNil "wmt_freeze_startpos") then {
    if (surfaceIsWater getPosATL player) then {
        wmt_freeze_startpos = getPosASL player;
    } else {
        wmt_freeze_startpos = getPosATL player;
    };
};

if (isNil "wmt_freeze_marker") then {
    ["WMTPlayerFreeze",wmt_freeze_startpos,"","ColorGreen","EMPTY",[wmt_frzdistance, wmt_frzdistance],"ELLIPSE",0,"Solid"] call WMT_fnc_CreateLocalMarker;
};

sleep 0.01;

// wmt_freezeGrenadeHandler = player addEventHandler ["Fired", { if (WMT_pub_frzState < 3) then { deleteVehicle (_this select 6);};}];

wog_safezone_muzzles = getArray (configFile >> "CfgWeapons" >> "Throw" >> "muzzles") + getArray (configFile >> "CfgWeapons" >> "Put" >> "muzzles");

wog_safezone = {
    if (true) then {
        {
            _this setWeaponReloadingTime [_this, _x, 1];
        } forEach wog_safezone_muzzles;
        true
    } else {
        false
    };
};
_wog_freez_action = player addAction ["", {true}, [], -99, false, true, "DefaultAction", "call wog_safezone"];
[player, "blockThrow", "wmt_freezetime0", true] call ace_common_fnc_statusEffect_set;

wmt_frz_vehs = [];
private ["_evh", "_handler"];
{
    _evh = _x addEventHandler ["Fired",{if (WMT_pub_frzState < 3) then { deleteVehicle (_this select 6);};}];
    _x setVariable ["frz_evh", _evh];
    wmt_frz_vehs pushBack _x;

    _handler = _x addEventHandler ["Engine", {
        _car = _this select 0;
        _engineon = _this select 1;
        if ( WMT_pub_frzState < 3 && local _car && _engineon) then {
            player action ["engineoff", _car]; _car engineOn false;
        };
    }];
    _x setVariable ["wmtfrzEngine", _handler];

} forEach (call WMT_fnc_GetVehicles);

0 spawn {
    while {WMT_pub_frzState < 3} do {
        setDate WMT_pub_frzBeginDate;
        sleep 30;
    };
};

while {WMT_pub_frzState < 3} do {
    if (serverCommandAvailable("#kick")) then {continue};
    // Check UAV terminal
    if(!isNull (findDisplay 160)) then {
        (findDisplay 160) closeDisplay 0;
        ["<t size='0.7' color='#ff2222'>"+localize "STR_WMT_FreezeUAVTerminal"+"</t>", 0, 0.2*safeZoneH+safeZoneY, 3, 0, 0, 273] spawn bis_fnc_dynamicText;
    };
    
        [player, "freeztime"] call ace_advanced_throwing_fnc_exitThrowMode;
    // check position
    if (!isNil "wmt_freeze_startpos" && {count wmt_freeze_startpos > 0}) then {
        
        private _dist = 0;
        if (surfaceIsWater getPosATL player) then {
            _dist = (getPosASL player) distance wmt_freeze_startpos;
        } else {
            _dist = (getPosATL player) distance wmt_freeze_startpos;
        };

        if ( _dist > wmt_frzdistance && _dist < wmt_frzmaxdistance ) then {
            _msg = "<t size='0.75' color='#ff0000'>"+localize "STR_WMT_FreezeZoneFlee" +"</t>";
            [_msg, 0, 0.25, 3, 0, 0, 27] spawn bis_fnc_dynamicText;

        };
        if (_dist > wmt_frzmaxdistance) then {
            player setVelocity [0,0,0];
            if (surfaceIsWater getPosATL player) then {
                player setPosASL wmt_freeze_startpos;
            } else {
                player setPosATL wmt_freeze_startpos;
            };
        };
    };
    if ((!isNull objectParent player) && {local (vehicle player)} && {isEngineOn (vehicle player)}) then {
        (vehicle player) engineOn false;
    };
    sleep 1.05;
};

[player, "blockThrow", "wmt_freezetime0", false] call ace_common_fnc_statusEffect_set;

setDate WMT_pub_frzBeginDate;

deleteMarkerLocal "WMTPlayerFreeze";
// if !(isNil "wmt_freezeGrenadeHandler") then {
    // player removeEventHandler ["Fired",wmt_freezeGrenadeHandler];
    // wmt_freezeGrenadeHandler = nil;
// };

player removeAction _wog_freez_action;

{
    private _evh = _x getVariable "frz_evh";
    if (!isNil "_evh") then {
        _x removeEventHandler ["Fired", _evh];
    };
    _x removeEventHandler ["Engine", (_x getVariable ["wmtfrzEngine",0]) ];
} forEach wmt_frz_vehs;
wmt_frz_vehs = nil;
wmt_frzdistance = nil;
wmt_frzmaxdistance = nil;
if ((profileNamespace getVariable ['WMT_BeepAfterFreezeOption', 0]) == 1) then {playSound "wmt_beep";};
