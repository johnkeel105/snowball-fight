# Snowball Fight 1.3 audit

Static audit of the Snowball Fight 1.3 package (`zzzdossnowballfight1.3.pk3`, opened into
`source/` in this repository), carried out 2026-11-26. The audit covered script logic,
asset-reference integrity, and maps/packaging. Findings were spot-verified against the
source files; items marked "needs in-game confirm" could not be fully settled statically.

Paths below are relative to `source/` unless stated otherwise.

## Gameplay-affecting

### Working Kar98 sniper pickup in Stalingrad Snow II

`maps/dm/stalingrad_snow2.bsp` contains a `playerweapon_german_kar98-sniper` pickup entity
(using `weapons/kar98sniper.tik`, also cached by `maps/dm/stalingrad_snow2_precache.scr:3`).
Weapons are only stripped at join/respawn (`global/snowcontest.scr:79` `parm.player takeall`,
run from the join stage thread), so a player who walks over the Kar98 keeps a functioning
rifle until death. No other 1.3 map BSP has a weapon pickup. Needs in-game confirm that the
entity spawns as a pickup.

### MG42 turrets re-armed as snowball guns

`models/statweapons/mg42_gun.tik` renames the gun "MG42 (Frozen)" and its QUAKED note says
disabled, but the server init sets the projectile to the snowball primary
(`models/projectiles/M2FGrenade_primary.tik`) with `firedelay 0.06` and `usenoammo 1`, and
the `setplayerusable` line that would disable use is commented out
(`mg42_gun.tik:56`). BSPs contain `turretweapon_german_mg42` entities:
`stalingrad_snow2.bsp` (3, plus 1 bipod), `stalingradsnow.bsp` (6, plus 2 bipods),
`user_98snowsniperfury.bsp` (6). If the turrets are usable, they are rapid-fire snowball
guns. Needs in-game confirm.

### Three maps have no free-for-all spawns

`backyard.bsp`, `belowzero1.bsp`, and `user_98snowsniperfury.bsp` contain zero
`info_player_deathmatch` entities and only one `info_player_start` each (team spawns:
4/4, 10/10, 20/24). Team modes are covered; free-for-all spawning is at risk on these
three. Backyard also has only 4 spawns per team.

## Map script bugs

### Snow Sniper Fury main thread stalls

`maps/dm/user_98snowsniperfury.scr:14` waits for `spawn`, then line 23 waits for
`prespawn`, which has already fired. The main thread stalls there: DMprecache,
`door_locked`, ambient, and the farplane/fog setup (lines 25-34) never run, and
`roundbasedthread` (threaded at line 22, waits for prespawn at line 38) never applies
round-based settings. Snowballs still work because snowcontest is exec'd at line 18,
before the stall.

### Destroyed Village Snow anti-cheat kill brush never spawns

In `maps/dm/dv_snow.scr`, the `snow:` thread ends at line 55, and the `trigger_hurt`
kill-brush block at lines 58-61 ("kill brush under the cheat point") sits between two
`end`s with no label. It is unreachable code; the cheat-point protection does nothing.

### Round-based thread called but never defined

`maps/dm/stalingradsnow.scr:15`, `maps/dm/stalingrad_snow2.scr:27` and `:31`, and
`maps/dm/stalingrad_snow2b.scr:26` and `:30` all `thread roundbasedthread`, but none of
those files defines the label. In round-based gametypes this is a script error and the
round settings (respawning, round limit, clockside) stay at defaults. The two snow2
files also thread it twice.

### Round-based thread defined but never called

`maps/dm/raildepotfinal.scr:33` defines `roundbasedthread:` (with
`level.dmrespawning = 1`), but `main:` never threads it, unlike every other DM map.
Round-based settings never apply on this map.

### Dead snow-density branch

`maps/dm/stalingradsnow.scr:27` and `maps/dm/stalingrad_snow2b.scr:49` test
`if(local.string[25] == "2")`, but `local.string` is never assigned in either file, so
the condition is always false and the `else` snow settings always win.

### Fall-through into an entity thread

`maps/dm/stalingradsnow.scr:51-52`: `main:` has no `end` before the `pain:` label (which
the BSP calls via `setthread "pain"`), so `$hurtme volumedamage 5` also fires once at
map load.

### Stage-thread resolve can never run

`global/jv_mp_players.snow:328` gates resolving on `if(local.noresolve == NIL)`, while
its own doc (line 288) says passing `1` prevents resolving; `global/snowcontest.scr:5`
passes `0`, which also blocks it. Effect is small (the exec happens before players
join), but anyone already in-game when snowcontest execs would miss `takeweapons` until
respawn.

### Precache script never exec'd

`maps/dm/stalingrad_snow2_precache.scr` (healthbox, kar98sniper, MG42, vehicles) has no
`exec` reference anywhere; its cache list is dead. (`dmxfire2v2`'s precache is wired
correctly.)

### Two maps skip DM precache and spawn waits

`maps/dm/belowzero1.scr` and `maps/dm/weihnachtsmarkt.scr` exec snowcontest at load with
no `level waittill prespawn/spawn` and no DMprecache, unlike all other maps. This works,
but loses DM precaching (first-use hitches).

### Snow emitters orphaned on disconnect

`global/snowcontest.scr:115-137`: the 25 per-player drip emitters are only removed after
the `while` loop exits (death/terminate). The thread is bound to the player entity, so a
mid-life disconnect kills the thread before cleanup, leaving the emitters behind.

### Miscellaneous script issues

- `maps/dm/backyard.scr:28` execs `global/ambient.scr dm/backyard`, but no
  `music/backyard.mus` or `music/dm/backyard.mus` exists in the package.
- `maps/dm/dv_snow.scr:28` sets `level.script = maps/dm/mohdm2.scr` instead of its own
  script.
- `maps/dm/stalingrad_snow2b.scr` is an unused alternate script with no matching BSP and
  no `level.addsnow = 1`.

## Visual and asset bugs

### Missing textures used by player skins

- `scripts/allied_old_woman.shader:34` maps
  `textures/models/human/allied_old_woman_sleeves.jpg`, used by
  `models/player/allied_z_old_woman_fps.tik:9`. No such file in the package (only
  coat/face/pants JPGs exist).
- `scripts/cavalry.shader:103` maps `textures/britholster.tga`, used by
  `allied_z_magna_cartas_cavalry1.tik:29` and `allied_z_magna_cartas_cavalrysgt.tik:29`.
  No `britholster` file exists.
- `scripts/tony_montana.shader:43` maps `textures/sv_tankcom.tga`, used by
  `allied_z_tony_montana_fps.tik:9`. No such file.

### Extension mismatches (`.tga` referenced, only `.jpg` shipped)

- `scripts/cavalry.shader:94` `textures/cav_face.tga` vs `textures/cav_face.jpg` (its
  own qer line 92 correctly says `.jpg`).
- `scripts/terminator.shader:31` `textures/ttface.tga` vs `textures/ttface.jpg`.
- `scripts/columbian.shader:28` `textures/wow_face.tga` vs `textures/wow_face.jpg`.

All three are used by player skins. A Q3-derived loader may fall back to the other
extension, but as written the references do not match a file.

### Misnamed first-person model file

The package has `models/player/german_z_hermann_goeringr_fps.tik` (extra "r") but the
base skin is `german_z_hermann_goering.tik`; there is no
`german_z_hermann_goering_fps.tik`, so the Goering skin's first-person pairing is
broken. Every other skin pairs correctly.

### Shader syntax error

`scripts/cavalry.shader` has uncommented stray text at top level: line 1
"Short sleeves Cavalry", line 23 "Long Sleeves", line 70 "shared" — tokens not followed
by `{`, which a strict shader parser rejects. All 35 `.shader` files otherwise have
balanced braces.

### Broken Crossfire Courtyard image references

`maps/dm/dmxfire2v2.scr:15` sets `g_scoreboardpic "dmxfire2v2.tga"` and
`ui/loading_dmxfire2v2.urc:119` uses `shader "dmxfire2v2.tga"`. The defined shader is
`dmxfire2v2` (`scripts/dmxfire2v2.shader:1`, mapping
`textures/mohmenu/dmloading/dmxfire2v2.tga`); the bare filename matches neither the
shader name nor a full texture path, unlike every other map's scoreboard/loading
reference.

### Wrong-content loading menu

`ui/loading_user_98snowsniperfury.urc` (970 bytes) is byte-identical to
`maps/dm/user_98snowsniperfury.scr` — it starts with `main:` and contains map script,
not a menu. The real loading menu is `ui/loading_snowsniperfury.urc`.

### Missing cached model

`models/projectiles/m2fgrenade_base.txt:47` caches `models/fx/grenexp_snow.tik`, which
is not in the package and is not a stock name. The actual `explosionmodel`
(`m2fgrenadeexplosion.tik`) is present, so this is likely just a console warning.

### Wrong version announced in-game

`global/snowcontest.scr:2` sets `level.sc_version = "1.1"`, so the periodic on-screen
message (line 29) reads "Snow Contest v1.1" in the 1.3 build.

## Packaging and compatibility

### Stock maps are silently converted

`maps/dm/mohdm1.scr`-`mohdm7.scr` and `maps/obj/obj_team1.scr`-`obj_team4.scr` override
the stock map scripts, set `level.addsnow = 1` / `level.snowmood = 1`, and exec
`global/snowcontest.scr`. The supplied readme lists only the 9 custom maps, but while
the pk3 sits in `main`, stock DM and objective maps also become snowball-only. This may
be intentional (it matches the original Snow Contest design), but it is undocumented in
the 1.3 readme.

### Broad stock-file overrides

Stock-path replacements include `models/weapons/m2frag_grenade_base.txt`,
`models/projectiles/m2fgrenade.tik`, `models/projectiles/m2fgrenade_primary.tik`,
`models/fx/m2fgrenadeexplosion.tik`, `models/statweapons/mg42_gun.tik`,
`models/statweapons/mg42_gun_viewmodel.tik`, `ui/hud_ammo_m2grenade.urc`, 32
`textures/hud/*.tga` files, `textures/mohmenu/selectprimary.tga` and the six
`textures/mohmenu/*_sign.tga` files, plus `sound/items/health_medkit_01.wav`,
`sound/weapons/foley/ammopugrenade1.wav`, `sound/weapons/foley/gundrop1.wav`, and
`sound/weapons/foley/gundrop4.wav`. The `zzz` pk3 name loads late and wins these paths,
so base-game and other-mod behavior changes until the pk3 is removed.

### Dormant broken references

These shader `map` references point at custom textures absent from the package; the
shaders appear unused, so they would only bite if something referenced them:
`scripts/aloha_brit_tank_corp.shader` (aloha/tourist textures),
`scripts/finnish.shader` (hayha/fin variants — the used Finnish shaders `hayha_shirt`
and `fin_neckband` do resolve), `scripts/german_zombie.shader` (zombiescientist
coat/pants/face), `scripts/jason.shader` (`j_hands`/`j_shirt`/`j_pants`; `j_face` is
used and present), `scripts/nurse.shader:55` (`nurse_gear`),
`scripts/medevil_knight.shader:32` (`fireman_helmet`, in unused `med_helmet_c`),
`scripts/terminator.shader:40/44/59` (glasses, in unused `dude_glass*`),
`scripts/snowball.shader:33` (`textures/mohmenu/dmloading/Backyard.tga`; the used
`loading_back`/`rageload.tga` path is fine), and `scripts/santa.shader:11` references
missing `santa_hat.tga` only as `qer_editorimage` (editor-only).

### Minor and cosmetic

- Duplicate shader definitions: `l_gloves` in `scripts/neo.shader:18` and
  `scripts/morpheus.shader:18` (identical); `stalingrad_snow2` twice in
  `scripts/stalingrad_snow2.shader:2` and `:13` (identical). Harmless.
- Case mismatches (MOHAA's VFS is case-insensitive, so likely harmless on Windows; a
  risk on case-sensitive filesystems): `scripts/raildepotfinal.shader:9/20`
  (`RaildepotFinal*.jpg` vs lowercase files); `Aussie_hat.skd` in the three cavalry
  tiks vs `models/aj/aussie_hat.skd`; `M2FGrenade` paths in
  `models/weapons/m2frag_grenade_base.txt`, `mg42_gun.tik`, and `m2fgrenade_base.txt`
  vs lowercase `m2fgrenade` files; `maps/dm/raildepotfinal.scr:19`
  (`RaildepotFinal.scr`); loading menu names `dm/DMxfire2v2` and `dm/RaildepotFinal`;
  `dv_snow.bsp` references `textures/TAardennes/...` vs the `textures/taardennes/`
  folder.
- Junk files in the pk3: three `thumbs.db` files (excluded from this repo's `source/`
  tree), map-compile leftovers `maps/dm/raildepotfinal.prt`,
  `maps/dm/stalingrad_snow2.prt`, `maps/dm/user_98snowsniperfury.vis`, shader text in
  `scripts/stalingrad_snow2.urc` (unbalanced braces, wrong place), unreferenced
  `music/stalingradsnowbackup.mus`, unreferenced `textures/use arm clour here.tga`, and
  unreferenced `models/human/finwinter1/3/4.skd` (only `finwinter2` is used).

## Known issues stated in the supplied 1.3 readme

From `docs/dos-snowballfight-1.3.txt`:

- "Snowball Pickup still lists a Grenade Pickup in upper left update text" — consistent
  with `models/weapons/m2frag_grenade_base.txt:27` still naming the weapon
  "Frag Grenade".
- "Map Compatibility, Sky can become Pink on some maps after loading custom map with
  poor SkyBox Config".

## Checked and clean

- **Syntax:** brace/paren/bracket balance verified programmatically across all `.scr`,
  `.snow`, `.tik`, and `.txt` files — no imbalances.
- **Map coverage:** all 9 BSPs have matching `.scr` files; the readme map list matches
  the 9 BSP stems exactly; each map has a loading-screen menu and a
  `textures/mohmenu/dmloading/` image. `.min` files exist for 5 of 9 maps and `.pth`
  only for `stalingrad_snow2`, but no map lacks its `.scr` companion.
- **Thread references:** every local `thread`/`waitthread` target exists except the
  `roundbasedthread` cases above; stock globals (DMprecache, ambient, exploder, ai,
  bomber, spotlight, door_locked, shutter, obj_dm, minefield) are referenced
  consistently.
- **Core snowball logic:** `takeweapons` (takeall, give grenade weapon,
  useweaponclass), the crouch-to-craft loop (`ammo`/`awardnade`: crouched + stationary
  + fire/use released for ~1.75s gives +1 grenade, `awardingnade` flag reset on every
  exit path), and the breathe/snow threads all contain waits — no busy loops or stuck
  flags found.
- **Player handler** (`jv_mp_players.snow`): stage machine, join-trigger cleanup, and
  double-run guard are sound apart from the resolve finding above.
- **Weapon tiks:** snowball weapon (`dmstartammo 6`, shared clip, primary/secondary
  projectile refs all present with their `.skd`/`.skc`), projectile (`hitdamage 800`,
  explode-on-touch), explosion (`radiusdamage 100`, radius 20), MG42 snowball turret,
  drip emitter, and all 52 player-skin tiks are structurally sound.
- **Objective maps:** bomb/win logic (`teamwin` on `exploded`, axis timers,
  shingle/random-explode loops) follows the stock pattern with waits in every loop.
- **References:** player/projectile `.tik` model and animation references resolve to
  shipped custom SKDs/SKCs or stock paths; shader texture references outside the
  findings above resolve in the package or to stock texture paths; URC stock references
  (`white`, `facfont-20`, `ui/loadingbar.txt`) are fine; sound aliases are stock.
- **Files:** no zero-byte files (smallest is 28 bytes), no truncated TGA/JPG/WAV found
  by header checks, BSP/SKD/SKC magic values are sane, and the pk3 has no duplicate
  entry names (exact or case-insensitive).
- **Config:** no `.cfg` ships and no script forces `sv_maplist` or a gametype; scripts
  only set scoreboard text/picture cvars and read `sc_nosnow` /
  `sc_forbidservernamechange` (the hostname-change thread is commented out).

## Fix priority

1. Script-level, no map recompile needed: Snow Sniper Fury stall, dv_snow kill brush,
   round-based thread wiring (3 maps), version string, cavalry shader stray text,
   extension mismatches, Goering FPS rename, dmxfire2v2 image references,
   loading URC wrong content, missing cached model.
2. Needs in-game confirm first: Kar98 pickup, MG42 turret usability, FFA spawning on
   the three maps without deathmatch spawns.
3. Needs map work or script workarounds: removing the Kar98 entity and adding FFA
   spawns live in the BSPs.
4. Cosmetic: dormant shader references, duplicate definitions, junk files, case
   mismatches.
