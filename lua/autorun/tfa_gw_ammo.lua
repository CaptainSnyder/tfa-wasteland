-- Ammo type for the TFA Generic Wasteland energy weapons.
--
-- Registered here rather than through TFA.AddAmmo so this does not depend on the TFA addon having
-- loaded first - game.AddAmmoType is base GMod and is always there. It lives in the addon rather
-- than in the schema because the weapons are what need it; a schema item that hands out an ammo
-- type nothing can fire would just silently do nothing.
--
-- The schema's "Energy Charge" item (items/ammo/sh_ammo_rare_energycharge.lua) feeds this type.

game.AddAmmoType({
	name = "wl_energycharge",
	dmgtype = DMG_PLASMA,
	-- the weapons draw their own beam through SWEP.TracerName, so the engine tracer stays off
	tracer = TRACER_NONE,
	minsplash = 5,
	maxsplash = 5
})

if (CLIENT) then
	-- GMod looks up "<ammotype>_ammo" for the name shown on the HUD ammo counter
	language.Add("wl_energycharge_ammo", "Energy Charge")
end
