private "_infoStr5";
if (count WMT_pub_frzVoteWait != 0 || count WMT_pub_frzVoteStart != 0) then {
    _infoStr5 = format ["<t size='0.4' color='#aaaaaa'>"+localize "STR_WMT_FreezeVoteStartCaption"+" %1<br/>"+localize "STR_WMT_FreezeVoteWaitCaption"+" %2<br/></t>",
    [WMT_pub_frzVoteStart] call WMT_fnc_ArrayToString, [WMT_pub_frzVoteWait] call WMT_fnc_ArrayToString ];
} else {
    _infoStr5="";
};
[_infoStr5, 0.3, safeZoneY+0.01, 1.5, 0, 0, 4]  spawn bis_fnc_dynamicText;
