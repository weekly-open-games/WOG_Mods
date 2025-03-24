/*
    Name: WMT_fnc_CreateTrigger

    Author(s):
        Zealot

    Description:
        Create trigger

    Parameters:
        TBD

    Returns:
        Trigger
*/

params [["_tb", false], ["_timeout", 3], ["_by", "ANY"], ["_type", "PRESENT"], ["_condition", "this"], ["_activation", ""], 
        ["_deactivation", ""], ["_text", ""], ["_pos", [0,0]], ["_isrectangle", true], ["_dir", 0], ["_size", [50,50]], ["_vehicle", objNull]];

/* Side': "EAST", "WEST", "GUER", "CIV", "LOGIC", "ANY"
* Radio: "ALPHA", "BRAVO", "CHARLIE", "DELTA", "ECHO", "FOXTROT", "GOLF", "HOTEL", "INDIA", "JULIET"
* Object: "STATIC", "VEHICLE", "GROUP", "LEADER", "MEMBER"
* Status: "WEST SEIZED", "EAST SEIZED" or "GUER SEIZED" */
/* Presence: "PRESENT", "NOT PRESENT"
Detection: "WEST D", "EAST D", "GUER D" or "CIV D" */


_trg = createTrigger["EmptyDetector",_pos];

_trg setTriggerArea [_size select 0, _size select 1, _dir, _isrectangle];
_trg setTriggerActivation [_by, _type, _tb];
_trg setTriggerTimeout [_timeout, _timeout, _timeout, true ];
_trg setTriggerText _text;

if (_condition != "" ) then {
    _trg setTriggerStatements [_condition, _activation, _deactivation];
};
if (not isNull(_vehicle) ) then {
    _trg triggerAttachVehicle [_vehicle];
};
_trg;
