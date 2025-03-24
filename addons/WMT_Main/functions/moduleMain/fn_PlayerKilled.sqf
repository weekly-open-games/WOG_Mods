/*
    Name: WMT_fnc_PlayerKilled

    Author(s):
        Ezhuk

    Description:
        Callback for event "Killed"

    Parameters:
        Nothing

    Returns:
        Nothing
*/

if(wmt_param_Statistic==0)exitWith{};

closeDialog 0;

private ["_killer","_killerName","_killerSide"];

_killer = effectiveCommander (_this select 1);
if (isNil "_killer" || {isNull _killer}) then {
    _killer = WMT_Local_LastDamageSource;
};

_killerName = _killer getVariable "PlayerName";
if (isNil "_killerName" || {_killerName isEqualTo ""}) then {
  _killer = WMT_Local_LastDamageSource;
  _killerName = _killer getVariable ["PlayerName", localize "STR_WMT_Unknow"];
};

_killerSide = _killer getVariable ["playerSide", sideLogic];

WMT_Local_Killer = [_killerName, _killerSide];

if (_killerName != WMT_Local_PlayerName) then {
    [[[WMT_Local_PlayerName, playerSide], {WMT_Local_Kills pushBackUnique (_this);}], "bis_fnc_spawn", _killer] call bis_fnc_mp;
};
