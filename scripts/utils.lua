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

--https://en.wikipedia.org/wiki/Longest_common_substring
--I did some improvements; should be O(n+m) now!
--And don't even need complicated stuff like suffix Tree!
function longestCommonSubstring(stringA, stringB)
    local lengthA = stringA:len()
    local lengthB = stringB:len()
    
    local L = {}
    
    local LCSlength = 0
    local indexAEnd = 1
    local indexBEnd = 1
    
    local get
    local store
    
    do
        get = function(i, j)
            local possibleResult = L[i]
            if (possibleResult == nil) then
                do return 0 end
            end
            do possibleResult = possibleResult[j] end
            if (possibleResult == nil) then
                do return 0 end
            end
            do return possibleResult end
        end
    end
    
    do
        store = function(i, j)
            local value = get((i - 1), (j - 1)) + 1
            if ((L[i]) == nil) then
                local t = {}
                do t[j] = value end
                do L[i] = t end
            else
                do (L[i])[j] = value end
            end
            if (value > LCSlength) then
                do LCSlength = value end
                do indexAEnd = j end
                do indexBEnd = i end
            end
        end
    end
    
    local lettersA = {}
    
    for indexA = 1, lengthA, 1 do
        local letter = stringA:sub(indexA, (indexA))
        local t = lettersA[letter]
        if (t == nil) then
            do lettersA[letter] = {indexA} end
        else
            do table.insert(t, indexA) end
        end
    end
    
    for indexB = 1, lengthB, 1 do
        do L[indexB - 2] = nil end
        local letter = stringB:sub(indexB, (indexB))
        local t = lettersA[letter]
        if (t ~= nil) then
            for key, indexA in ipairs(t) do
                do store(indexB, indexA) end
            end
        end
    end
    
    do return indexAEnd, indexBEnd, LCSlength end
end

--returns the count of difference letters between two strings as an integer value
function string:compare(otherString)
    
    if self == otherString then
        do return 0 end
    end

    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    
    local indexSelfEnd, indexOtherStringEnd, lengthSubstring = longestCommonSubstring(self, otherString)
    if (lengthSubstring == 0) then
        local result = sizeSelf + sizeOtherString
        do return result end
    end
    local indexSelfStart = ((indexSelfEnd - lengthSubstring) + 1)
    local indexOtherStringStart = ((indexOtherStringEnd - lengthSubstring) + 1)
    
    local selfLeft = self:sub(1, (indexSelfStart - 1))
    local otherStringLeft = otherString:sub(1, (indexOtherStringStart - 1))
    
    local selfRight = self:sub((indexSelfEnd + 1), sizeSelf)
    local otherStringRight = otherString:sub((indexOtherStringEnd + 1), sizeOtherString)
    
    local resultLeft = (selfLeft:compare(otherStringLeft))
    local resultRight = (selfRight:compare(otherStringRight))
    local result = resultLeft + resultRight
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