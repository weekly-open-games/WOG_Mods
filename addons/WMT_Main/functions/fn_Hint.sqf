/*
    Name: WMT_fnc_Hint based on CBA_fnc_notify

    Author(s):
        [KND]Liquid

    Description:
        Customizable WMT hint

    Parameters:
        [
            [
                Line 1 text,
                size,
                [color_RGBA]
            ],
            [
                Line 2 text,
                size,
                [color_RGBA]
            ],
            _notifyLifetime
        ]

    Returns:
        None

    Example:
    [["Banana", 1.5, [1, 1, 0, 1]], ["Not Apple"], true, 0.5] call WMT_fnc_Hint;
*/

#define FADE_IN_TIME 0.1
#define FADE_OUT_TIME 0.1
#define GUI_GRID_WAbs            ((safeZoneW / safeZoneH) min 1.2)
#define GUI_GRID_HAbs            (GUI_GRID_WAbs / 1.2)
#define GUI_GRID_W            (GUI_GRID_WAbs / 40)
#define GUI_GRID_H            (GUI_GRID_HAbs / 25)

if (canSuspend) exitWith {
    [CBA_fnc_notify, _this] call CBA_fnc_directCall;
};

if (!hasInterface) exitWith {};

private _args = _this;

// compose structured text
if !(_this isEqualType []) then {
    _args = [_this];
};

if !(_args select 0 isEqualType []) then {
    _args = [_args];
};

private _composition = [];
private _skippable = false;
private _notifyLifetime = 1;

{
    // Additional arguments at the end
    if (_x isEqualType true) exitWith {
        //TRACE_1("Skippable argument",_x);
        _skippable = _x;
    };

    if (_x isEqualType 999) exitWith {
        //TRACE_1("NotifyLifetime argument",_x);
        _notifyLifetime = _x;
    };

    // Line
    _composition pushBack lineBreak;

    _x params [["_text", "", ["", 0]], ["_size", 1, [0]], ["_color", [], [[]], [3,4]]];

    if (_text isEqualType 0) then {
        _text = str _text;
    };

    _size = _size * 0.55 / (getResolution select 5);

    _color params [
        ["_r", 1, [0]],
        ["_g", 1, [0]],
        ["_b", 1, [0]],
        ["_a", 1, [0]]
    ];
    _color = [_r, _g, _b, _a] call BIS_fnc_colorRGBAtoHTML;

    private _isImage = toLower _text select [count _text - 4] in [".paa", ".jpg"];
    if (_isImage) then {
        _composition pushBack parseText format ["<img align='center' size='%2' color='%3' image='%1'/>", _text, _size, _color];
    } else {
        _composition pushBack parseText format ["<t align='center' size='%2' color='%3'>%1</t>", _text, _size, _color];
    };
} forEach _args;

_composition deleteAt 0;

private _notification = [_composition, _skippable, _notifyLifetime];

// add the queue
if (isNil "WMT_Hint_Queue") then {
    WMT_Hint_Queue = [];
};

WMT_Hint_Queue pushBack _notification;

private _fnc_popQueue = {
    params ["_controls", "_fnc_processQueue"];

    WMT_Hint_Queue deleteAt 0;
    private _notification = WMT_Hint_Queue select 0;

    if (!isNil "_notification") then {
        _notification call _fnc_processQueue;
    } else {
        // fade out
        {
            _x ctrlSetFade 1;
            _x ctrlCommit (FADE_OUT_TIME);
        } forEach _controls;
    };
};

private _fnc_processQueue = {
    params ["_composition", "_skippable", "_notifyLifetime"];

    "WMT_Hint" cutRsc ["RscTitleDisplayEmpty", "PLAIN", 0, true];
    private _display = uiNamespace getVariable "RscTitleDisplayEmpty";

    private _vignette = _display displayCtrl 1202;
    _vignette ctrlShow false;

    private _background = _display ctrlCreate ["RscText", -1];
    _background ctrlSetBackgroundColor [0,0,0,0.25];

    private _text = _display ctrlCreate ["RscStructuredText", -1];
    _text ctrlSetStructuredText composeText _composition;

    private _controls = [_background, _text];

    private _left = profileNamespace getVariable ["IGUI_WMT_Hint_x", (safeZoneX + safeZoneW - GUI_GRID_W)];
    private _top = profileNamespace getVariable ["IGUI_WMT_Hint_y", (safeZoneY + 6 * GUI_GRID_H)];
    private _width = profileNamespace getVariable ["IGUI_WMT_Hint_w", (3 * GUI_GRID_W)];
    private _height = profileNamespace getVariable ["IGUI_WMT_Hint_h", (3 * GUI_GRID_H)];

    _width = ctrlTextWidth _text max _width;

    // need to set this before reading the text height, to get the correct amount of auto line breaks
    _text ctrlSetPosition [0, 0, _width, _height];
    _text ctrlCommit 0;

    private _textHeight = ctrlTextHeight _text;
    _height = _textHeight max _height;

    // ensure the box not going off screen
    private _right = _left + _width;
    private _bottom = _top + _height;

    private _leftEdge = safeZoneX;
    private _rightEdge = safeZoneW + safeZoneX;
    private _topEdge = safeZoneY;
    private _bottomEdge = safeZoneH + safeZoneY;

    if (_right > _rightEdge) then {
        _left = _left - (_right - _rightEdge);
    };

    if (_left < _leftEdge) then {
        _left = _left + (_leftEdge - _left);
    };

    if (_bottom > _bottomEdge) then {
        _top = _top - (_bottom - _bottomEdge);
    };

    if (_top < _topEdge) then {
        _top = _top + (_topEdge - _top);
    };

    _background ctrlSetPosition [_left, _top, _width, _height];

    if (_textHeight < _height) then {
        _top = _top + (_height - _textHeight) / 2;
    };

    _text ctrlSetPosition [_left, _top, _width, _textHeight];

    // fade in
    {
        _x ctrlSetFade 1;
        _x ctrlCommit 0;
        _x ctrlSetFade 0;
        _x ctrlCommit (FADE_IN_TIME);
    } forEach _controls;

    // pop queue - waitUntilAndExecute for skippable, waitAndExecute for non-skippable for less wasted condition checking
    //TRACE_4("Pop wait",_composition,_skippable,_notifyLifetime,WMT_Hint_Queue);
    if (_skippable) then {
        [{
            // Wait for another notification to be added
            count WMT_Hint_Queue > 1
        }, {
            // Condition met - Show next notification immediately
            //LOG("Skipped queue process");
            params ["_fnc_popQueue", "_controls", "_fnc_processQueue"];
            [_controls, _fnc_processQueue] call _fnc_popQueue;
        }, [_fnc_popQueue, _controls, _fnc_processQueue], _notifyLifetime, {
            // Timeout - Normally move to next notification
            //LOG("Normal queue process");
            params ["_fnc_popQueue", "_controls", "_fnc_processQueue"];
            [_controls, _fnc_processQueue] call _fnc_popQueue;
        }] call CBA_fnc_waitUntilAndExecute;
    } else {
        [{
            params ["_fnc_popQueue", "_controls", "_fnc_processQueue"];
            [_controls, _fnc_processQueue] call _fnc_popQueue;
        }, [_fnc_popQueue, _controls, _fnc_processQueue], _notifyLifetime] call CBA_fnc_waitAndExecute;
    };
};

if (count WMT_Hint_Queue isEqualTo 1) then {
    _notification call _fnc_processQueue;
};

nil
