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
			DamageTypeHandled = true,

			-- the 40 Watt's report, the most-used sound across the energy pack. A converted rifle
			-- has no cartridge to go off, so the host weapon's gunshot has to go with it.
			Sound = "weapons/40watt/plasma.wav",

			-- a cell holds far more than a magazine of brass. Matches the energy pack, where every
			-- weapon carries 100 charges.
			ClipSize = 100,

			-- the 20 Watt is the baseline energy weapon, and a converted rifle is held to its
			-- output rather than the host's. Whatever the gun hit for as a firearm is irrelevant
			-- once it is throwing plasma.
			Damage = 5,

			-- Three charges a shot against the 20 Watt's one - a bolted-on converter is a field
			-- expedient, not a purpose-built emitter, and it pays for that in efficiency.
			--
			-- This one function owns the whole cost, including the beam splitters' surcharges,
			-- rather than letting them each add their own. TFA chains stat functions in pairs()
			-- order, so "+2 charges" and "clamp to what is left" could apply in either order, and
			-- clamping first then adding would defeat the clamp.
			--
			-- The clamp is the forgiving bit: a shot never costs more than the cell has left, so a
			-- gun with anything at all in it fires at full power. Third return value disables stat
			-- caching, since this depends on Clip1() and would otherwise go stale immediately.
			AmmoConsumption = function(wep, stat)
				local cost = 3

				if (wep.IsAttached) then
					if (wep:IsAttached("wl_beamsplitter")) then cost = cost + 2 end
					if (wep:IsAttached("wl_beamscatter")) then cost = cost + 3 end
					if (wep:IsAttached("wl_overchargechip")) then cost = cost + 1 end
					if (wep:IsAttached("wl_recyclingchip")) then cost = cost - 1 end
				end

				-- second return true ends the chain. The chips carry their own AmmoConsumption for
				-- use on the energy weapons, where there is no converter to do this; ending here
				-- stops those applying a second time on top of the figures counted above.
				return math.min(math.max(1, cost), math.max(1, wep:Clip1())), true, true
			end,

			-- A plasma emitter has no recoiling mass and no gas system. What is left is the
			-- shooter flinching, so a little rather than none.
			KickUp = function(wep, stat) return stat * 0.15 end,
			KickDown = function(wep, stat) return stat * 0.15 end,
			KickHorizontal = function(wep, stat) return stat * 0.15 end,
			StaticRecoilFactor = function(wep, stat) return stat * 0.2 end
		},

		-- TFA otherwise looks for low-ammo and last-shot variants of the firing sound, which exist
		-- for the weapon's own soundscript but not for a raw .wav taken from another pack
		FireSoundAffectedByClipSize = false,

		-- no brass. There is no cartridge to eject once the gun runs on charge, and an empty string
		-- is TFA's own documented way to suppress shells (tfa_gun_base/common/effects.lua, in
		-- SWEP:MakeShell: "allows to disable shells by setting override to ''")
		ShellEffectOverride = "",

		-- The same continuous beam the 20 and 40 Watt fire, which is the blue one: their NPC
		-- counterparts use effect_t_laser_blue for the identical weapon. effect_t_laser_blue itself
		-- was the wrong pick - it is a travelling bolt, not a beam.
		--
		-- lasermgun_particles.pcf is loaded and precached by lua/autorun/tfa_gw_particles.lua.
		TracerName = "Weapon_Lasermgun_Beam",
		TracerPCF = true,

		-- A cell sat in the magazine well, so the rifle reads as feeding on charge rather than
		-- brass. This only toggles an element the weapon already declares - an attachment cannot
		-- introduce new ones, since TFA builds the element models from the weapon's own table.
		ViewModelElements = {
			["plasma_cell"] = {["active"] = true},
			["plasma_cell2"] = {["active"] = true}
		},
		WorldModelElements = {
			["plasma_cell"] = {["active"] = true},
			["plasma_cell2"] = {["active"] = true}
		},

		-- Collapse the real magazine rather than hiding it behind the cell. There is no magazine
		-- bodygroup on this viewmodel, but there is a Magazine bone, and ViewModelBoneMods resolves
		-- through GetStatL - so an attachment can shrink it to nothing. Scaling to a hair above
		-- zero instead of exactly zero, since a zeroed bone matrix is not always well behaved.
		--
		-- The cell is parented to this same bone. If the scale turns out to propagate to attached
		-- elements the cell will disappear with the magazine, and the fix is to re-parent it to
		-- Magazine_Release, which sits on the receiver.
		ViewModelBoneMods = {
			["Magazine"] = {scale = Vector(0.001, 0.001, 0.001), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
		},
		WorldModelBoneMods = {
			["W_MAGAZINE"] = {scale = Vector(0.001, 0.001, 0.001), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
		}
	}
})
