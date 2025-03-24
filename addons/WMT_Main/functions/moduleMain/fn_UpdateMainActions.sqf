/*
 	Name: WMT_fnc_UpdateMainActions

 	Author(s):
		Ezhuk

 	Description:
		Add actions
*/
if (wmt_param_IndetifyTheBody==1) then {
	player addAction[ format ["<t color='#0353f5'>%1</t>", localize "STR_WMT_IndetifyTheBody_Action"] , WMT_fnc_IndetifyTheBody, [], -1, false, false, '','vehicle player == player && {cursorTarget isKindOf "Man"} && {!(alive cursorTarget)} && {cursorTarget distance player < 5}'];
};
