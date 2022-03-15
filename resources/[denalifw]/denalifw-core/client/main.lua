DenaliFW = {}
DenaliFW.PlayerData = {}
DenaliFW.Config = QBConfig
DenaliFW.Shared = QBShared
DenaliFW.ServerCallbacks = {}

exports('GetCoreObject', function()
    return DenaliFW
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local DenaliFW = exports['denalifw-core']:GetCoreObject()