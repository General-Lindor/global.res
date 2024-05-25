-----------------------
-- PART 0: FUNCTIONS --
-----------------------
function string:toHex()
    return (self:gsub('.', function(c)
        return string.format('%02X', string.byte(c))
    end))
end

local LeBom = string.char(0xFF, 0xFE)
local linebreak = string.char(0x0D, 0x00, 0x0A, 0x00)
local tab = string.char(0x09, 0x00)

function sleep(s)
    do os.execute("timeout /t "..tostring(s).." /nobreak") end
end

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
        do error("tried to get a file from command but the resulting file doesn't exist;\n    command: "..command.."\n    folder path: "..folderPath) end
    end
    do return folderPath end
end

function copyFile(source, destination)
    if (fileExists(source)) then
        local handle = io.popen("copy \""..source.."\" \""..destination.."\"")
        do handle:flush() end
        do print(handle:read("*a")) end
        do handle:close() end
    else
        do error("attempt to copy nonexistent file from source: "..source) end
    end
end

function deleteFile(source)
    if (fileExists(source)) then
        local handle = io.popen("del \""..source.."\"")
        do handle:flush() end
        do print(handle:read("*a")) end
        do handle:close() end
    else
        do error("attempt to delete nonexistent file from source: "..source) end
    end
end

--------------------------------
-- PART I: BUILDING THE PATHS --
--------------------------------


local pathway = getFolderPath("cd")

local nameOfMainMod
local pathToMainMod
if arg[1] ~= nil then
    do nameOfMainMod = arg[1] end
    do pathToMainMod = pathway.."\\DECODED\\"..nameOfMainMod end
else
    do io.write("Please wait for the PopUp and choose a mod to reassemble: ") end
    do io.flush() end
    do pathToMainMod = getFolderPath("res\\chooseMod.bat") end
    local i = (#pathToMainMod)
    while (((pathToMainMod:sub(i, i)) ~= "\\") and (i > 0)) do
        do i = (i - 1) end
    end
    do nameOfMainMod = pathToMainMod:sub((i + 1), (#pathToMainMod)) end
    do print(nameOfMainMod) end
end
if (not fileExists(pathToMainMod)) then
    do error("ERROR: This mod does not seem to exist: "..pathToMainMod..", Aborting..", 0) end
    do return end
end

-------------------------
-- PART II: ASSEMBLING --
-------------------------

function getContents(pathToFile, justHashes)
    if not fileExists(pathToFile) then
        do error(" The language does not exist for the Child Mod.\n", 0) end
        do return end
    end
            
    --get files
    local file = (io.open(pathToFile, "rb"))
    
    --get binary contents
    local binary = file:read("*a")
    
    if (binary:sub(1, 2) == LeBom) then
        do binary = binary:sub(3, #binary) end
    end
    
    --split contents to tables
    local contents = {}
    
    if justHashes == true then
        for index, hash in pairs(binary:split(linebreak)) do
            do table.insert(contents, hash) end
        end
    else
        for index, item in pairs(binary:split(linebreak)) do
            local i, j = item:find(tab)
            if ((i ~= nil) and (j ~= nil)) then
                local hash = item:sub(1, i - 1)
                local text = item:sub(j + 1, #item)
                do contents[hash] = text end
            end
        end
    end
    
    --result
    do return contents end
end

function assemble(nameOfMod, language)
    if nameOfMod == "__BASE__" then
        local decodedFile = pathway.."\\DECODED\\".."__BASE__\\"..language.."\\decoded.txt"
        local contents = getContents(decodedFile)
        do return contents end
    else
        local pathToMod = pathway.."\\DECODED\\"..nameOfMod
        if (not fileExists(pathToMod)) then
            do error("ERROR: This mod does not seem to exist: "..nameOfMod..", Aborting..", 0) end
            do return end
        end
        local langPath = pathToMod.."\\"..language
        if (not (fileExists(langPath))) then
            do return false end
        end
        
        local reference = io.open(pathToMod.."\\inheritance.txt", "rb"):read("*a")
        local lastChar = reference:sub(#reference, #reference)
        while lastChar == "\n" or lastChar == " " do
            do reference = reference:sub(1, ((#reference) - 1)) end
            do lastChar = reference:sub(#reference, #reference) end
        end
        
        local contents = assemble(reference, language)
        
        local adds = getContents(langPath.."\\adds.txt")
        local smallChanges = getContents(langPath.."\\smallChanges.txt")
        local changes = getContents(langPath.."\\changes.txt")
        local removes = getContents(langPath.."\\removes.txt", true)
        
        for hash, text in pairs(adds) do
            do contents[hash] = text end
        end
        for hash, text in pairs(smallChanges) do
            do contents[hash] = text end
        end
        for hash, text in pairs(changes) do
            do contents[hash] = text end
        end
        for index, hash in pairs(removes) do
            do contents[hash] = nil end
        end
        
        do return contents end
    end
end

function buildDecoded(language)
    do io.write("Attempting to assemble language \""..language.."\"...") end
    do io.flush() end
    local langPath = pathToMainMod.."\\"..language
    if (not (fileExists(langPath))) then
        do return false end
    end
    
    local contents = assemble(nameOfMainMod, language)
    
    local file = io.open(langPath.."\\decoded.txt", "wb")
    
    local hashes = {}
    for hash, text in pairs(contents) do
        if (text ~= nil) then
            do table.insert(hashes, hash) end
        end
    end
    do table.sort(hashes) end
    
    do file:write(LeBom) end
    for index, hash in ipairs(hashes) do
        local s = hash..tab..(contents[hash])
        do s = s..linebreak end
        do file:write(s) end
    end
    do file:close() end
    do io.write(" Success!\n") end
    do io.flush() end
end

function reassembleAll()
    do buildDecoded("de_DE") end
    do buildDecoded("en_UK") end
    do buildDecoded("es_ES") end
    do buildDecoded("fr_FR") end
    do buildDecoded("hu_HU") end
    do buildDecoded("it_IT") end
    do buildDecoded("pl_PL") end
    do buildDecoded("ru_RU") end
end

if (arg[1] ~= nil) then
    local status, err = pcall(reassembleAll)
    if (not (status == true)) then
        do print(err) end
    end
else
    do reassembleAll() end
end
do print("Finish") end
io.read()