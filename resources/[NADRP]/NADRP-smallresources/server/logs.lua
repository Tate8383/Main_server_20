local NADRP = exports['NADRP-core']:GetCoreObject()

local Webhooks = {
    ['default'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['testwebhook'] = '',
    ['playermoney'] = 'https://discord.com/api/webhooks/953239964160761856/A3LlMiM70_VNrM3eilvUGgv_tkKNpqNE_I94eqaSquKhqnSfuH2Ak2-W3bTBYuSF_OkI',
    ['playerinventory'] = 'https://discord.com/api/webhooks/953240099800358912/7M9CQINIWYzcB4jJtkndeMvd3Panl4RjI5Gk3ED1wWd1t-0x29jJTrfv3x6fJeCilgEI',
    ['robbing'] = 'https://discord.com/api/webhooks/953240209636610048/CD5xMmRmB49xyAxOYyp2ueKiGcpCCEY8Cmiy3zdLJhnKdWPsoc7HAvxQwoXeKDGH0OP1',
    ['cuffing'] = 'https://discord.com/api/webhooks/953240338523377705/ZCTrDhkC_MxXXL6ptj8xDs9vBZECeDt3ZKxwLmt3PWIYvU4-OyAv2zPN2g9bN7_jgaNv',
    ['drop'] = 'https://discord.com/api/webhooks/953240672645808158/aYtYdEb3esJ5HP2j6t7FLlkjmhG0jKGaUgwYCf3PEkI6KoLVDE59s8WPgM_3mmx3eVn2',
    ['trunk'] = 'https://discord.com/api/webhooks/953240768867336233/YxZYUfq6xMyddHTDF8KE-xwmSX4TKKpB7f8WgcZPMILbcBZZa6sCjK4WwFjXalM4IOVG',
    ['stash'] = 'https://discord.com/api/webhooks/953240858617081876/9XE61Hh77lTDaKu6xdyWctRrAOfxzNDBPQhyeSoBI0Kn0mizxUGzyQnRc3GN1ikhoQU4',
    ['glovebox'] = 'https://discord.com/api/webhooks/953241001877700608/Yk7_5G3S6tb1215S9-Cm1qAupGHsvZfQ80iC-Jl6jYXRNUpvgD3s5t7MbZ4aazf5cQcF',
    ['banking'] = 'https://discord.com/api/webhooks/953241099068117042/AXJmNwM0UtmX2EpPHB_HAjoetaCw5OTTXZDZdAEV9wZX6HtJjAcU69pK3j6140zVEgkt',
    ['vehicleshop'] = 'https://discord.com/api/webhooks/953241190193582091/z6js8ub1EEeYhXOA24iHskpd4Gk_VZeNMEa5slcQ6infmHuQbIbYjyB7vjEp9YpPZF8c',
    ['vehicleupgrades'] = 'https://discord.com/api/webhooks/953241295101497404/gFkSjp1jdvjfk23UocINW--tLjQCffJlanRA4Qt6yithviW4gHtg7F0HjsUfou-pTYWZ',
    ['shops'] = 'https://discord.com/api/webhooks/953241399904600074/gKD-v1OVY5vQkiV4hFu1fk2i6Az-K7j8grCv3-3ruMy9UNTu6V0CmPZ0FP3iKvCBqTWE',
    ['dealers'] = 'https://discord.com/api/webhooks/953241503092850698/sxN9UrJLci65ZXgjNjltNjl8nRU7lNqTUNMsGPGTIyP1THdByAZ9R6D8dBZl1UiTPFJm',
    ['storerobbery'] = 'https://discord.com/api/webhooks/953241628653527070/eA-6GU6fmZeSNZplwoyvUzRpx8NLzS8S2Xfsnef85gwY5Iz54ADHOB4k4Tvg02_x6Ib4',
    ['bankrobbery'] = 'https://discord.com/api/webhooks/953241758131716146/HVS95Ldn7m0MoiRnzQTD9Dt3C31t1YX59FqcuvvSOZCkjrySGF9ggn6yssS8KpMapbnJ',
    ['powerplants'] = 'https://discord.com/api/webhooks/953241872149676042/yryVgrbEuXFmFUkrxaX7L0NyMOSblCjgPFfo95BGdo8_Bw-ktNTVgPnPX1vrKiW5_s5g',
    ['death'] = 'https://discord.com/api/webhooks/953242103675256852/bT5vClhWT0pxev2OvFyiJTR3Ssu7jQsxXELgUrLo3SvRgagiMkAwEeuGlTQySYIuQPP7',
    ['joinleave'] = 'https://discord.com/api/webhooks/953242197078212631/11hNcHAvVdaVA9_gXS7ErrXTdNvQXTVLdspsUTIlzqdFSw-c3ljC-RyZNDrOwx1lfHZS',
    ['ooc'] = 'https://discord.com/api/webhooks/953242290204311553/qk7Ef1TqejWs0ZM6os_n-jAqoEZDUxNwcGLfeG1qzU0zBljvf-LX6_7OYu7z91xosq5f',
    ['report'] = 'https://discord.com/api/webhooks/953242387088568370/8mvvSjILOSiFLzrvXIuRrhWCliQQn5p8GbqYeM3Ih8dm0o3ujeAq5fsSSBdO9XPG2dJQ',
    ['me'] = 'https://discord.com/api/webhooks/953242532123377694/XmMTp6GdHsbquhCVmMMgz1dtX2PtGr7G--_Xh772ztITr68DMohpo5GiBEjhHFgmnbdB',
    ['pmelding'] = 'https://discord.com/api/webhooks/953242704282787891/ae1AnJSY9HQEwDjSCVDGGMsg_C-nOar81mTuhbzNA01TSVhAaECTUPpAbLdAGYTBeQH0',
    ['112'] = 'https://discord.com/api/webhooks/953242805831086091/DRL8KWuzyxNGP9OB3V-DJ4Y9f1PFAko1X4ATj9Dejo9K_mlvnCn9S_NNPFZPhlq7djPl',
    ['bans'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['anticheat'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['weather'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['moneysafes'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['bennys'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['bossmenu'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['robbery'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['casino'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['traphouse'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
    ['911'] = 'https://discord.com/api/webhooks/953242805831086091/DRL8KWuzyxNGP9OB3V-DJ4Y9f1PFAko1X4ATj9Dejo9K_mlvnCn9S_NNPFZPhlq7djPl',
    ['palert'] = 'https://discord.com/api/webhooks/953242805831086091/DRL8KWuzyxNGP9OB3V-DJ4Y9f1PFAko1X4ATj9Dejo9K_mlvnCn9S_NNPFZPhlq7djPl',
    ['house'] = 'https://discord.com/api/webhooks/953239846175006720/O1q-9IWM4iMA-JNwXHa0oXTYouC2EN4BgC91FQp0__XgDzVgSvHzLn432pUf5nKv21SB',
}

local Colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ["lightgreen"] = 65309,
}

RegisterNetEvent('NADRP-log:server:CreateLog', function(name, title, color, message, tagEveryone)        
    local tag = tagEveryone or false
    local webHook = Webhooks[name] or Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Colors[color] or Colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'NADRP Logs',
                ['icon_url'] = 'https://media.discordapp.net/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png?width=670&height=670',
            },
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = 'QB Logs', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = 'QB Logs', content = '@everyone'}), { ['Content-Type'] = 'application/json' })
    end
end)

NADRP.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function(source, args)
    TriggerEvent('NADRP-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
