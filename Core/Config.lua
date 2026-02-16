local HttpService = game:GetService("HttpService")

local Config = {}

function Config:Save(Library)
    if not writefile then return end

    local data = HttpService:JSONEncode(Library.Flags)

    if not isfolder(Library.Config.ConfigFolder) then
        makefolder(Library.Config.ConfigFolder)
    end

    writefile(
        Library.Config.ConfigFolder .. "/" .. Library.Config.ConfigFile,
        data
    )
end

function Config:Load(Library)
    if not readfile then return end

    local path = Library.Config.ConfigFolder .. "/" .. Library.Config.ConfigFile
    if not isfile(path) then return end

    local data = HttpService:JSONDecode(readfile(path))

    for flag,value in pairs(data) do
        if Library.Flags[flag] ~= nil then
            Library.Flags[flag] = value
        end
    end
end

return Config
