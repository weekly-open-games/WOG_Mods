/*
    Name:
        WMT_fnc_BriefingTimer

    Author(s):
        Zealot, Ezhuk

    Description:
        Add timer in briefing on top panel.
        Disable posability to sart mission by key.

    Parameters:
        Nothing

    Returns:
        Nothing
*/
if (!hasInterface) exitWith {};
private["_display", "_ctrl", "_timeStart", "_eh"];

disableSerialization;
uiSleep 1.0;

_display = uiNamespace getVariable ["RscDiary",displayNull];
if (isNull _display) exitWith {};
_ctrl = _display ctrlCreate ["RscText", -1];
_ctrl ctrlSetPosition [0.5, safeZoneY, 0.15, 0.05];
_ctrl ctrlSetText "00:00";
_ctrl ctrlSetTextColor [0.75, 0.75, 0.75, 1];
_ctrl ctrlCommit 0;
_timeStart = diag_tickTime;

// Restrict start game by keyboard
_eh = _display displayAddEventHandler ["KeyDown", "(_this select 1) in [28,57,156];"];

while {time < 0.1} do {
    _s1 = [diag_tickTime - _timeStart, "MM:SS"] call BIS_fnc_secondsToString;
    _ctrl ctrlSetText _s1;
    _ctrl ctrlCommit 0;
    uiSleep 0.1;
};

ctrlDelete _ctrl;
_display displayRemoveEventHandler ["KeyDown",_eh];
