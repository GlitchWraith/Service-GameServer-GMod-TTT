#!/usr/bin/env expect 

set collection [lindex $argv 0]
set API [lindex $argv 1]

spawn /home/steam/Server1/srcds_run -game garrysmod +maxplayers 12 +map gm_flatgrass +gamemode terrortown -console +host_workshop_collection $collection -authkey $API 

expect "VAC secure mode is activated." {close}
