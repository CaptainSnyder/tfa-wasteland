-- Converted from the Terminator SWEP pack onto the TFA base.
-- Damage, fire rate, magazine and ammo type are carried over from the original; everything else is
-- TFA handling the original base never had - ironsights, spread growth, recoil, range falloff.
SWEP.Base = "tfa_gun_base"
SWEP.Category = "TFA Generic Wasteland"
-- groups with the Insurgency weapons, which are sorted by governing skill rather than
-- by weapon type - one armoury, split the way the character sheet is
SWEP.SubCategory = "Energy Weapons"

SWEP.PrintName = "40 Watt Standard"
SWEP.Author = "Annoying Rooster"
SWEP.Purpose = "The workhorse plasma rifle of the machine lines."
SWEP.Instructions = "Left click to fire, right click to aim."
SWEP.Manufacturer = "Skynet"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawCrosshair = true
SWEP.DrawCrosshairIS = false
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.Weight = 30

--[[WEAPON HANDLING]]--
SWEP.Primary.Sound = Sound("weapons/40watt/plasma.wav")
SWEP.Primary.Damage = 23
SWEP.Primary.DamageTypeHandled = true
-- plasma rather than bullet, matching how the originals dealt damage
SWEP.Primary.DamageType = DMG_PLASMA
SWEP.Primary.NumShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 400
SWEP.Primary.RPM_Semi = 400
SWEP.FiresUnderwater = true

--[[BEAM]]--
-- The original drew this beam itself with util.ParticleTracerEx in its own PrimaryAttack. TFA has
-- the same thing built in: TracerPCF switches the engine tracer off and routes SWEP:PCFTracer
-- through TFA.ParticleTracer instead, which already handles viewmodel vs worldmodel muzzles and
-- scoped views - all of which the hand-rolled version got wrong from third person.
SWEP.TracerName = "Weapon_Lasermgun_Beam"
SWEP.TracerPCF = true

SWEP.CanBeSilenced = false
SWEP.SelectiveFire = false

--[[AMMO]]--
SWEP.Primary.ClipSize = 100
-- spawns empty on purpose: a charge has to be found and loaded before the gun is worth anything
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "wl_energycharge"
-- 40 watts, so 2 charges a shot
SWEP.Primary.AmmoConsumption = 2
SWEP.DisableChambering = true

--[[RECOIL]]--
SWEP.Primary.KickUp = 0.4
SWEP.Primary.KickDown = 0.4
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.StaticRecoilFactor = 0.4

--[[ACCURACY]]--
SWEP.Primary.Spread = 0.028
SWEP.Primary.IronAccuracy = 0.028 * 0.35
SWEP.Primary.SpreadMultiplierMax = 3
SWEP.Primary.SpreadIncrement = 0.4
SWEP.Primary.SpreadRecovery = 3
SWEP.Primary.Range = 400 * 48
SWEP.Primary.RangeFalloff = 0.6
SWEP.IronRecoilMultiplier = 0.6
SWEP.CrouchAccuracyMultiplier = 0.6

--[[MOVEMENT]]--
SWEP.MoveSpeed = 0.9
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.8

--[[MODELS]]--
SWEP.ViewModel = "models/weapons/v_40wattm95.mdl"
SWEP.WorldModel = "models/weapons/w_40wattm95.mdl"
SWEP.ViewModelFOV = 65
-- this viewmodel was built left-handed, so it gets mirrored back to the right hand
SWEP.ViewModelFlip = true
SWEP.UseHands = false
SWEP.HoldType = "smg"

-- left unset on purpose: these viewmodels have no ironsight sequence, so TFA centres the model
-- instead, which reads better than an invented offset
SWEP.IronSightsPos = nil
SWEP.IronSightsAng = nil

--[[ATTACHMENTS]]--
-- one slot, so the two chips exclude each other by construction - you cannot run the gun rich and
-- lean at the same time
SWEP.Attachments = {
	[1] = {
		atts = { "wl_recyclingchip", "wl_overchargechip" }
	}
}
