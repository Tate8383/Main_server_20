resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

files {
  'vehiclelayouts_cw2019.meta',
  'vehicles.meta',
  'carvariations.meta',
  'carcols.meta',
  'handling.meta',
  'audioconfig/sultanrsv8_game.dat151',
  'audioconfig/sultanrsv8_game.dat151.nametable',
  'audioconfig/sultanrsv8_game.dat151.rel',
  'audioconfig/sultanrsv8_sounds.dat54',
  'audioconfig/sultanrsv8_sounds.dat54.nametable',
  'audioconfig/sultanrsv8_sounds.dat54.rel',
  'sfx/dlc_v8sultanrs/v8sultanrs.awc',
  'sfx/dlc_v8sultanrs/v8sultanrs_npc.awc',
  'audioconfig/sentinelsg4_game.dat151',
  'audioconfig/sentinelsg4_game.dat151.nametable',
  'audioconfig/sentinelsg4_game.dat151.rel',
  'audioconfig/sentinelsg4_sounds.dat54',
  'audioconfig/sentinelsg4_sounds.dat54.nametable',
  'audioconfig/sentinelsg4_sounds.dat54.rel',
  'sfx/dlc_sentinelsg4/sentinelsg4.awc',
  'sfx/dlc_sentinelsg4/sentinelsg4_npc.awc',
  'audioconfig/stratumc_amp.dat10',
  'audioconfig/stratumc_amp.dat10.nametable',
  'audioconfig/stratumc_amp.dat10.rel',
  'audioconfig/stratumc_game.dat151',
  'audioconfig/stratumc_game.dat151.nametable',
  'audioconfig/stratumc_game.dat151.rel',
  'audioconfig/stratumc_sounds.dat54',
  'audioconfig/stratumc_sounds.dat54.nametable',
  'audioconfig/stratumc_sounds.dat54.rel',
  'sfx/dlc_zircoflow/stratumc.awc',
  'sfx/dlc_zircoflow/stratumc_npc.awc',
  'audioconfig/trumpetzrc_game.dat151',
  'audioconfig/trumpetzrc_game.dat151.nametable',
  'audioconfig/trumpetzrc_game.dat151.rel',
  'audioconfig/trumpetzrc_sounds.dat54',
  'audioconfig/trumpetzrc_sounds.dat54.nametable',
  'audioconfig/trumpetzrc_sounds.dat54.rel',
  'audioconfig/trumpetzr_game.dat151',
  'audioconfig/trumpetzr_game.dat151.nametable',
  'audioconfig/trumpetzr_game.dat151.rel',
  'audioconfig/trumpetzr_sounds.dat54',
  'audioconfig/trumpetzr_sounds.dat54.nametable',
  'audioconfig/trumpetzr_sounds.dat54.rel',
  'sfx/dlc_trumpetzr/trumpetzr.awc',
  'sfx/dlc_trumpetzr/trumpetzr_npc.awc',
  'audioconfig/cw2019_game.dat151',
  'audioconfig/cw2019_game.dat151.nametable',
  'audioconfig/cw2019_game.dat151.rel',
  'audioconfig/cw2019_sounds.dat54',
  'audioconfig/cw2019_sounds.dat54.nametable',
  'audioconfig/cw2019_sounds.dat54.rel',
  'sfx/dlc_cw2019/cw2019.awc',
  'sfx/dlc_cw2019/cw2019_npc.awc'
}

data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts_cw2019.meta'
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'AUDIO_GAMEDATA' 'audioconfig/sentinelsg4_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/sentinelsg4_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_sentinelsg4'
data_file 'AUDIO_GAMEDATA' 'audioconfig/trumpetzrc_game.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/trumpetzr_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/trumpetzrc_sounds.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/trumpetzr_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_trumpetzr'
data_file 'AUDIO_GAMEDATA' 'audioconfig/cw2019_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/cw2019_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_cw2019'
data_file 'AUDIO_GAMEDATA' 'audioconfig/sultanrsv8_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/sultanrsv8_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_v8sultanrs'
data_file 'AUDIO_SYNTHDATA' 'audioconfig/stratumc_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/stratumc_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/stratumc_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_zircoflow'

client_script {
    'vehicle_names.lua'
}
client_script "@Badger-Anticheat/acloader.lua"