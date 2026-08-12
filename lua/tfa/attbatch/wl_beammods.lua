-- Beam splitters for weapons running a Plasma Converter.
--
-- Both divide the emitter's output across more beams. Each beam is much weaker than the single one
-- it replaced, so a miss costs more than it used to - the trade only pays when most of the beams
-- land on the same target. Spread does the rest of the balancing for us: TFA fires NumShots down
-- the weapon's existing cone, so the beams separate with distance and these become close-range
-- tools without needing a range penalty bolted on.
--
-- Neither of these touches AmmoConsumption. The Plasma Converter owns that calculation and checks
-- for these attachments itself - see the comment in wl_plasmaconverter.lua for why.
--
-- See wl_chips.lua for why the guard below is mandatory.

if not TFA_ATTACHMENT_ISUPDATING then TFAUpdateAttachments(false) return end

local colors = TFA.Attachments.Colors

TFA.Attachments.RegisterFromTable("wl_beamsplitter", {
	Name = "Beam Splitter",
	ShortName = "SPLIT",
	TFADataVersion = TFA.LatestDataVersion,
	Description = {
		colors["+"], "Fires 3 beams instead of 1",
		colors["-"], "Each beam much weaker",
		colors["-"], "2 extra charges a shot",
		colors["="], "Rewards landing every beam"
	},

	WeaponTable = {
		Primary = {
			NumShots = function(wep, stat) return 3 end,
			-- 0.37 each, so all three landing is about 1.1x the undivided beam. Fewer than three and
			-- you are worse off than you were without it.
			Damage = function(wep, stat) return stat * 0.37 end
		}
	}
})

TFA.Attachments.RegisterFromTable("wl_beamscatter", {
	Name = "Beam Scatter",
	ShortName = "SCATR",
	TFADataVersion = TFA.LatestDataVersion,
	Description = {
		colors["+"], "Fires 5 beams instead of 1",
		colors["-"], "Each beam far weaker",
		colors["-"], "3 extra charges a shot",
		colors["="], "Point blank or nothing"
	},

	WeaponTable = {
		Primary = {
			NumShots = function(wep, stat) return 5 end,
			-- 0.23 each: all five is about 1.15x, but three of five is well under half. The wider
			-- the split, the more punishing a partial hit becomes.
			Damage = function(wep, stat) return stat * 0.23 end
		}
	}
})
