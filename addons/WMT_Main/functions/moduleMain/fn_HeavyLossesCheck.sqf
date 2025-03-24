/*
    Name: WMT_fnc_HeavyLossesCheck

    Author(s):
        Zealot

    Description:
        Check losses
*/


params [["_playerRatio", 0.05, [0.05]]];

if (_playerRatio == 0) exitWith {};
if (!isServer) exitWith {};
if (!isNil "wmt_hl_disable") exitWith {diag_log "HeavyLossesCheck disabled";};

sleep 60;
waitUntil { sleep 1.5; (missionNamespace getVariable ["WMT_pub_frzState",3]) >=3 };

WMT_playerCountInit = [east, west, resistance] createHashMapFromArray [
    {side _x == east and isPlayer _x} count playableUnits,
    {side _x == west and isPlayer _x} count playableUnits,
    {side _x == resistance and isPlayer _x} count playableUnits
];


if (isNil "wmtPlayerCountEmptySides") then { wmtPlayerCountEmptySides = [civilian]; };
{
    if (_y == 0) then {
        wmtPlayerCountEmptySides = wmtPlayerCountEmptySides + [_x];
    };
} forEach WMT_playerCountInit;


private ["_enemysides","_ratios","_enemyRatio","_enemy"];
WMT_playerCountNow = [east, west, resistance] createHashMapFromArray [
    {side _x == east and isPlayer _x} count playableUnits,
    {side _x == west and isPlayer _x} count playableUnits,
    {side _x == resistance and isPlayer _x} count playableUnits
];

diag_log ["HeavyLosses start", missionName, WMT_playerCountNow, WMT_playerCountInit, wmtPlayerCountEmptySides, count playableUnits, {isPlayer _x} count playableUnits];
while {isNil "wmt_hl_disable" and isNil "WMT_Local_MissionEnd"} do {
    {
        private _side = _x;
        WMT_playerCountNow set [_side, {side _x == _side and isPlayer _x and !(_x getVariable ["ACE_isUnconscious", false])} count playableUnits];
    } forEach [east, west, resistance];

    WMT_currentEnemyRatios = createHashMap;
    {
        _enemySides = ([_x] call bis_fnc_enemySides) arrayIntersect [east, west, resistance];
        _ratios = [_enemySides] call WMT_fnc_CheckRatiosForSides;
        if ((_ratios select 1) != 0) then {
            _enemyRatio = (_ratios select 0) / (_ratios select 1);
            WMT_currentEnemyRatios set [_x, _ratios];
            if (_enemyRatio < _playerRatio) then {
                diag_log ["HeavyLosses triggered", missionName, WMT_playerCountNow, WMT_playerCountInit, wmtPlayerCountEmptySides, [_enemySides,_ratios,_enemyRatio]];
                if (isNil "wmt_hl_winmsg") then {
                    [
                        [_x, missionName],
                        {
                            diag_log ["HeavyLosses getMessage", _this select 1, missionName];
                            [_this select 0, format[localize "STR_WMT_HLSWinLoseMSG", ([_this select 0] call BIS_fnc_sideName)]] call WMT_fnc_endMission;
                        }
                    ] remoteExec ["bis_fnc_spawn"];
                } else {
                    [ [_x], { [_this select 0, format[wmt_hl_winmsg select ([_this select 0] call bis_fnc_sideid),([_this select 0] call BIS_fnc_sideName)]] call WMT_fnc_endMission; } ] remoteExec ["bis_fnc_spawn"];
                };
                wmt_hl_disable = true;
            };
        };

        if (WMT_param_TotalDominationCoeff > 1) then {
            private _totalEnemies = 0;
            {
                _totalEnemies = _totalEnemies + (WMT_playerCountNow getOrDefault [_x, 0]);
            } forEach _enemySides;

            if ((_totalEnemies / (WMT_playerCountNow get _x)) >= WMT_param_TotalDominationCoeff) then {
                diag_log format ["Total domination: %1 lose | %2 | %3 | %4", _x, _enemySides, _totalEnemies, WMT_playerCountNow];
                
                private _max = -1;
                private _winner = civilian;
                {
                    if ((WMT_playerCountNow get _x) > _max) then {
                        _max = WMT_playerCountNow get _x;
                        _winner = _x;
                    };
                } forEach _enemySides;
                [
                    [_winner], 
                    {
                        [_this select 0, format[localize "STR_WMT_TotalDominationMsg", _this select 0, WMT_param_TotalDominationCoeff]] call WMT_fnc_endMission; 
                    }
                ] remoteExec ["bis_fnc_spawn"];
            };
        };
    } forEach ([east, west, resistance] - wmtPlayerCountEmptySides);

    publicVariable "WMT_currentEnemyRatios";
    sleep 8.5;
};
