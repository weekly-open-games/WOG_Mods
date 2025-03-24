/*
    Name: WMT_fnc_DisableFuelStations;

    Author: [KND] Liquid

    Description:
    Disable Fuel Stations on map

    Parameter(s):
    None

    Returns:
    None
*/
    {
        [_x, -1] call ace_refuel_fnc_setFuel;
    }
    forEach nearestObjects
    [
        [worldSize/2, worldSize/2],
        ["Land_fs_feed_F", "Land_Fuelstation_Feed_F", "Land_Pod_Heli_Transport_04_fuel_F", "B_Slingload_01_Fuel_F", "StorageBladder_base_F", "Land_StorageBladder_01_F", "Land_FlexibleTank_01_F", "Land_FuelStation_01_pump_F", "Land_FuelStation_01_pump_malevil_F","Land_Benzina_schnell","Land_A_FuelStation_Feed","Land_Ind_FuelStation_Feed_EP1","Land_FuelStation_Feed_PMC"],
        worldSize
    ];
