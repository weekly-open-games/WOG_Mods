/*
	Name: WMT_fnc_FreezeUI

	Author(s):
		Zealot

	Description:

	Parameters:
		Nothing

	Returns:
		Nothing
*/
private _action = -1;
private _gearaction = -1;

sleep 0.01;

if (!isNil "wmt_feature_frzLegacyActions") then {
	if (leader player == player || serverCommandAvailable('#kick') ) then {
		_action = player addAction ["<t color='#0353f5'>"+localize('STR_WMT_DontRemove')+"</t>",{cursorTarget setVariable ["PlayerName", "AI", true];}, [], -1, false, true, "", 'cursorTarget isKindOf "Man" && {cursorTarget in (units group player)} && {(cursorTarget getVariable ["PlayerName",""]) == "" } '];
		if(isNil "WMT_flg_NotAllowGearActionWhileFreeze") then {
			_gearaction = player addAction ["<t color='#0353f5'>"+localize('STR_WMT_FreezeAIINv')+"</t>", {player action ["Gear", cursorTarget];},  [], -1, false, true, "", 'cursorTarget isKindOf "Man" && {cursorTarget in (units group player)} && {!isplayer cursorTarget}'];
			};
	};
};

while {WMT_pub_frzState < 3} do {

	private _time3 = round(WMT_pub_frzTimeLeft);
	private _sec = 0;
	if (WMT_pub_frzState == 2) then {
		_sec = round (WMT_pub_frzTimeLeftForced);
	} else {
		_sec = _time3;
	};
	private _infoStr1 = format ["<t size='0.6' color='%2'>%1</t>", [0 max (_sec min _time3),"MM:SS"] call BIS_fnc_secondsToString, ["#ff0000", "#cccccc"] select (_sec >= 30 )];
	[_infoStr1, 0, safeZoneY+0.01, 1.5, 0, 0, 3] spawn bis_fnc_dynamicText;


	0 call WMT_fnc_FreezeVoteInfo;
	sleep 1;
	if (WMT_pub_frzState == 2 && !isServer) then { WMT_pub_frzTimeLeftForced = WMT_pub_frzTimeLeftForced - 1; };
	if (!isServer) then { WMT_pub_frzTimeLeft = WMT_pub_frzTimeLeft - 1; };
};

["<t size='1' color='#ff0000'>"+localize "STR_WMT_FreezeStart"+"</t>", 0,safeZoneY+0.01,5,0,0,3] spawn bis_fnc_dynamicText;
player removeAction _action;
player removeAction _gearaction;
