local mainScript = function()
    -------------------
    -- PART 0: Setup --
    -------------------

    if (utilsHaveBeenLoaded ~= true) then
        do print("Performing Setup...") end
        do dofile("scripts/utils.lua") end
        do persistentPrint("Performing Setup... Success!") end
    else
        do persistentPrint("Performing Setup... Setup has already been loaded!") end
    end

    --------------------------------
    -- PART I: Building the Paths --
    --------------------------------
    do persistentPrint("Building Paths...") end

    --pathway

    local pathway = getFolderPath("cd")

    --fullModPath
    --modPath
    --modName

    do io.write("    Please wait for the PopUp and select your mod folder: ") end
    do io.flush() end
    local fullModPath
    local modPath
    local modName
    do
        do fullModPath = getFolderPath("scripts\\chooseFolder.bat") end
        local i = (#fullModPath)
        while (((fullModPath:sub(i, i)) ~= "\\") and (i > 0)) do
            do i = (i - 1) end
        end
        do modPath = fullModPath:sub(1, (i - 1)) end
        do modName = fullModPath:sub((i + 1), (#fullModPath)) end
        do print(modName) end
    end

    --fullBasePath
    --basePath
    --baseName

    do io.write("    Please wait for the PopUp and choose a mod to inherit from: ") end
    do io.flush() end
    local fullBasePath
    local basePath
    local baseName
    do
        do fullBasePath = getFolderPath("scripts\\chooseMod.bat") end
        local i = (#fullBasePath)
        while (((fullBasePath:sub(i, i)) ~= "\\") and (i > 0)) do
            do i = (i - 1) end
        end
        do basePath = fullBasePath:sub(1, (i - 1)) end
        do baseName = fullBasePath:sub((i + 1), (#fullBasePath)) end
        do print(baseName) end
    end

    --decodedDirectory
    --encodedDirectory

    local decodedDirectory = pathway.."\\DECODED\\"..modName
    local encodedDirectory = pathway.."\\ENCODED\\"..modName

    -----------
    -- check --
    -----------

    if (not (fileExists(fullModPath.."\\locale"))) then
        do error("ERROR: The mod needs to have a locale directory but doesn't!") end
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
        do error("ERROR: The mod needs to contain at least one language folder in the locale directory! de_DE, en_UK, es_ES, fr_FR, hu_HU, it_IT, pl_PL and ru_RU are supported.") end
    end

    do sleep(5) end

    ----------------------------
    -- PART II: Copying Files --
    ----------------------------
    do persistentPrint("Copying Files...") end

    while (fileExists(decodedDirectory) or fileExists(encodedDirectory)) do
        do print("Already exists. Do you want to overwrite? (y/n)") end
        local answer = io.read()
        while ((answer ~= "y") and (answer ~= "n")) do
            do print("Invalid answer. Do you want to overwrite? (y/n)") end
            do answer = io.read() end
        end
        if answer == "y" then
            if (fileExists(decodedDirectory)) then
                do rmdir(decodedDirectory) end
            end
            if (fileExists(encodedDirectory)) then
                do rmdir(encodedDirectory) end
            end
        elseif answer == "n" then
            --not actually an error; i just want the program to end
            do error("Stopped the program since the user did not want to overwrite.") end
        else
            do error("WTF??") end
        end
    end

    do sleep(2) end
    do mkdir(decodedDirectory) end
    do mkdir(encodedDirectory) end

    function create(tag)
        local filePath = fullModPath.."\\locale\\"..tag.."\\global.res"
        if (fileExists(filePath)) then
            local langPathDecoded = decodedDirectory.."\\"..tag
            local langPathEncoded = encodedDirectory.."\\"..tag
            do mkdir(langPathDecoded) end
            do mkdir(langPathEncoded) end
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
    -- PART III: Decoding the Locale --
    -----------------------------------
    do persistentPrint("Decoding Files...") end

    function decodeLanguage(tag, shorttag)
        do persistentWrite("    Attempting to decode language \""..tag.."\"...") end
        local langPathDecoded = decodedDirectory.."\\"..tag
        local langPathEncoded = encodedDirectory.."\\"..tag
        if fileExists(langPathDecoded) then
            do copyFile(pathway.."\\scripts\\decoding\\autodecode.bat", langPathDecoded.."\\autodecode.bat") end
            do copyFile(pathway.."\\scripts\\decoding\\noS2", langPathDecoded.."\\noS2") end
            do copyFile(pathway.."\\scripts\\decoding\\S2read.dll", langPathDecoded.."\\S2read.dll") end
            do copyFile(pathway.."\\scripts\\decoding\\S2rw.v1.7.exe", langPathDecoded.."\\S2rw.v1.7.exe") end
            
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
            
            do sleep(5) end
            do persistentPrint(" Success!") end
            do return true end
        else
            do sleep(5) end
            do persistentPrint(" The Mod does not have that language; could not decode") end
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

    do decodeLanguage("de_DE", "De") end
    do decodeLanguage("en_UK", "En") end
    do decodeLanguage("es_ES", "Sp") end
    do decodeLanguage("fr_FR", "Fr") end
    do decodeLanguage("hu_HU", "Hu") end
    do decodeLanguage("it_IT", "It") end
    do decodeLanguage("pl_PL", "Pl") end
    do decodeLanguage("ru_RU", "Ru") end

    -------------------------------------------------
    -- PART IV: Building ancestor Mods decoded.txt --
    -------------------------------------------------
    do persistentPrint("Assembling Ancestor Mod locale files...") end
    do dofile("scripts\\reassemble.lua") end
    do reassemble(pathway, baseName) end

    --------------------------------------
    -- PART V: Implementing Inheritance --
    --------------------------------------
    do persistentPrint("Implementing Inheritance...") end

    do
        local file = io.open(decodedDirectory.."\\inheritance.txt", "wb")
        do file:write(baseName) end
        do file:close() end
    end

    function getLanguageContents(tag)
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
                do fileBase:close() end
                do fileMod:close() end
                
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
                do rmdir(decodedDirectory) end
                do rmdir(encodedDirectory) end
                do error() end
                do return false end
            end
        else
            do persistentPrint(" The language does not exist for the Child Mod.") end
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
                do print("Working on hash: "..k) end
                local aequivalency = contentsMod[k]
                if (aequivalency == nil) then
                    do removes[#removes + 1] = k end
                else
                    local matchinglvl = (v:compare(aequivalency))
                    if matchinglvl == 0 then
                        do contentsMod[k] = nil end
                    elseif matchinglvl <= 6 then
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
                do print("Working on hash: "..k) end
                local aequivalency = contentsBase[k]
                if (aequivalency == nil) then
                    do adds[k] = v end
                    do addsKeys[#addsKeys + 1] = k end
                else
                    local matchinglvl = (v:compare(aequivalency))
                    if matchinglvl == 0 then
                        do contentsBase[k] = nil end
                    elseif matchinglvl <= 6 then
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
        do persistentWrite("    Attempting to inherit language \""..tag.."\"...") end
        
        local contentsBase, contentsMod = getLanguageContents(tag)
        if contentsBase == false then
            do error("ERROR: Somehow didn't get valid contents.") end
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
        
        do persistentPrint(" Success!") end
    end

    do implementInheritance("de_DE") end
    do implementInheritance("en_UK") end
    do implementInheritance("es_ES") end
    do implementInheritance("fr_FR") end
    do implementInheritance("hu_HU") end
    do implementInheritance("it_IT") end
    do implementInheritance("pl_PL") end
    do implementInheritance("ru_RU") end

    ----------------------
    -- PART VI: Cleanup --
    ----------------------
    --deletes all instances of "decoded.txt" fom directory (including subdirectories)
    do dofile("scripts\\cleanup.lua") end
    do cleanup(pathway.."\\DECODED") end
end

----------------------
-- PART VII: Finish --
----------------------
local status, err = pcall(mainScript)
if (status == true) then
    do print("Finish; You may now close the program (or input ENTER).") end
    do io.read() end
else
    do print(err) end
    do print("Stopped due to Error. You may now close the program (or input ENTER).") end
    do io.read() end
end