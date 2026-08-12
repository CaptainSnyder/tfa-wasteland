-- Regulator chips for the TFA Generic Wasteland energy weapons.
--
-- Both trade damage against charge draw in opposite directions. Every weapon lists them in the same
-- attachment slot, so a gun can only ever be running one of them.
--
-- This file is never autorun - TFA's loader finds it with file.Find("tfa/attbatch/*", "LUA") and
-- includes it itself, which is why the guard below is mandatory. Without it a manual include would
-- recurse: the file calls TFAUpdateAttachments, which re-includes the file, which calls it again.

if not TFA_ATTACHMENT_ISUPDATING then TFAUpdateAttachments(false) return end

local colors = TFA.Attachments.Colors

TFA.Attachments.RegisterFromTable("wl_recyclingchip", {
	Name = "Recycling Chip",
	ShortName = "RECYC",
	TFADataVersion = TFA.LatestDataVersion,
	Description = {
		colors["+"], "One less charge per shot",
		colors["-"], "30% less damage"
	},

	WeaponTable = {
		Primary = {
			Damage = function(wep, stat) return stat * 0.7 end,
			-- a flat -1, never below 1 - a shot always costs something
			AmmoConsumption = function(wep, stat) return math.max(1, stat - 1) end
		}
	}
})

TFA.Attachments.RegisterFromTable("wl_overchargechip", {
	Name = "Overcharge Chip",
	ShortName = "OVCHG",
	TFADataVersion = TFA.LatestDataVersion,
	Description = {
		colors["+"], "50% more damage",
		colors["-"], "One more charge per shot"
	},

	WeaponTable = {
		Primary = {
			Damage = function(wep, stat) return stat * 1.5 end,
			AmmoConsumption = function(wep, stat) return stat + 1 end
		}
	}
})
