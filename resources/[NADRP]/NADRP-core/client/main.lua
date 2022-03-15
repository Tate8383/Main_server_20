denalifw = {}
denalifw.PlayerData = {}
denalifw.Config = QBConfig
denalifw.Shared = QBShared
denalifw.ServerCallbacks = {}

exports('GetCoreObject', function()
    return denalifw
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local denalifw = exports['denalifw-core']:GetCoreObject()