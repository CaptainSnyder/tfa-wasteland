-- Plasma Converter - turns a conventional rifle into an energy weapon.
--
-- Three things change: the round it chambers, the beam it throws, and what happens when you try to
-- reload it. The first two are pure stat overrides and live here. The third needs actual behaviour,
-- so it sits in lua/autorun/tfa_gw_plasmavent.lua, which watches for this attachment by ID.
--
-- Currently fitted to the M16A4 only. Adding it to another weapon is one entry in that weapon's
-- SWEP.Attachments - nothing here or in the vent code is weapon-specific.
--
-- See wl_chips.lua for why the guard below is mandatory.

if not TFA_ATTACHMENT_ISUPDATING then TFAUpdateAttachments(false) return end

local colors = TFA.Attachments.Colors

TFA.Attachments.RegisterFromTable("wl_plasmaconverter", {
	Name = "Plasma Converter",
	ShortName = "PLSMA",
	TFADataVersion = TFA.LatestDataVersion,
	Description = {
		colors["="], "Fires a blue plasma beam",
		colors["="], "Runs on Energy Charges",
		colors["-"], "Vents heat instead of reloading"
	},

	WeaponTable = {
		Primary = {
			Ammo = "wl_energycharge",
			DamageType = DMG_PLASMA,
			-- stops TFA autodetecting a damage type from the ammo name, which it cannot do for a
			-- custom type it has never seen
			DamageTypeHandled = true
		},

		-- The blue bolt from the Terminator NPC weapons. Unlike the beams on the energy pack this
		-- is a lua effect rather than a particle system, so TracerPCF stays off - TFA then passes
		-- the name straight through to FireBullets as a tracer effect.
		TracerName = "effect_t_laser_blue",
		TracerPCF = false,
		-- TracerCount is a 1-in-X chance and defaults to 3. A plasma rifle that only shows its bolt
		-- on every third shot looks broken, so every shot gets one.
		TracerCount = 1
	}
})
