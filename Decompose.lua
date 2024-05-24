function cls(lvl)
    do os.execute("cls") end
    do print("Performing Setup...") end
    if (lvl > 0) then
        do print("Building Paths...") end
    else
        do return end
    end
    if (lvl > 1) then
        do print("Copying Files...") end
    else
        do return end
    end
    if (lvl > 2) then
        do print("Decoding Files...") end
    else
        do return end
    end
    if (lvl > 3) then
        do print("Implementing Inheritance...") end
    else
        do return end
    end
end

-----------------------
-- PART 0: Functions --
-----------------------
do cls(0) end

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

--returns the count of difference letters between two strings as an integer value
function compareStrings(string0, string1)
    local result = 0
    
    local index0 = 1
    local index1 = 1
    
    local length0 = string0:len()
    local length1 = string1:len()
    
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
                if string0:sub(newIndex0, newIndex0) == string1:sub(newIndex1, newIndex1) then
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
                    if string0:sub(newIndex0, newIndex0) == string1:sub(newIndex1, newIndex1) then
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
                    --do print(string0, string1, result) end
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
    --do print(string0, string1, result) end
    do return result end
end

--do compareStrings("Banana", "Banana") end
--do compareStrings("Banana", "Potato") end
--do compareStrings("Potato", "Banana") end
--do compareStrings("Jack Haber", "Jack Hober") end
--do compareStrings("Jack Haber", "Jack Hoaber") end
--do compareStrings("Jack Hober", "Jack Haber") end
--do compareStrings("Jack Hoaber", "Jack Haber") end
--do io.read() end

--------------------------------
-- PART I: BUILDING THE PATHS --
--------------------------------
do cls(1) end

--pathway

do print("Building paths...") end
local pathway = getFolderPath("cd")

--fullModPath
--modPath
--modName

do print("Please wait for the PopUp and select your mod folder:") end
local fullModPath
local modPath
local modName
do
    do fullModPath = getFolderPath("res\\chooseFolder.bat") end
    local i = (#fullModPath)
    while (((fullModPath:sub(i, i)) ~= "\\") and (i > 0)) do
        do i = (i - 1) end
    end
    do modPath = fullModPath:sub(1, (i - 1)) end
    do modName = fullModPath:sub((i + 1), (#fullModPath)) end
end

--fullBasePath
--basePath
--baseName

do print("Please wait for the PopUp and choose a mod to inherit from:") end
local fullBasePath
local basePath
local baseName
do
    do fullBasePath = getFolderPath("res\\chooseMod.bat") end
    local i = (#fullBasePath)
    while (((fullBasePath:sub(i, i)) ~= "\\") and (i > 0)) do
        do i = (i - 1) end
    end
    do basePath = fullBasePath:sub(1, (i - 1)) end
    do baseName = fullBasePath:sub((i + 1), (#fullBasePath)) end
end

--decodedDirectory
--encodedDirectory

local decodedDirectory = pathway.."\\DECODED\\"..modName
local encodedDirectory = pathway.."\\ENCODED\\"..modName

-----------
-- check --
-----------

if (not (fileExists(fullModPath.."\\locale"))) then
    do error("The mod needs to have a locale directory but doesn't!") end
end

local hasSomething = false
if (fileExists(fullModPath.."\\locale\\de_DE")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\en_UK")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\es_ES")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\fr_FR")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\hu_HU")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\it_IT")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\pl_PL")) then
    do hasSomething = true end
elseif (fileExists(fullModPath.."\\locale\\ru_RU")) then
    do hasSomething = true end
end
if (not hasSomething) then
    do error("The mod needs to contain at least one language folder in the locale directory! de_DE, en_UK, es_ES, fr_FR, hu_HU, it_IT, pl_PL and ru_RU are supported.") end
end

---------------------------------------------
-- PART II: BUILDING THE WORKING DIRECTORY --
---------------------------------------------
do cls(2) end

while (fileExists(decodedDirectory) or fileExists(encodedDirectory)) do
    local answer = nil
    while ((answer ~= "y") and (answer ~= "n")) do
        do print("Already exists. Do you want to overwrite? (y/n)") end
        do answer = io.read() end
    end
    if answer == "y" then
        if (fileExists(decodedDirectory)) then
            do os.execute("rmdir /s \""..decodedDirectory.."\"") end
        end
        if (fileExists(encodedDirectory)) then
            do os.execute("rmdir /s \""..encodedDirectory.."\"") end
        end
    elseif answer == "n" then
        do goto finish end
    else
        do error("WTF??") end
    end
end

do sleep(1) end
do os.execute("mkdir \""..decodedDirectory.."\"") end
do os.execute("mkdir \""..encodedDirectory.."\"") end

function create(tag)
    local filePath = fullModPath.."\\locale\\"..tag.."\\global.res"
    if (fileExists(filePath)) then
        local langPathDecoded = decodedDirectory.."\\"..tag
        local langPathEncoded = encodedDirectory.."\\"..tag
        do os.execute("mkdir \""..langPathDecoded.."\"") end
        do os.execute("mkdir \""..langPathEncoded.."\"") end
        do copyFile(filePath, langPathDecoded.."\\global.res") end
    end
end

do create("de_DE") end
do create("en_UK") end
do create("es_ES") end
do create("fr_FR") end
do create("hu_HU") end
do create("it_IT") end
do create("pl_PL") end
do create("ru_RU") end

-----------------------------------
-- PART III: DECODING THE LOCALE --
-----------------------------------
do cls(3) end

function decodeLanguage(tag, shorttag)
    local langPathDecoded = decodedDirectory.."\\"..tag
    local langPathEncoded = encodedDirectory.."\\"..tag
    if fileExists(langPathDecoded) then
        do copyFile(pathway.."\\res\\decoding\\autodecode.bat", langPathDecoded.."\\autodecode.bat") end
        do copyFile(pathway.."\\res\\decoding\\noS2", langPathDecoded.."\\noS2") end
        do copyFile(pathway.."\\res\\decoding\\S2read.dll", langPathDecoded.."\\S2read.dll") end
        do copyFile(pathway.."\\res\\decoding\\S2rw.v1.7.exe", langPathDecoded.."\\S2rw.v1.7.exe") end
        
        local subhandle = io.popen("cd \""..langPathDecoded.."\" && autodecode.bat "..tag)
        do subhandle:flush() end
        do print(subhandle:read("*a")) end
        do subhandle:close() end
        
        if (fileExists(langPathDecoded.."\\decoded.txt")) then
            do deleteFile(langPathDecoded.."\\decoded.txt") end
        end
        do os.rename(langPathDecoded.."\\global"..shorttag.."_texts.txt", langPathDecoded.."\\decoded.txt") end
        do os.rename(langPathDecoded.."\\global.res", langPathEncoded.."\\global.res") end
        
        do deleteFile(langPathDecoded.."\\autodecode.bat") end
        do deleteFile(langPathDecoded.."\\noS2") end
        do deleteFile(langPathDecoded.."\\S2read.dll") end
        do deleteFile(langPathDecoded.."\\S2rw.v1.7.exe") end
        
        do print("Successfully decoded language \""..tag.."\"") end
        do sleep(1) end
        do return true end
    else
        do print("Language \""..tag.."\" does not exist; could not decode") end
        do sleep(1) end
        do return false end
    end
end

do print("Attempting to decode the files next.") end
do print("DURING DECODING:") end
do print("    PLEASE DO NOT INTERRUPT AND BE PATIENT!") end
do print("    DO NOT PRESS ANYTHING ON THE KEYBOARD!") end
do print("    DO NOT CLICK ANY MOUSE BUTTON!") end
do print("PLEASE CLOSE ALL OTHER APLLICATIONS BEFORE CONTINUING AND INPUT THE ENTER KEY INTO THE CONSOLE ONCE YOU'RE READY:") end
do io.read() end
do cls(3) end

do
    local messages = {}
    function decodeAndMessage(tag, smallTag)
        do print("    Attempting to decode language \""..tag.."\"...") end
        local hasBeenSuccessful = decodeLanguage(tag, smallTag)
        do cls(3) end
        if (hasBeenSuccessful) then
            do messages[#messages + 1] = "    Attempting to decode language \""..tag.."\"... Success!" end
        else
            do messages[#messages + 1] = "    Attempting to decode language \""..tag.."\"... Mod doesn't have the language." end
        end
        for k, v in pairs(messages) do
            do print(v) end
        end
    end

    do decodeAndMessage("de_DE", "De") end
    do decodeAndMessage("en_UK", "En") end
    do decodeAndMessage("es_ES", "Sp") end
    do decodeAndMessage("fr_FR", "Fr") end
    do decodeAndMessage("hu_HU", "Hu") end
    do decodeAndMessage("it_IT", "It") end
    do decodeAndMessage("pl_PL", "Pl") end
    do decodeAndMessage("ru_RU", "Ru") end
end

---------------------------------------
-- PART IV: Implementing Inheritance --
---------------------------------------
do print("Implementing Inheritance...") end

do
    local file = io.open(decodedDirectory.."\\inheritance.txt", "wb")
    do file:write(baseName) end
    do file:close() end
end

function getContents(tag)
    local fileBasePath = fullBasePath.."\\"..tag.."\\decoded.txt"
    local fileModPath = decodedDirectory.."\\"..tag.."\\decoded.txt"
    if fileExists(fileModPath) then
        if fileExists(fileBasePath) then
            
            --get files
            local fileBase = (io.open(fileBasePath, "rb"))
            local fileMod = (io.open(fileModPath, "rb"))
            
            --get binary contents
            local binaryBase = fileBase:read("*a")
            local binaryMod = fileMod:read("*a")
            
            if (binaryBase:sub(1, 2) == LeBom) then
                do binaryBase = binaryBase:sub(3, #binaryBase) end
            end
            if (binaryMod:sub(1, 2) == LeBom) then
                do binaryMod = binaryMod:sub(3, #binaryMod) end
            end
            
            --split contents to tables
            local contentsBase = {}
            local contentsMod = {}
            
            for index, item in pairs(binaryBase:split(linebreak)) do
                local i, j = item:find(tab)
                if ((i ~= nil) and (j ~= nil)) then
                    local hash = item:sub(1, i - 1)
                    local text = item:sub(j + 1, #item)
                    do contentsBase[hash] = text end
                end
            end
            
            for index, item in pairs(binaryMod:split(linebreak)) do
                local i, j = item:find(tab)
                if ((i ~= nil) and (j ~= nil)) then
                    local hash = item:sub(1, i - 1)
                    local text = item:sub(j + 1, #item)
                    do contentsMod[hash] = text end
                end
            end
            
            --result
            do return contentsBase, contentsMod end
        else
            do print() end
            do print("CRITICAL ERROR: The Ancestor Mod you want to inherit from does not contain the language \""..tag.."\" while the Child Mod does!") end
            do print("Erasing all files..") end
            do os.execute("rmdir /s \""..decodedDirectory.."\"") end
            do os.execute("rmdir /s \""..encodedDirectory.."\"") end
            do return false end
        end
    else
        do io.write(" The language does not exist for the Child Mod.\n") end
        do io.flush() end
        do return end
    end
end

function getSets(contentsBase, contentsMod)
            
    local smallChanges = {}
    local changes = {}
    local adds = {}
    local removes = {}
    
    local smallChangesKeys = {}
    local changesKeys = {}
    local addsKeys = {}
    
    for k, v in pairs(contentsBase) do
        if (v ~= nil) then
            local aequivalency = contentsMod[k]
            if (aequivalency == nil) then
                do removes[#removes + 1] = k end
            else
                local matchinglvl = compareStrings(v, aequivalency)
                if matchinglvl == 0 then
                    do contentsMod[k] = nil end
                elseif matchinglvl < 6 then
                    do smallChanges[k] = aequivalency end
                    do smallChangesKeys[#smallChangesKeys + 1] = k end
                    do contentsMod[k] = nil end
                else
                    do changes[k] = aequivalency end
                    do changesKeys[#changesKeys + 1] = k end
                    do contentsMod[k] = nil end
                end
            end
        end
    end
    
    for k, v in pairs(contentsMod) do
        if (v ~= nil) then
            local aequivalency = contentsBase[k]
            if (aequivalency == nil) then
                do adds[k] = v end
                do addsKeys[#addsKeys + 1] = k end
            else
                local matchinglvl = compareStrings(v, aequivalency)
                if matchinglvl == 0 then
                    do contentsBase[k] = nil end
                elseif matchinglvl < 6 then
                    do smallChanges[k] = v end
                    do smallChangesKeys[#smallChangesKeys + 1] = k end
                    do contentsBase[k] = nil end
                else
                    do changes[k] = v end
                    do changesKeys[#changesKeys + 1] = k end
                    do contentsBase[k] = nil end
                end
            end
        end
    end
    
    do table.sort(smallChangesKeys) end
    do table.sort(changesKeys) end
    do table.sort(addsKeys) end
    do table.sort(removes) end
    
    do return smallChanges, changes, adds, removes, smallChangesKeys, changesKeys, addsKeys end
end

function implementInheritance(tag)
    do io.write("    Attempting to inherit language \""..tag.."\"...") end
    do io.flush() end
    
    local contentsBase, contentsMod = getContents(tag)
    if contentsBase == false then
        do return false end
    elseif ((contentsBase == nil) or (contentsMod == nil)) then
        do return nil end
    end
    
    local smallChanges, changes, adds, removes, smallChangesKeys, changesKeys, addsKeys = getSets(contentsBase, contentsMod)
    
    local smallChangesFile = io.open(decodedDirectory.."\\"..tag.."\\smallChanges.txt", "wb")
    do smallChangesFile:write(LeBom) end
    for k, v in ipairs(smallChangesKeys) do
        local s = v..tab..(smallChanges[v])..linebreak
        do smallChangesFile:write(s) end
    end
    do smallChangesFile:close() end
    
    local changesFile = io.open(decodedDirectory.."\\"..tag.."\\changes.txt", "wb")
    do changesFile:write(LeBom) end
    for k, v in ipairs(changesKeys) do
        local s = v..tab..(changes[v])..linebreak
        do changesFile:write(s) end
    end
    do changesFile:close() end
    
    local addsFile = io.open(decodedDirectory.."\\"..tag.."\\adds.txt", "wb")
    do addsFile:write(LeBom) end
    for k, v in ipairs(addsKeys) do
        local s = v..tab..(adds[v])..linebreak
        do addsFile:write(s) end
    end
    do addsFile:close() end
    
    local removesFile = io.open(decodedDirectory.."\\"..tag.."\\removes.txt", "wb")
    do removesFile:write(LeBom) end
    for k, v in ipairs(removes) do
        local s = v..linebreak
        do removesFile:write(s) end
    end
    do removesFile:close() end
    
    do io.write(" Success!\n") end
    do io.flush() end
end

do
    local hasBeenSuccessful
    do hasBeenSuccessful = implementInheritance("de_DE") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("en_UK") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("es_ES") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("fr_FR") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("hu_HU") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("it_IT") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("pl_PL") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
    do hasBeenSuccessful = implementInheritance("ru_RU") end
    if (hasBeenSuccessful == false) then
        do goto finish end
    end
end

::finish::
do print("Finish") end
io.read()