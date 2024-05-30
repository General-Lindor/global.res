--------------------------
-- Part 0: Safety Check --
--------------------------

utilsHaveBeenLoaded = true

----------------------------------
-- Part I: String Related Stuff --
----------------------------------

--UCS-2 LE BOM Encoding related stuff
LeBom = string.char(0xFF, 0xFE)
linebreak = string.char(0x0D, 0x00, 0x0A, 0x00)
tab = string.char(0x09, 0x00)
whitechar = string.char(0x00)

--Binary representation of string
function string:toHex()
    return (self:gsub('.', function(c)
        return string.format('%02X', string.byte(c))
    end))
end

--Splits a string by a RegExp; exclusive: the RegExp itself is not contained; returns table
function string:split(pattern)
    local result = {}
    local start = 1
    local patternStart, patternEnd = self:find(pattern, start)
    while ((patternStart ~= nil) and (patternEnd ~= nil)) do
        if (patternStart > start) then
            do table.insert(result, self:sub(start, patternStart - 1)) end
        end
        do start = patternEnd + 1 end
        do patternStart, patternEnd = self:find(pattern, start) end
    end
    local last = #self
    if (start <= last) then
        do table.insert(result, self:sub(start, last)) end
    end
    do return result end
end

--returns the levenshtein distance between two strings
function string:compare(otherString)

    local L = {}
    
    local get
    local store
    
    do
        store = function(i, j, value)
            local t = L[i]
            if (t ~= nil) then
                do t[j] = value end
            else
                do L[i] = {value} end
            end
        end
    end
    
    do
        get = function(i, j)
            if (i == 0) then
                do return j end
            elseif (j == 0) then
                do return i end
            end
            
            local value = L[i]
            if (value ~= nil) then
                do value = value[j] end
                if (value ~= nil) then
                    do return value end
                end
            end
            
            local first = get(i - 1, j - 1)
            if self:sub(i, i) == self:sub(j, j) then
                do value = first end
            else
                local second = get(i, j - 1)
                local third = get(i - 1, j)
                do value = ((math.min(first, math.min(second, third))) + 1) end
            end
            do store(i, j, value) end
            do return value end
        end
    end
    
    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    local result = get(sizeSelf, sizeOtherString)
    do L = nil end
    do return result end
end

--do string.compare("Banana", "Banana") end
--do string.compare("Banana", "Potato") end
--do string.compare("Potato", "Banana") end
--do string.compare("Jack Haber", "Jack Hober") end
--do string.compare("Jack Haber", "Jack Hoaber") end
--do string.compare("Jack Hober", "Jack Haber") end
--do string.compare("Jack Hoaber", "Jack Haber") end
--do io.read() end

--------------------------------
-- Part II: CMD Related Stuff --
--------------------------------

--sleep

function sleep(s)
    do os.execute("timeout /t "..tostring(s).." /nobreak") end
end

--message

local cmdLines = {}

function persistentWrite(message)
    do table.insert(cmdLines, message) end
    do os.execute("cls") end
    for index, message in ipairs(cmdLines) do
        do io.write(message) end
    end
    do io.write("\n") end
    do io.flush() end
end

function persistentPrint(message)
    do persistentWrite(message.."\n") end
end

----------------------------------
-- Part III: File Related Stuff --
----------------------------------

function fileExists(testFile)
    local test = io.popen("dir \""..testFile.."\" /b"):read("*a")
    do return (test ~= "") end
end

function getFolderPath(command)
    local file = io.popen(command)
    do file:flush() end
    local folderPath = file:read("*a")
    do file:close() end
    do folderPath = folderPath:gsub("/", "\\") end
    do folderPath = folderPath:gsub("\n", "") end
    while ((folderPath:sub(#folderPath, #folderPath)) == "\\") do
        do folderPath = folderPath:sub(1, #folderPath - 1) end
    end
    if (not (fileExists(folderPath))) then
        do error("ERROR: Tried to get a file from command but the resulting file doesn't exist;\n    command: "..command.."\n    folder path: "..folderPath) end
    end
    do return folderPath end
end

function copyFile(source, destination)
    if (fileExists(source)) then
        local handle = io.popen("copy \""..source.."\" \""..destination.."\"")
        do handle:flush() end
        do print((handle:read("*a")):gsub("\n", "")) end
        do handle:close() end
    else
        do error("ERROR: Attempt to copy nonexistent file from directory: \""..source.."\"") end
    end
end

function deleteFile(source)
    if (fileExists(source)) then
        local handle = io.popen("del \""..source.."\"")
        do handle:flush() end
        do print((handle:read("*a")):gsub("\n", "")) end
        do handle:close() end
    else
        do error("ERROR: Attempt to delete nonexistent file from directory: \""..source.."\"") end
    end
end

function rmdir(directory)
    if (fileExists(directory)) then
        do os.execute("rmdir /s \""..directory.."\"") end
    else
        do error("ERROR: Attempt to delete nonexistent directory: \""..directory.."\"") end
    end
end

function mkdir(directory)
    if (fileExists(directory)) then
        do error("ERROR: Attempt to create an already existing directory: \""..directory.."\"") end
    else
        do os.execute("mkdir \""..directory.."\"") end
    end
end