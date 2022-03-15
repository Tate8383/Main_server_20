NADRP = {}
NADRP.PlayerData = {}
NADRP.Config = QBConfig
NADRP.Shared = QBShared
NADRP.ServerCallbacks = {}

exports('GetCoreObject', function()
    return NADRP
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local NADRP = exports['NADRP-core']:GetCoreObject()