/*
    Name: WMT_fnc_DefaultFreqsServer

    Author(s):
        [KND]Liquid
        Based on Zealot code

    Description:
        Generate frequencies

    Parameters:
        Nothing

    Returns:
        Nothing
*/

if (!isClass (configFile >> "CfgPatches" >> "task_force_radio_items")) exitWith {
    diag_log "WMT_fnc_DefaultFreqsServer TFAR radio not initialized";
};

tf_same_sw_frequencies_for_side = false;
tf_same_lr_frequencies_for_side = true;
tf_same_dd_frequencies_for_side = true;

private _fnc_genFreqArray = {
    params ["_isLR", "_arraySize"];

    if (isNil "wmt_frqBlackList") then {
        wmt_frqBlackList = [0];
    };
    //LR limits as default
    private _min_freq = 30;
    private _max_freq = 87;

    if (!_isLR) then {
        // SR limits
        _min_freq = 100; // TFAR limit is 30
        _max_freq = 512;
    };

    private _return = [];
    for "_i" from 1 to _arraySize step 1 do {
        private _isBlacklisted = false;
        private _freq = _min_freq;
        while {!_isBlacklisted} do {
            _freq = round (((random (_max_freq - _min_freq)) + _min_freq) * 10) / 10; // 123.4 66.3
            if (!(_freq in wmt_frqBlackList)) then {
                 wmt_frqBlackList pushBack _freq;
                _isBlacklisted = true;
            };
        };
        _return pushBack _freq;
    };

    _return
};

private _freqSettings = [];
{
    private _freqs = [];
    switch (true) do {
        case (_x == resistance && {[east, resistance] call BIS_fnc_areFriendly}): {
            _freqs = (_freqSettings select 0) select 1;
        };
        case (_x == resistance && {[west, resistance] call BIS_fnc_areFriendly}): {
            _freqs = (_freqSettings select 1) select 1;
        };
        default {
            _freqs = [true, 4] call _fnc_genFreqArray;
        };
    };
    _freqSettings pushBack [_x, _freqs];
} forEach [east, west, resistance];

if (isNil "TF_MAX_CHANNELS") then {
    call compileScript ["\task_force_radio\functions\common.sqf"];
};

[] call TFAR_fnc_processGroupFrequencySettings;

// Generate SR freqs per squad and inject first generated frequency to SR radio settings
{
    private _groupSwSettings = _x getVariable "tf_sw_frequency";
    private _groupLrSettings = _x getVariable "tf_lr_frequency";
    private _freqs = [false, 4] call _fnc_genFreqArray;
    _freqSettings pushBack [_x, _freqs];

    (_groupSwSettings select 2) set [0, str (_freqs select 0)];
    _x setVariable["tf_sw_frequency", _groupSwSettings, true];

    //Inject first generated LR frequency to LR radio settings (per side)
    private _lrFreqs = [];
    switch (side _x) do {
        case (east): { _lrFreqs = (_freqSettings select 0) select 1; };
        case (west): { _lrFreqs = (_freqSettings select 1) select 1; };
        default { _lrFreqs = (_freqSettings select 2) select 1; };
    };

    (_groupLrSettings select 2) set [0, str (_lrFreqs select 0)];
    _x setVariable["tf_lr_frequency", _groupLrSettings, true];

    switch (side _x) do {
        case (east): { missionNamespace setVariable ["tf_freq_east_lr", _groupLrSettings, true]; };
        case (west): { missionNamespace setVariable ["tf_freq_west_lr", _groupLrSettings, true]; };
        default { missionNamespace setVariable ["tf_freq_guer_lr", _groupLrSettings, true]; };
    };

} forEach allGroups;

/* wmt_global_freqList array structure
[
    [east, [30.1, 45.4, 80.4, 76.5]],
    [west, [32.1, 54.6, 83.7, 55.6]],
    [resistance, [30.2, 45.4, 80.4, 76.5]], //same as east if allies to east
    [A1-1, [123.4, 435.2, 334.2, 503.9]],
    [A1-2, [133.3, 231.1, 423.1, 122.9]],
    ...
]
*/
missionNamespace setVariable ["wmt_global_freqList", _freqSettings, true];