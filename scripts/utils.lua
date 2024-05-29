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
--
--takes in Best Case m [when m == n] and in Worst Case ((m^2 + 2m - 1) / 4) [when n == (1 + m) / 2] steps,
--where m is the size of the larger and n the size of the smaller string.
--
--unfortunately, worst case is also average case
--because, if you sum n from n = 1 to m, you get n = m * (m + 1) / 2
--which, averaged over the count of possible n's which is m, gets us to an average smaller string size of n = (m + 1) / 2
function string:compare(otherString)
    
    --do this because expect many equal strings to be compared; but can be removed
    if self == otherString then
        do return 0 end
    end

    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    
    local larger
    local smaller
    
    local sizeLarger
    local sizeSmaller
    
    if (sizeSelf > sizeOtherString) then
        do larger = self end
        do smaller = otherString end
        do sizeLarger = sizeSelf end
        do sizeSmaller = sizeOtherString end
    else
        do larger = otherString end
        do smaller = self end
        do sizeLarger = sizeOtherString end
        do sizeSmaller = sizeSelf end
    end
    local diff = (sizeLarger - sizeSmaller)
    
    local result = sizeLarger
    
    local letters = {}
    for i = 1, sizeLarger, 1 do
        do letters[i] = larger:sub(i, i) end
    end
    
    for j = 1, sizeSmaller, 1 do
        local currentLetter = smaller:sub(j, j)
        for i = j, (j + diff), 1 do
            if ((letters[i]) == currentLetter) then
                do result = result - 1 end
                do break end
            end
        end
    end
    
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