/*
	Name: WMT_fnc_DefaultFreqsClient

	Author(s):
		Zealot

	Description:
		Show frequences

	Parameters:
		Nothing

	Returns:
		Nothing
*/
if (!isClass (configFile >> "CfgPatches" >> "task_force_radio_items")) exitWith {diag_log "DefaultFreqClient TF radio not initialized"};

if (playerSide == civilian) exitWith {};

waitUntil {uiSleep 1; !isNil "wmt_global_freqList" or time > 30};

if(isNil "wmt_global_freqList" ) exitWith {diag_log "WMT_fnc_DefaultFreqsClient: wmt_global_freqList is null"};

private _sideToColor = {
	switch(_this select 0) do {
		case west:{"#288cf0"};
		case east:{"#cd2e2e"};
		case resistance:{"#2bed2b"};
		default{"#ececec"};
	};
};

private _printFrq = {
	private _str = _this;
	private _txt = "";
	private _arrFrq = _str select 1;

	switch ( typeName (_str select 0)) do {
		case ("SIDE") : {
			_txt = "<font>" + format[localize "STR_WMT_FREQ_LR",_arrFrq select 0, _arrFrq select 1, _arrFrq select 2, _arrFrq select 3] + "</font><br/><br/>";
		 };
		case ("GROUP") : {
			private _leader = leader (_str select 0);
			private _tcolor = [side (_str select 0)] call _sideToColor;
			if (_leader == leader player) then {
				_tcolor = "#c7861b";
			};
			_txt = format["<font color='%3'>%1 %2</font><br/>", (groupId(_str select 0)) call wmt_fnc_LongGroupNameToShort, if(isPlayer _leader)then{name _leader}else {""}, _tcolor ];
			_txt = _txt + format[localize "STR_WMT_FREQ_SR", _arrFrq select 0, _arrFrq select 1, _arrFrq select 2, _arrFrq select 3];
		};
	};
	_txt;
};


private _friends = ([side player] call BIS_fnc_friendlySides) - [civilian];
private _friendsids = [];
private _playersideid = [playerSide] call BIS_fnc_sideID;
private _txt = (wmt_global_freqList select _playersideid) call _printFrq;
private _groupFreq  = "";

{
	if ( typeName (_x select 0) == typeName grpNull && {side (_x select 0) in _friends} && { leader (_x select 0) in allUnits} ) then {
		_txt = _txt + (_x call _printFrq) + "<br/><br/>";
	};
} forEach wmt_global_freqList;


["diary", localize "STR_WMT_FREQ_HDR", _txt, "\WMT_Main\pic\radio_ca.paa"] call WMT_fnc_CreateDiaryRecord;
