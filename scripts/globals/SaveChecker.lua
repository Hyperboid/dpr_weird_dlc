-- IMPORTANT! DO NOT rely on Windows' case-insensitive file paths!

---@type NativeFS
NativeFS = NativeFS

local os_type = require('ffi').os

---@class SaveChecker
local SaveChecker = {}

------------------------------
--   Windows path Helpers   --
------------------------------

function SaveChecker:fmtWindowsRootPath()
    -- TODO: detect Windows installs on non-C drives
    if os_type == "Windows" then return "C:/" end
    -- Assuming WINE paths
    local wineprefix = os.getenv("WINEPREFIX") or (os.getenv("HOME") .. "/.wine")
    return wineprefix .. "/drive_c"
end

function SaveChecker:fmtWindowsUserPath()
    local users = self:fmtWindowsRootPath() .. "/users"
    local userfolders = NativeFS.getDirectoryItems(users)
    userfolders = Utils.filter(userfolders, function(x) return x:upper() ~= "PUBLIC" end)
    local user_path
    if not os.getenv("USERPROFILE") then
        user_path = users.."/"..userfolders[1]
    else
        user_path = os.getenv("USERPROFILE")
    end
    return user_path
end

---@param subfolder "Local"|"LocalLow"|"Roaming"|string
function SaveChecker:fmtWindowsAppDataPath(subfolder)
    local suffix = "/AppData"
    if subfolder then
        suffix = suffix .. "/" .. subfolder
    end
    return self:fmtWindowsUserPath() .. suffix
end

------------------------------
--      Parsing helpers     --
------------------------------


--- Ensures what's passed in can be iterated through by lines
---@param input (fun():string)|NativeFS.File|love.File
---@return (fun():string) iter
function SaveChecker:mkIter(input)
    if type(input) == "table" or type(input) == "userdata" then
        assert(input.lines, "Invalid argument #1 (Expected file or function)")
        local file = input
        if not file:isOpen() then
            file:open("r")
        end
        input = file:lines()
    elseif type(input) == "string" then
        local lines = Utils.split(input, "\n", false)
        local index = 0
        input = function()
            index = index + 1
            return lines[index]
        end
    else
        assert(type(input) == "function", type(input))
    end
    return input
end

---@param input (fun():string)|NativeFS.File|love.File
function SaveChecker:parseIni(input)
    input = self:mkIter(input)
    local data = {}
    local current_subkey
    for line in input do
        local key, value = Utils.unpack(Utils.splitFast(line, "="))
        if line[1] == "[" then
            current_subkey = {}
            data[line:sub(2, #line - 1)] = current_subkey
        elseif key and value then
            current_subkey[key] = value
        end
    end
    return data
end


------------------------------
--   Save file detection    --
------------------------------
---@return "pacifist"|"neutral"|"geno"? route
---@return table? full_save
function SaveChecker:getUTYSave()
    local path = self:fmtWindowsAppDataPath("Local/Undertale_Yellow")
    if #NativeFS.getDirectoryItems(path) == 0 then return end
    local save = NativeFS.newFile(path .. "/Save.sav")
    local savedata = self:parseIni(save)
    return "neutral", savedata
end

return SaveChecker
