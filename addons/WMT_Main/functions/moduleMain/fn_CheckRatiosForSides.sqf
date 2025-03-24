params ["_enemySides"];

_countBegin = 0;
_countNow = 0;

{
    _countBegin = _countBegin + (WMT_playerCountInit get _x);
    _countNow = _countNow + (WMT_playerCountNow get _x);
} forEach _enemySides;

[_countNow, _countBegin]
