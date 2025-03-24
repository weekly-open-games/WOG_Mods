private _txt = "";
private _units = units group player;

private _fnc_fixPicName = {
	params["_pic"];

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
		_txt = _txt + "<br/>" + _name + "<br/>" + format ["<img image='%1' title='%2' height=36 />", _pic call _fnc_fixPicName, _name];
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

	private _magazines = magazines _unit - backpackItems _unit + secondaryWeaponMagazine _unit + primaryWeaponMagazine _unit + handgunMagazine _unit;

	//==============================
	// Weapons
	//==============================
	[primaryWeapon _unit, primaryWeaponItems _unit - [""]] call _fnc_textForWeapon;
	_txt = _txt + "<br/>";
	
	// [secondaryWeapon _unit, []] call _fnc_textForWeapon;
	[secondaryWeapon _unit, secondaryWeaponItems _unit - [""]] call _fnc_textForWeapon;	
	
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
	} forEach ((assignedItems _unit - backpackItems _unit) call BIS_fnc_consolidateArray);
	_txt = _txt + "<br/>";

	//==============================
	// Other magazines and items
	//==============================
	private _colCount = 0;
	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgMagazines" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgMagazines" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
		_colCount = _colCount + 1;

		if (_colCount == 8) then { // limit to 8 items in row
			_txt = _txt + "<br/>";
			_colCount = 0;
		};
	} forEach (_magazines call BIS_fnc_consolidateArray);

	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgWeapons" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgWeapons" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic call _fnc_fixPicName, _tooltip, _count];
		_colCount = _colCount + 1;

		if (_colCount == 8) then { // limit to 8 items in row
			_txt = _txt + "<br/>";
			_colCount = 0;
		};
	} forEach (((uniformItems _unit - magazines _unit) + (vestItems _unit - magazines _unit)) call BIS_fnc_consolidateArray);
	
		_txt = _txt + "<br/>";	
	
/*
		private _className_u = uniform _unit;
		private _pic_u = getText (configFile >> "CfgWeapons" >> _className_u >> "picture");
		private _tooltip_u = getText (configFile >> "CfgWeapons" >> _className_u >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=72/>", _pic_u call _fnc_fixPicName, _tooltip_u];

	
		private _className_v = vest _unit;
		private _pic_v = getText (configFile >> "CfgWeapons" >> _className_v >> "picture");
		private _tooltip_v = getText (configFile >> "CfgWeapons" >> _className_v >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=72/>", _pic_v call _fnc_fixPicName, _tooltip_v];

		private _className_h = headgear _unit;
		private _pic_h = getText (configFile >> "CfgWeapons" >> _className_h >> "picture");
		private _tooltip_h = getText (configFile >> "CfgWeapons" >> _className_h >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=72/>", _pic_h call _fnc_fixPicName, _tooltip_h];
*/
	{
		_x params ["_className", "_count"];
		private _pic = getText (configFile >> "CfgWeapons" >> _className >> "picture");
		private _tooltip = getText (configFile >> "CfgWeapons" >> _className >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=72/>", _pic call _fnc_fixPicName, _tooltip];
	} forEach [uniform _unit, vest _unit,headgear _unit];

		_txt = _txt + "<br/>";	
		private _className_b = backpack _unit;
		private _pic_b = getText (configFile >> "CfgVehicles" >> _className_b >> "picture");
		private _tooltip_b = getText (configFile >> "CfgVehicles" >> _className_b >> "displayName");
		_txt = _txt + format ["<img image='%1' title='%2' height=72/>", _pic_b call _fnc_fixPicName, _tooltip_b];
		
	{
		_x params ["_className", "_count"];
		private _pic_w = getText (configFile >> "CfgWeapons" >> _className >> "picture");
		private _tooltip_w = getText (configFile >> "CfgWeapons" >> _className >> "displayName");
		if (_pic_w != "") then {_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic_w call _fnc_fixPicName, _tooltip_w, _count];};
		_colCount = _colCount + 1;

		// if (_colCount == 8) then { // limit to 8 items in row
			// _txt = _txt + "<br/>";
			// _colCount = 0;
		// };
		
		private _pic_m = getText (configFile >> "Cfgmagazines" >> _className >> "picture");
		private _tooltip_m = getText (configFile >> "Cfgmagazines" >> _className >> "displayName");
		if (_pic_m != "") then {_txt = _txt + format ["<img image='%1' title='%2' height=24/>x%3 ", _pic_m call _fnc_fixPicName, _tooltip_m, _count];};
		_colCount = _colCount + 1;

		if (_colCount == 8) then { // limit to 8 items in row
			_txt = _txt + "<br/>";
			_colCount = 0;
		};				
	} forEach ((backpackItems _unit) call BIS_fnc_consolidateArray);		

		_txt = _txt + "<br/><br/>";
} forEach _units;

player createDiaryRecord ["diary", [format ["%1 (%2)", localize "STR_WMT_MySquad", groupId group player], _txt, "\a3\ui_f\data\GUI\Rsc\RscDisplayMain\menu_multiplayer_ca.paa"]];