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
		colors["+"], "Halves charge draw per shot",
		colors["-"], "30% less damage",
		colors["="], "More total damage per charge"
	},

	WeaponTable = {
		Primary = {
			Damage = function(wep, stat) return stat * 0.7 end,
			-- rounded up rather than down, and never below 1 - a shot always costs something.
			-- 30% is the damage cut rather than 40% because rounding up is what decides whether an
			-- odd draw (3) actually pays off: at 0.6 damage a 3-charge gun came out worse off than
			-- it started, which defeats the point of fitting the chip
			AmmoConsumption = function(wep, stat) return math.max(1, math.ceil(stat * 0.5)) end
		}
	}
})

TFA.Attachments.RegisterFromTable("wl_overchargechip", {
	Name = "Overcharge Chip",
	ShortName = "OVCHG",
	TFADataVersion = TFA.LatestDataVersion,
	Description = {
		colors["+"], "50% more damage",
		colors["-"], "Doubles charge draw per shot",
		colors["="], "Less total damage per charge"
	},

	WeaponTable = {
		Primary = {
			Damage = function(wep, stat) return stat * 1.5 end,
			AmmoConsumption = function(wep, stat) return stat * 2 end
		}
	}
})
