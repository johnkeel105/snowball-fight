Snowball contest v1.1 by jv_map
Thanks to mohaa_rox for the snowball model!
-------------------------------

Enables snowball mode for all stock mohaa maps.

To install: extract user-snowcontest2.pk3 to your \main folder
To uninstall: remove user-snowcontest2.pk3 from your \main folder.

Changes since v1.0
-------------------------------
Below is a list of changes since the previous version of 
this snowball contest mod. For each change it is noted whether 
this is a server-side or client-side change, or both.

- Disabled all stationary machineguns (mg-42s) (server)
- New snowball model (client)
- Scripted snow in all maps (functionality can be disabled server-side) (server + client)
- Hud now says 'Snowballs' instead of 'Frag Grenade' (client)
- New message every 2 minutes with download link for mod (server)
- Adjusted fog and sky settings for all stock maps (server)
- Fixed issue where players would sporadically spawn with regular weapons in obj and roundbased matches (server)
- Fixed script error that caused a whale of errors when a player had left the server (server)

Compatibility
-------------------------------
With this version installed you should be able to join any server, so it 
doesn't matter what snowball contest version the server is running.

Players with older snowball contest versions should still be able to join 
a server running v1.1 without any issues at all.

You may have older versions of this mod in your \main folder (user-snowcontest.pk3). 
It shouldn't hinder v1.1 in any way.

Info For Developers
-------------------------------
To add this to user-made maps:

In the map's script add

'exec global/snowcontest.scr'

below 'level waittill spawn'.

Furthermore, you can specify whether you want 
scripted snow in your map using the following line:

level.addsnow = 1

This line needs to be added between 'level waittill spawn' and 
the 'exec global/snowcontest.scr' line.

In addition, you may want the snow contest script to 
adjust fog, sky and ambient sound settings server-side. To do this, type:

level.snowmood = 1	

between 'level waittill spawn' and 'exec global/snowcontest.scr'.

Example:

level waittill spawn

level.addsnow = 1
level.snowmood = 1

exec global/snowcontest.scr

Disabling Scripted Snow
-------------------------------
In case the scripted snow is somehow causing troubles to you, it can be 
disabled server-side. To disable the snow on a dedicated server, type the following 
directly in the server console:

sc_nosnow 1

Or, to make mohaa remember not to use scripted snow:

seta sc_nosnow 1

If you have rcon access to a server, type:

rcon sc_nosnow 1

If you're hosting a game yourself on a non-dedicated server, make sure first to enable 
'console' in the advanced options. Press 'ok' and bring down the console with the ~ key.
Then type:

sc_nosnow 1

When you've performed any of these actions, the snow should disappear after a short while.
You can 'restart' the snow by simply setting 'sc_nosnow' back to '0'.

At any time the amount of snow clients see is dependent on their setting for 'effects detail'
in advanced options ('max' means most snow).

-------------------------------
Enjoy!

jv_map

e-mail: 	jv_map@planetmedalofhonor.com
website: 	http://www.planetmedal.com/freebrief/
			http://www.planetmedal.com/map/