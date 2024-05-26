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

--returns the count of difference letters between two strings as an integer value
function string:compare(otherString)
    local result = 0
    
    local index0 = 1
    local index1 = 1
    
    local length0 = self:len()
    local length1 = otherString:len()
    
    while ((index0 <= length0) and (index1 <= length1)) do
        
        local maxPossibleOffset = (length0 + length1) - (index0 + index1)
        local offset = 0
        local i = 0
        local j = 0
        
        local newIndex0
        local newIndex1
        
        while true do
            
            do newIndex0 = index0 + i end
            do newIndex1 = index1 + j end
            if ((newIndex0 <= length0) and (newIndex1 <= length1)) then
                if self:sub(newIndex0, newIndex0) == otherString:sub(newIndex1, newIndex1) then
                    do index0 = newIndex0 + 1 end
                    do index1 = newIndex1 + 1 end
                    do result = result + offset end
                    do break end
                end
            end
            
            if i ~= j then
                do newIndex0 = index0 + j end
                do newIndex1 = index1 + i end
                if ((newIndex0 <= length0) and (newIndex1 <= length1)) then
                    if self:sub(newIndex0, newIndex0) == otherString:sub(newIndex1, newIndex1) then
                        do index0 = newIndex0 + 1 end
                        do index1 = newIndex1 + 1 end
                        do result = result + offset end
                        do break end
                    end
                end
            end
            
            if i == 0 then
                if offset == maxPossibleOffset then
                    do result = result + offset end
                    --do print(self, otherString, result) end
                    do return result end
                else
                    do offset = offset + 1 end
                    do i = offset // 2 end
                    do j = offset - i end
                end
            else
                do i = i - 1 end
                do j = j + 1 end
            end
            
        end
    end
    --do print(self, otherString, result) end
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