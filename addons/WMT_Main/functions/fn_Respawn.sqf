/*
	Name: WMT_fnc_Respawn

	Author(s):
		ilbinek

	Description:
		Respawn a unit

	Parameters:
		UID of the unit to respawn

	Returns:
		Nothing
*/

params ["_uid"];

// Check that the UID is really local player, otherwise exit
if (_uid != getPlayerUID player) exitWith {};

// Check if the player is dead, otherwise exit
if (alive player) exitWith {};

// Create a unit
private _group = createGroup playerSide;
private _unit = _group createUnit [typeOf player, position player, [], 0, "NONE"];
_unit setUnitLoadout (getUnitLoadout player);
if (!isNil "WMT_Local_Group") then {
	[_unit] joinSilent WMT_Local_Group;
};

// Not working in arma 3? Maybe they will fix it one day and the unit will be visible in the slot selection screen?
// If they fix it, we might create a "spectator" slot that will create always at least one spectator that will be able to spectate the game
// So people that disconnected can still spectate (but that won't happen)
//setPlayable _unit;

// Delete old body and move player into the unit
hideBody player;
selectPlayer _unit;

// Set HIA3 target as the new unit
HIA3_Spectator_ViewUnit = _unit;

// Make HIA "move" the camera in 1st person of the unit
player cameraEffect ["terminate","back"];
camDestroy HIA3_Spectator_Camera;
[player] call HIA3_spectator_fnc_changeTargetUnit;
HIA3_Spectator_ViewUnit switchCamera "INTERNAL";

// Turn off HIA3 spectator
("HIA3_SPECTATOR" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
