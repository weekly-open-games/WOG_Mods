private _txt = "";
private _units = units group player;

private _fnc_fixPicName = {
	private _pic = _this;
	
	if (_pic regexMatch ".*\.paa$|.*\.pac$|.*\.jpg$|.*\.jpeg$" || _pic isEqualTo "") exitWith {_pic};
	
	_pic = _pic + ".paa";
	_pic
};

private _fnc_getMagazinesForWeapon = {
	params ["_weapon", "_mag"];

	private _wmag = compatibleMagazines _weapon;
	private _result = [];
	{
		if (_x in _wmag) then {
			_result pushBack _x;
		};
	} forEach _mag;
	_result
};

private _fnc_textForWeapon = {
	params ["_weapon", "_items"];

	if (_weapon != "") then {
		private _name = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
		private _pic = getText (configFile >> "CfgWeapons" >> _weapon >> "picture");
		_txt = _txt + "<br/>" + _name + "<br/>" + format ["<img image='%1' height=36 />", _pic call _fnc_fixPicName] + "Compatible items: ";
		private _wm = [_weapon, _magazines] call _fnc_getMagazinesForWeapon;
		_magazines = _magazines - _wm;

		{
			_x params ["_className", "_count"];
			private _pic = getText (configFile >> "CfgMagazines" >> _className >> "picture");
			private _tooltip = getText (configFile >> "CfgMagazines" >> _className >> "displayName");
			_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
		} forEach (_wm call BIS_fnc_consolidateArray);

		{
			private _pic = getText (configFile >> "CfgWeapons" >> _x >> "picture");
			private _tooltip = getText (configFile >> "CfgWeapons" >> _x >> "displayName");
			_txt = _txt + format [" <img image='%1' title='%2' height=28/>", _pic call _fnc_fixPicName, _tooltip];
		} forEach _items;
	};
};

{
	private _unit = _x;
	private _unitName = if (isPlayer _unit) then {name _unit} else {"[AI]"};
	private _unitDesc = getText (configOf _unit >> "displayName");

	private _weapon = if (primaryWeapon _unit == "") then {""} else {getText (configFile >> "CfgWeapons" >> primaryWeapon _unit >> "displayName")};
	_txt = _txt + format ["%1: <font color='#c7861b'>%2</font> (%3) %4<br/>", _forEachIndex + 1, _unitName, _unitDesc, _weapon];

	private _magazines = magazines _unit + secondaryWeaponMagazine _unit + primaryWeaponMagazine _unit + handgunMagazine _unit;

	//==============================
	// Weapons
	//==============================
	[primaryWeapon _unit, primaryWeaponItems _unit - [""]] call _fnc_textForWeapon;
	_txt = _txt + "<br/>";
	
	[secondaryWeapon _unit, []] call _fnc_textForWeapon;
	
	[handgunWeapon _unit, []] call _fnc_textForWeapon;
	
	if (secondaryWeapon _unit != "" || handgunWeapon _unit != "") then {
		_txt = _txt + "<br/>";
	};

	//==============================
	// Assigned Items
	//==============================
	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgWeapons" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgWeapons" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
	} forEach ((assignedItems _unit) call BIS_fnc_consolidateArray);

	_txt = _txt + "<br/>";

	//==============================
	// Uniform
	//==============================
	private _pic = getText (configFile >> "CfgWeapons" >> uniform _unit >> "picture");
	private _tooltip = getText (configFile >> "CfgWeapons" >> uniform _unit >> "displayName");
	_txt = _txt + format ["<img image='%1' title='%2' height=36 /> ", _pic call _fnc_fixPicName, _tooltip];

	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgMagazines" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgMagazines" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
		
		if ((_forEachIndex + 1) % 9 == 0) then { // limit to 9 items in row
			_txt = _txt + "<br/>";
		};
	} forEach (uniformItems _unit call BIS_fnc_consolidateArray);

	_txt = _txt + "<br/>";

	//==============================
	// Vest
	//==============================
	private _pic = getText (configFile >> "CfgWeapons" >> vest _unit >> "picture");
	private _tooltip = getText (configFile >> "CfgWeapons" >> vest _unit >> "displayName");
	_txt = _txt + format ["<img image='%1' title='%2' height=36 /> ", _pic call _fnc_fixPicName, _tooltip];

	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgMagazines" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgMagazines" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
		
		if ((_forEachIndex + 1) % 9 == 0) then { // limit to 9 items in row
			_txt = _txt + "<br/>";
		};
	} forEach ((vestItems _unit) call BIS_fnc_consolidateArray);

	_txt = _txt + "<br/>";

	//==============================
	// Backpack
	//==============================
	private _pic = getText (configFile >> "CfgWeapons" >> backpack _unit >> "picture");
	private _tooltip = getText (configFile >> "CfgWeapons" >> backpack _unit >> "displayName");
	_txt = _txt + format ["<img image='%1' title='%2' height=36 /> ", _pic call _fnc_fixPicName, _tooltip];

	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgMagazines" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgMagazines" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
		
		if ((_forEachIndex + 1) % 9 == 0) then { // limit to 9 items in row
			_txt = _txt + "<br/>";
		};
	} forEach ((backpackItems _unit) call BIS_fnc_consolidateArray);

	_txt = _txt + "<br/><br/><br/>";
} forEach _units;

player createDiaryRecord ["diary", [format ["%1 (%2)", localize "STR_WMT_MySquad", groupId group player], _txt, "\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa"]];