# Snowball Fight 1.4-test plan

Test build for the top-priority fixes from `docs/snowball-fight-1.3-audit.md`.
This is a test build, not a final 1.4 release. The in-game version message reads
"Snow Contest v1.4-test" so you can confirm the test pk3 is the one running.

## Install for testing

1. Remove or rename `zzzdossnowballfight1.3.pk3` in your MOHAA `main` folder.
   Do not run the 1.3 and 1.4-test pk3s at the same time.
2. Put `zzzdossnowballfight1.4test.pk3` in `main`.
3. Start a local/listen server (or your normal test server) with the test pk3 on
   both server and client if you test with another machine.
4. Load any Snowball Fight map and wait about 30 seconds. Expected: the on-screen
   message says "Snow Contest v1.4-test". The server console should also print
   "Snowball Fight 1.4-test: top-priority fixes loaded" when snowcontest starts.

Gametype numbers below use MOHAA `g_gametype`: 1 = free-for-all, 2 = team,
3 = round-based, 4 = objective. If your launcher/server config names them
differently, use the matching mode names.

## What to test

### 1. Snow Sniper Fury loads fully

- Map: `dm/user_98snowsniperfury`, any gametype.
- Expected: the map loads with its fog/farplane (view fades at distance instead
  of seeing forever), doors behave as locked where the map expects it, and the
  console shows no script stall/error from `user_98snowsniperfury.scr`.
- Round-based check: start the map in round-based mode. Expected: dead players
  stay out until the next round, the round limit is 5 minutes, and there is no
  `roundbasedthread` script error.

### 2. Round-based wiring on the other fixed maps

Start each map in round-based mode (`g_gametype 3`):

- `dm/stalingradsnow`: expected no `roundbasedthread` error; no respawn during a
  round; 5-minute round limit.
- `dm/stalingrad_snow2`: expected no `roundbasedthread` error (it was threaded
  twice and never defined in 1.3); no respawn during a round; 5-minute round
  limit.
- `dm/raildepotfinal`: expected round-based settings now apply (this map defined
  the thread in 1.3 but never ran it). Note: Rail Depot's script sets
  respawning on (`dmrespawning = 1`), so players may respawn during the round;
  the key check is the 5-minute round limit and no script error.

### 3. Kar98 pickup guard (Stalingrad Snow II)

- Map: `dm/stalingrad_snow2`.
- Go to the Kar98 sniper spot by the health box at the top area (BSP origin
  4583 5 832) and walk over/through the rifle spot.
- Expected: you keep snowballs only. Try switching weapons after walking over
  the spot; no Kar98 rifle should appear in your hands or inventory.
- Report back if: the rifle model is visible and pickup gives you a working
  rifle, or the guard strips snowballs repeatedly while standing near the spot.

### 4. MG42 snowball turret

- Maps with MG42 turrets: `dm/stalingradsnow`, `dm/stalingrad_snow2`,
  `dm/user_98snowsniperfury`.
- Walk up to an MG42 and press Use. Expected: you can mount it.
- Hold fire. Expected: visible snowballs launch, not just hiss and smoke. The
  rate should feel like about 2x the player snowball throw rate (test setting:
  0.375-second delay vs the player's 0.75), roughly 8 snowballs in 3 seconds,
  and the snowballs should reach downrange walls/targets with normal snowball
  impacts.
- Report back if: it still only hisses/smokes, the rate feels much faster or
  slower than 2x throws, the snowballs drop too fast to use at distance, or the
  spread makes it useless or too accurate.

### 5. Free-for-all spawns on maps that only had team spawns

Start each map in free-for-all (`g_gametype 1`), join, then kill yourself or
have another player kill you several times:

- `dm/backyard`
- `dm/belowzero1`
- `dm/user_98snowsniperfury`

Expected: you respawn at varied team-spawn locations around the map instead of
always at the single `info_player_start` spot, and respawning keeps working.
Report back if: FFA still always uses one spot, spawns you inside geometry, or
fails to respawn.

### 6. Destroyed Village Snow cheat-point kill brush

- Map: `dm/dv_snow`.
- Normal check: load the map and confirm there is no script error from
  `dv_snow.scr`.
- Optional cheat check (only if you use cheats/teleport on your test server):
  the kill brush is centered at (-2200 2200 -80) under the cheat point.
  Expected: entering that volume kills the player. This is hard to verify in
  normal play; a clean load with no script error is enough for a first pass.

### 7. Skin and shader fixes

- Cavalry skins: select the Magna Cartas cavalry skins. Expected: faces render
  with the cavalry face texture, and the console shows no cavalry shader parse
  error.
- Terminator skin: expected the face renders (the shader now points at
  `ttface.jpg`).
- Columbian skin: expected the face renders (the shader now points at
  `wow_face.jpg`).
- Hermann Goering skin: select it and check first-person view. Expected: the
  first-person arms/weapon view pairs correctly now that the FPS tik name is
  fixed.

Known remaining texture issue (not part of this test's top-priority fixes):
three skin textures are still missing from the package (old woman sleeves,
`britholster`, `sv_tankcom`). If those exact surfaces still look wrong, that is
the known missing-asset issue, not a 1.4-test regression.

### 8. Loading and scoreboard images

- `dm/dmxfire2v2`: expected the loading screen and scoreboard picture show the
  Crossfire Courtyard image.
- `dm/user_98snowsniperfury`: expected the loading screen shows the Snow Sniper
  Fury loading menu (in 1.3 that URC file contained map script by mistake).

### 9. Snowball basics still work

On any map:

- Spawn in: expected snowballs only, with the "Crouch to create more
  snowballs!" hint.
- Crouch while standing still to craft more snowballs. Expected: snowball count
  increases after about 1.75 seconds.
- Throw snowballs and watch impacts. Expected: normal snowball hits/explosions;
  the console should not warn about missing `models/fx/grenexp_snow.tik`.
- Check the periodic message after ~30 seconds reads "Snow Contest v1.4-test".

### 10. Regression check

- Load a stock map such as `dm/mohdm1` with the test pk3 installed. Expected:
  it still becomes snowball-only (that is the mod's existing behavior while the
  pk3 is in `main`).
- Remove the test pk3 and confirm the game returns to normal / 1.3 behavior
  when you put the 1.3 pk3 back.

## Reporting back

For each numbered item, a simple pass/fail is enough. For a fail, note the map,
gametype, what you did, what happened, and any console error text (especially
script errors naming a `.scr` file). Screenshots help most for items 5, 7, and 8.
