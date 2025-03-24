/*
    Name: WMT_fnc_BoundingBoxMarker

    Author(s):
        Ezhuk

    Description:
        Draw marker on object.
        Modifined BIS_fnc_BoundingBoxMarker.

    Parameters:
        0: object
        1: color (opt)
        2: alpha (opt)
    Returns:
        Nothing

    Example:
        [this] call WMT_fnc_BoundingBoxMarker
        [this,"ColorGrey",0.5] call WMT_fnc_BoundingBoxMarker
*/

if (!hasInterface) exitWith {};

params ["_obj", ["_color", "ColorGrey"], ["_alpha", 1.0]];

private _logic = bis_functions_mainscope;
private _id    = if (isNil {_logic getVariable "bundingBoxMarker_id"}) then {_logic setVariable ["bundingBoxMarker_id",-1];-1} else {_logic getVariable "bundingBoxMarker_id"};

[_logic,"bundingBoxMarker_id",1] call bis_fnc_variablespaceadd;

private _bbox   = boundingBoxReal _obj;
private _b1     = _bbox select 0;
private _b2     = _bbox select 1;
private _bbx    = (abs(_b1 select 0) + abs(_b2 select 0));
private _bby    = (abs(_b1 select 1) + abs(_b2 select 1));

private _marker = createMarkerLocal [format ["WMT_BundingBoxMarker_%1",_id],position _obj];

_marker setMarkerDirLocal   direction _obj;
_marker setMarkerShapeLocal "rectangle";
_marker setMarkerBrushLocal "SolidFull";
_marker setMarkerSizeLocal  [_bbx/2,_bby/2];
_marker setMarkerColorLocal  _color;
_marker setMarkerAlpha       _alpha;

_marker
