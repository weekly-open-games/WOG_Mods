/*
    Name:
    Author(s):
        Zealot
    Description:
    Parameters:
        Nothing
    Returns:
        Nothing
*/
#define PR(x) private ['x']; x

if (not isServer) exitWith {};
wmt_global_srvBrfData = [];

private _tempData = [];
private _vehinfo = [];
private _grpinfo = [];
private _side = civilian;
private _units = [];
private _group = [];
private _playersGr = 0;

private _vehicles = []; // vehicles to show in briefing as belong to either sides
private _boxes = []; // ammoboxes to show in "Vehicle inventory" tab only


{
    if ((_x isKindOf "Ship" || _x isKindOf "Air" || _x isKindOf "LandVehicle") && {!(_x isKindOf "Strategic") && !(_x isKindOf "Thing") && (_x getVariable ["wmt_show", true])}) then {
        _vehicles pushBack _x;
    } else {
        if (!(isNil {(weaponCargo _x + magazineCargo _x + itemCargo _x + backpackCargo _x)}) &&
            {count (weaponCargo _x + magazineCargo _x + itemCargo _x + backpackCargo _x) != 0}) then {
            _boxes pushBack _x;
        };
    };
} forEach vehicles;

// данные техники ["V", [координаты], "класс", сторона]
{
    _vehinfo = ["V"];
    _vehinfo pushBack getPos _x;
    _vehinfo pushBack typeOf _x;
    _side = _x getVariable ["WMT_Side", [getNumber (configOf _x >> "side")] call BIS_fnc_sideType];
    _vehinfo pushBack _side;
    _vehinfo pushBack (if (isNil {(weaponCargo _x + magazineCargo _x + itemCargo _x + backpackCargo _x)}) then {[]} else {(weaponCargo _x + magazineCargo _x + itemCargo _x + backpackCargo _x) call BIS_fnc_consolidateArray});
    _vehinfo pushBack true; // это обычная техника
    _tempData pushBack _vehinfo;
} forEach _vehicles;

{
    _vehinfo = ["V"];

    _vehinfo pushBack getPos _x;
    _vehinfo pushBack typeOf _x;
    // сторона определяется по ближайшему юниту
    private _allGroups = allGroups;
    private _veh = _x;
    _allGroups = [_allGroups,[],{_veh distance (leader _x)},"ASCEND"] call BIS_fnc_sortBy;
    _side = _x getVariable ["WMT_Side", side (_allGroups select 0)];

    _vehinfo pushBack _side;
    _vehinfo pushBack (if (isNil {(weaponCargo _x + magazineCargo _x + itemCargo _x + backpackCargo _x)}) then {[]} else {(weaponCargo _x + magazineCargo _x + itemCargo _x + backpackCargo _x) call BIS_fnc_consolidateArray});
    _vehinfo pushBack false; // это ящики
    _tempData pushBack _vehinfo;
} forEach _boxes;

// данные отряда ["S", [координаты], "GroupID", сторона, число игроков, "имя лидера",[юниты] ]
{
    if ((leader _x) in playableUnits && (_x getVariable ["wmt_show", true]) ) then {
        _grpinfo = ["S"];

        _grpinfo pushBack getPos leader _x;
        _grpinfo pushBack groupId _x;
        _grpinfo pushBack side leader _x;

        _units = [];
        {
            _units pushBack [typeOf _x, if(isPlayer _x) then {name _x} else {""}, _x];

        } forEach units _x;

        _playersGr = 0;
        {
            if (isPlayer _x) then {_playersGr=_playersGr+1;};
        } forEach units _x;

        _x setVariable ["WMT_BriefingUnitsInfo", _units, true];

        _grpinfo pushBack _playersGr;
        _grpinfo pushBack (if (isPlayer leader _x) then {name leader _x} else {""});
        _grpinfo pushBack _units;

        _tempData pushBack _grpinfo;
    };
} forEach allGroups;

wmt_global_srvBrfData = _tempData;
publicVariable "wmt_global_srvBrfData";
