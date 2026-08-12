-- Heat venting for weapons fitted with the Plasma Converter.
--
-- A converted rifle has no magazine to swap, so pressing reload drops the gun out of view, hisses
-- for a couple of seconds and comes back up topped off. Cheap, but it reads correctly in first
-- person and needs no new animations - ACT_VM_HOLSTER and ACT_VM_DRAW exist on every viewmodel.
--
-- TFA_PreReload is TFA's own cancel hook (tfa_gun_base/shared.lua, in SWEP:Reload) and returning
-- true from it stops the normal reload dead. Nothing in the TFA addon is modified.

local CONVERTER  = "wl_plasmaconverter"
local VENT_TIME  = 2
-- a looping steam hiss from Half-Life 2, stopped explicitly when the vent finishes so it runs for
-- exactly VENT_TIME rather than forever. Swap this one line to change the sound.
local VENT_SOUND = "ambient/gas/steam_loop1.wav"

local function FinishVent(wep)
	if (not IsValid(wep)) then return end

	wep.wlVentEnd = nil
	wep:StopSound(VENT_SOUND)

	local owner = wep:GetOwner()

	-- the player may have died, dropped it or switched away mid-vent
	if (not IsValid(owner)) then return end

	local ammoType = wep:GetPrimaryAmmoType()
	local missing = wep:GetStatL("Primary.ClipSize") - wep:Clip1()
	local available = owner:GetAmmoCount(ammoType)
	local taken = math.min(missing, available)

	if (taken > 0) then
		owner:RemoveAmmo(taken, ammoType)
		wep:SetClip1(wep:Clip1() + taken)
	end

	if (wep == owner:GetActiveWeapon()) then
		wep:SendWeaponAnim(ACT_VM_DRAW)
	end
end

hook.Add("TFA_PreReload", "TFA_GW_PlasmaVent", function(wep, released)
	if (not IsValid(wep)) then return end
	if (not wep.IsAttached or not wep:IsAttached(CONVERTER)) then return end

	-- the server owns the whole sequence; letting the client run it too would double the sound
	if (CLIENT) then return true end

	-- SWEP:Reload fires repeatedly while the key is held, so a vent already running wins
	if ((wep.wlVentEnd or 0) > CurTime()) then return true end

	local owner = wep:GetOwner()
	if (not IsValid(owner)) then return true end

	-- nothing to vent for: already full, or no charges to draw on
	if (wep:Clip1() >= wep:GetStatL("Primary.ClipSize")) then return true end
	if (owner:GetAmmoCount(wep:GetPrimaryAmmoType()) <= 0) then return true end

	wep.wlVentEnd = CurTime() + VENT_TIME

	wep:SendWeaponAnim(ACT_VM_HOLSTER)
	wep:EmitSound(VENT_SOUND)

	-- blocking the triggers rather than forcing a weapon status: the status enum drives TFA's own
	-- reload and holster bookkeeping, and borrowing one of those states to mean "cooling" invites
	-- the base to finish a reload we never started
	wep:SetNextPrimaryFire(wep.wlVentEnd)
	wep:SetNextSecondaryFire(wep.wlVentEnd)

	timer.Simple(VENT_TIME, function()
		FinishVent(wep)
	end)

	return true
end)
