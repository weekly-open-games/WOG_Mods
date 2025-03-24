/*
    Name: WMT_fnc_GetVehicles

    Author(s):
        Zealot

    Description:
        Get vehicles array

    Parameters:
        NONE

    Returns:
        ARRAY: vehicles
*/

if (isNil "WMT_Local_Vehicles") then {
    WMT_Local_Vehicles = [];
    {
        if (_x isKindOf "Ship" || _x isKindOf "Air" || _x isKindOf "LandVehicle") then {
            WMT_Local_Vehicles pushBack _x;
        };
    } forEach vehicles;
};
WMT_Local_Vehicles
