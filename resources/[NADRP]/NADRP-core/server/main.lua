NADRP = {}
NADRP.Config = QBConfig
NADRP.Shared = QBShared
NADRP.ServerCallbacks = {}
NADRP.UseableItems = {}

exports('GetCoreObject', function()
    return NADRP
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local NADRP = exports['NADRP-core']:GetCoreObject()

-- Get permissions on server start

CreateThread(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            NADRP.Config.Server.PermissionList[v.license] = {
                license = v.license,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)