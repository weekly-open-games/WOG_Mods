private["_isplayer"];
{
    if (side _x != civilian) then {
        _isplayer = _x getVariable ["PlayerName", nil];
        if (isNil "_isplayer") then {
            deleteVehicle _x;
        };
    };
} forEach playableUnits;