/*
    Name: WMT_fnc_CreateGlobalMarker

    Author(s):
        Zealot

    Description:
        Creating  marker

    Parameters:
        0 - name
        1 - position
        2 - text
        3 - color
        4 - type
        5 - size
        6 - shape
        7 - direction
        8 - brush

    Returns:
        Marker
*/

params [["_marker", "mrk"], ["_pos", [0,0]], ["_text", ""], ["_color", "ColorOrange"], ["_type", "mil_dot"], ["_size", [1,1]], ["_shape", "ICON"], ["_dir", 0], ["_brush", "Solid"]];

createMarker [_marker, _pos];

_marker setMarkerShapeLocal _shape;
_marker setMarkerTypeLocal   _type;
_marker setMarkerTextLocal   _text;
_marker setMarkerColorLocal _color;
_marker setMarkerDirLocal    _dir;
_marker setMarkerBrushLocal _brush;
_marker setMarkerSizeLocal   _size;
_marker setMarkerPos         _pos; // Only last command can be global to send it to all clients

_marker
