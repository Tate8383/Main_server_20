this_is_a_map "yes"

files {
	"gabztimecyclemods.xml",
    "pillbox/gabz_timecycle_mods_1.xml",
    "gabz_mrpd_timecycle.xml",
    'gabz_bennys_timecycle.xml',
    'nutt_timecycle_mods_1.xml',
    -- "audio/ivbsoverride_game.dat151.rel",
    -- "audio/gardoor_game.dat151.rel",
    -- "audio/cellgate_game.dat151.rel",
    "pillbox/interiorproxies.meta",
    "sanhje_prison_timecycle.xml",
}

data_file "TIMECYCLEMOD_FILE" "gabztimecyclemods.xml"
data_file "INTERIOR_PROXY_ORDER_FILE" "interiorproxies.meta"
data_file "TIMECYCLEMOD_FILE" "gabz_mrpd_timecycle.xml"
-- data_file "AUDIO_GAMEDATA" "audio/ivbsoverride_game.dat"
-- data_file "AUDIO_GAMEDATA" "audio/gardoor_game.dat"
-- data_file "AUDIO_GAMEDATA" "audio/cellgate_game.dat"
data_file "INTERIOR_PROXY_ORDER_FILE" "pillbox/interiorproxies.meta"
data_file "TIMECYCLEMOD_FILE" "pillbox/gabz_timecycle_mods_1.xml"
data_file 'DLC_ITYP_REQUEST' 'stream/courthouse/def_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/courthouse/niggaworkplease.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'gabz_bennys_timecycle.xml'
data_file 'TIMECYCLEMOD_FILE' 'nutt_timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'sanhje_prison_timecycle.xml'


client_scripts {
    "client.lua",
}

fx_version "adamant"
games { "gta5" }