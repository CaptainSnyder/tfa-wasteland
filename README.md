# TFA Generic Wasteland

Eight energy weapons on the [TFA base](https://steamcommunity.com/workshop/filedetails/?id=2840031720),
converted from the Terminator SWEP pack for the Wasteland Helix schema.

## Requirements

This addon ships **code only**. It will error on spawn without both of these mounted:

- **TFA Base** — every weapon sets `SWEP.Base = "tfa_gun_base"`.
- **Terminator SWEPs** — all viewmodels, worldmodels, firing sounds and the `.pcf` beam particles
  are loaded from that addon's content by path. Nothing is duplicated here.

Its own SWEPs will keep appearing in the spawn menu alongside these unless you remove that addon's
`lua/weapons/` folder.

## Weapons

| Class | Name | Damage | RPM | Watts | Charges/shot |
|---|---|---|---|---|---|
| `tfa_gw_20watt` | 20 Watt Standard | 5 | 500 | 20 | 1 |
| `tfa_gw_40watt` | 40 Watt Standard | 23 | 400 | 40 | 2 |
| `tfa_gw_ar1` | AR-Standard Issued Prime | 23 | 400 | 40* | 2 |
| `tfa_gw_73watt` | Phase X Watt 73 | 14 | 353 | 73 | 3 |
| `tfa_gw_75watt` | 75 Watt | 14 | 300 | 75 | 3 |
| `tfa_gw_stentnine` | Stent Nine | 17 | 300 | 60* | 3 |
| `tfa_gw_ar3` | AR3 Standard Power-9X | 18 | 600 | 60* | 3 |
| `tfa_gw_80watt` | 80 Watt Power-15Z | 18 | 200 | 80 | 4 |

\* No wattage in the name; implied from damage relative to the guns that have one.

Every weapon holds a 100-charge magazine and **spawns empty**. Charge draw per shot is
`floor(watts / 20)`, so a full magazine is anywhere from 100 shots down to 25.

## Ammo

All eight share one ammo type, `wl_energycharge`, registered in
[`lua/autorun/tfa_gw_ammo.lua`](lua/autorun/tfa_gw_ammo.lua) with `game.AddAmmoType` rather than
through `TFA.AddAmmo`, so it does not depend on TFA having loaded first.

The Wasteland schema feeds it with an "Energy Charge" item (100 charges, one full magazine). Any
other gamemode just needs to hand out `wl_energycharge`.

## Attachments

Two chips in [`lua/tfa/attbatch/wl_chips.lua`](lua/tfa/attbatch/wl_chips.lua), trading damage
against charge draw in opposite directions:

| ID | Name | Damage | Charge draw |
|---|---|---|---|
| `wl_recyclingchip` | Recycling Chip | −30% | halved, rounded up, floor of 1 |
| `wl_overchargechip` | Overcharge Chip | +50% | doubled |

Both occupy the same attachment slot on each weapon, so a gun can only run one at a time. The 20
Watt lists only the Overcharge Chip — it already draws the minimum 1 charge a shot, so the
Recycling Chip could take its damage and give nothing back.

Neither has an icon yet, so the attachment menu falls back to the `RECYC` / `OVCHG` short labels.

## Beams

The originals drew their beams by hand with `util.ParticleTracerEx` in their own `PrimaryAttack`.
TFA has the same thing built in, so each weapon just declares `SWEP.TracerName` plus
`SWEP.TracerPCF = true` and lets `SWEP:PCFTracer` handle it — which also fixes the viewmodel vs
worldmodel muzzle position the hand-rolled version got wrong from third person.

Three particle systems are used: `Weapon_Lasermgun_Beam`, `Weapon_Strawberry_Rail` and
`Weapon_LaserSMG_Rail`. They are precached once in
[`lua/autorun/tfa_gw_particles.lua`](lua/autorun/tfa_gw_particles.lua) rather than per weapon, since
several weapons share a `.pcf`.

## Notes

Nothing in the TFA addon is modified. Attachments are registered through TFA's public batch API and
the ammo type through base GMod, so this drops in and out cleanly.

## Plasma Converter

`wl_plasmaconverter` converts a conventional rifle into an energy weapon. Fitted to the Insurgency
M16A4 only so far, in its ammunition slot so it cannot coexist with a conventional ammo type.

| Change | How |
|---|---|
| Fires a blue plasma bolt | `TracerName = "effect_t_laser_blue"`, the Terminator NPC weapons' tracer — a lua effect, so `TracerPCF` stays off |
| Runs on Energy Charges | `Primary.Ammo` override; `GetPrimaryAmmoType()` reads it through `GetStatL`, so an attachment can change it |
| Vents heat instead of reloading | [`lua/autorun/tfa_gw_plasmavent.lua`](lua/autorun/tfa_gw_plasmavent.lua) |

Reload drops the gun out of view on `ACT_VM_HOLSTER`, hisses for two seconds, then comes back up on
`ACT_VM_DRAW` with the magazine topped off. It hangs off `TFA_PreReload`, TFA's own cancel hook, so
no TFA file is touched and no new animations are needed.

Adding it to another weapon is one entry in that weapon's `SWEP.Attachments` — nothing in the
attachment or the vent code is weapon-specific.
