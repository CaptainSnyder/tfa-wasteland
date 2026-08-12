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

		-- The same continuous beam the 20 and 40 Watt fire, which is the blue one: their NPC
		-- counterparts use effect_t_laser_blue for the identical weapon. effect_t_laser_blue itself
		-- was the wrong pick - it is a travelling bolt, not a beam.
		--
		-- lasermgun_particles.pcf is loaded and precached by lua/autorun/tfa_gw_particles.lua.
		TracerName = "Weapon_Lasermgun_Beam",
		TracerPCF = true,

		-- Combine hardware bolted on, so a converted rifle reads as field-modified rather than
		-- factory. These only toggle elements the weapon already declares - an attachment cannot
		-- introduce new ones, since TFA builds the element models from the weapon's own table.
		ViewModelElements = {
			["plasma_emitter"] = {["active"] = true},
			["plasma_core"] = {["active"] = true},
			["plasma_monitor"] = {["active"] = true}
		},
		WorldModelElements = {
			["plasma_emitter"] = {["active"] = true},
			["plasma_core"] = {["active"] = true}
		}
	}
})
