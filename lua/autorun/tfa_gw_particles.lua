-- Beam particles for the TFA Generic Wasteland weapons.
--
-- The originals each called game.AddParticles in their own shared.lua. TFA draws its tracer through
-- SWEP.TracerName/TracerPCF instead of a hand-rolled PrimaryAttack, so the weapons no longer have a
-- natural place to load these - and a weapon file is the wrong place anyway, since several of them
-- share a .pcf. Loading once here means the systems are ready before any of them is picked up.
--
-- The .pcf files themselves live in addons/terminator_sweps/particles/, which this pack already
-- depends on for its models and sounds. Filenames are the lowercase names as they sit on disk; the
-- originals wrote "laserSMG_particles.pcf", which only resolves on a case-insensitive filesystem.

local PARTICLE_FILES = {
	"particles/lasermgun_particles.pcf",
	"particles/beam_particles_strawberry2.pcf",
	"particles/lasersmg_particles.pcf"
}

-- every system we actually reference, so none of them pop in late on first fire
local PARTICLE_SYSTEMS = {
	"Weapon_Lasermgun_Beam",
	"Weapon_Strawberry_Rail",
	"Weapon_LaserSMG_Rail"
}

for _, file in ipairs(PARTICLE_FILES) do
	game.AddParticles(file)

	if (SERVER) then
		resource.AddFile(file)
	end
end

for _, system in ipairs(PARTICLE_SYSTEMS) do
	PrecacheParticleSystem(system)
end
