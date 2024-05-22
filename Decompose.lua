-----------------------
-- PART 0: Functions --
-----------------------

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
                    do print(string0, string1, result) end
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
    do print(string0, string1, result) end
    do return result end
end

do compareStrings("Banana", "Banana") end
do compareStrings("Banana", "Potato") end
do compareStrings("Potato", "Banana") end
do compareStrings("Jack Haber", "Jack Hober") end
do compareStrings("Jack Haber", "Jack Hoaber") end
do compareStrings("Jack Hober", "Jack Haber") end
do compareStrings("Jack Hoaber", "Jack Haber") end

--------------------------------
-- PART I: BUILDING THE PATHS --
--------------------------------

do print("Building paths...") end
local pathway = getFolderPath("cd")

do print("Please select your mod folder:") end
local modPath = getFolderPath("res\\chooseFolder.bat")
local i = #modPath
while (((modPath:sub(i, i)) ~= "\\") and (i > 0)) do
    do i = i - 1 end
end
local modName = modPath:sub(i + 1, #modPath)
do modPath = modPath:sub(1, i - 1) end
local fullModPath = modPath.."\\"..modName

do print("Please choose a mod to inherit from:") end
local basePath = getFolderPath("res\\chooseMod.bat")
do i = #basePath end
while (((basePath:sub(i, i)) ~= "\\") and (i > 0)) do
    do i = i - 1 end
end
local baseName = basePath:sub(i + 1, #basePath)


local workingDirectory = pathway.."\\MODS\\"..modName

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

do print("Copying Relevant Files...") end
while (fileExists(workingDirectory)) do
    local answer = nil
    while ((answer ~= "y") and (answer ~= "n")) do
        do print("Already exists. Do you want to overwrite? (y/n)") end
        do answer = io.read() end
    end
    if answer == "y" then
        do os.execute("rmdir /s \""..workingDirectory.."\"") end
    elseif answer == "n" then
        do goto finish end
    else
        do error("WTF??") end
    end
end
do os.execute("timeout 1") end
do os.execute("mkdir \""..workingDirectory.."\"") end
function create(tag)
    local filePath = fullModPath.."\\locale\\"..tag.."\\global.res"
    if (fileExists(filePath)) then
        local langPath = workingDirectory.."\\"..tag
        do os.execute("mkdir \""..langPath.."\"") end
        do copyFile(filePath, langPath.."\\global.res") end
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

function decodeLanguage(tag, shorttag)
    do os.execute("cls") end
    do print("Attempting to decode language "..tag) end
    do print("    PLEASE DO NOT INTERRUPT AND BE PATIENT!") end
    do print("    DO NOT PRESS ANYTHING ON THE KEYBOARD!") end
    do print("    DO NOT CLICK ANY MOUSE BUTTON!") end
    local langPath = workingDirectory.."\\"..tag
    if fileExists(langPath) then
        do copyFile(pathway.."\\res\\decoding\\autodecode.bat", langPath.."\\autodecode.bat") end
        do copyFile(pathway.."\\res\\decoding\\noS2", langPath.."\\noS2") end
        do copyFile(pathway.."\\res\\decoding\\S2read.dll", langPath.."\\S2read.dll") end
        do copyFile(pathway.."\\res\\decoding\\S2rw.v1.7.exe", langPath.."\\S2rw.v1.7.exe") end
        
        local subhandle = io.popen("cd \""..langPath.."\" && autodecode.bat "..tag)
        do subhandle:flush() end
        do print(subhandle:read("*a")) end
        do subhandle:close() end
        
        if (fileExists(langPath.."\\decoded.txt")) then
            do deleteFile(langPath.."\\decoded.txt") end
        end
        do os.rename(langPath.."\\global"..shorttag.."_texts.txt", langPath.."\\decoded.txt") end
        
        do deleteFile(langPath.."\\autodecode.bat") end
        do deleteFile(langPath.."\\noS2") end
        do deleteFile(langPath.."\\S2read.dll") end
        do deleteFile(langPath.."\\S2rw.v1.7.exe") end
        
        do print("Successfully decoded "..tag) end
        do os.execute("timeout 2") end
    else
        do print("Language "..tag.." does not exist; could not decode") end
        do os.execute("timeout 2") end
    end
end
do print("Attempting to decode the files next. DURING DECODING:") end
do print("    PLEASE DO NOT INTERRUPT AND BE PATIENT!") end
do print("    DO NOT PRESS ANYTHING ON THE KEYBOARD!") end
do print("    DO NOT CLICK ANY MOUSE BUTTON!") end
do print("PLEASE CLOSE ALL OTHER APLLICATIONS BEFORE CONTINUING AND INPUT THE ENTER KEY INTO THE CONSOLE ONCE YOU'RE READY:") end
do io.read() end

do decodeLanguage("de_DE", "De") end
do decodeLanguage("en_UK", "En") end
do decodeLanguage("es_ES", "Sp") end
do decodeLanguage("fr_FR", "Fr") end
do decodeLanguage("hu_HU", "Hu") end
do decodeLanguage("it_IT", "It") end
do decodeLanguage("pl_PL", "Pl") end
do decodeLanguage("ru_RU", "Ru") end

--local handle = io.popen('dir "'..mypath..'" /b')
--for myFolderNames in handle:lines() do
--end
--do handle:close() end
::finish::
do print("Finish") end
io.read()