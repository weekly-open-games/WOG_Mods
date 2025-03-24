/*
    Name: WMT_fnc_Reequip

    Author(s):
		Ezhuk

    Description:
        ReEqup player

    Parameters:
        0: PLAYER

    Returns:
        NONE
*/


params ["_unit"];

if !(isNull (vestContainer player)) then
{
    private ["_vest", "_vestitems", "_vestmagaiznes"];
    _vest = vest _unit;
    _vestitems = vestItems _unit;
    _vestmagaiznes = magazinesAmmoCargo (vestContainer _unit);
    removeVest _unit;

    _unit addVest _vest;
    {
        if !(isClass (configFile >> "cfgMagazines" >> _x)) then
        {
            _unit addItemToVest _x;
        };
    } forEach _vestitems;
    {
        (vestContainer player) addMagazineAmmoCargo [_x select 0, 1, _x select 1];
    } forEach _vestmagaiznes;
};

//===========================

if !(isNull (uniformContainer player)) then
{
    private ["_uniform", "_uniformitems", "_uniformmagaiznes"];
    _uniform = uniform _unit;
    _uniformitems = uniformItems _unit;
    _uniformmagaiznes = magazinesAmmoCargo (uniformContainer _unit);
    removeUniform _unit;

    _unit forceAddUniform _uniform;
    {
        if !(isClass (configFile >> "cfgMagazines" >> _x)) then
        {
            _unit addItemToUniform _x;
        };
    } forEach _uniformitems;

    {
        (uniformContainer player) addMagazineAmmoCargo [_x select 0, 1, _x select 1];
    } forEach _uniformmagaiznes;
};
