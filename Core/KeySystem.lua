local KeySystem = {}

function KeySystem:Start(Library, callback)

    local function Verify(key)

        if Library.Config.KeyType == "Static" then
            return key == Library.Config.StaticKey

        elseif Library.Config.KeyType == "Time" then
            return tonumber(key) and tonumber(key) > os.time()

        elseif Library.Config.KeyType == "HWID" then
            return key == game:GetService("RbxAnalyticsService"):GetClientId()

        elseif Library.Config.KeyType == "HTTP" then
            local response = game:HttpGet(Library.Config.KeyURL .. key)
            return response == "true"
        end

        return false
    end

    -- Build small key UI
    -- On submit:
    -- if Verify(input) then callback()
end

return KeySystem
