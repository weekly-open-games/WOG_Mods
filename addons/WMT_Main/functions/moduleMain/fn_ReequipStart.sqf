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


closeDialog 0;
if (isNull objectParent player) then {
    if (isNil "ace_common_fnc_progressBar") then {
        hint localize 'STR_WMT_3Sec';
        [] spawn {
            sleep 3;
            hint localize 'STR_WMT_Ready';
            [player] call WMT_fnc_Reequip;
        };
    } else {
        [3, [player], {(_this select 0) call WMT_fnc_Reequip}, '', '', {true}, ['isnotinside']] call ace_common_fnc_progressBar;
    };
} else {
    hint localize 'STR_WMT_Outside';
};
