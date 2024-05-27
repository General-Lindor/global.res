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
    do persistentPrint("Building the Paths...") end

    local pathway = getFolderPath("cd")

    do io.write("    Please wait for the PopUp and choose a mod to analyze: ") end
    do io.flush() end
    local modName
    do
        local fullModPath = getFolderPath("scripts\\chooseMod.bat")
        local i = (#fullModPath)
        while (((fullModPath:sub(i, i)) ~= "\\") and (i > 0)) do
            do i = (i - 1) end
        end
        do modName = fullModPath:sub((i + 1), (#fullModPath)) end
        do print(modName) end
    end

    local decodedDirectory = pathway.."\\DECODED\\"..modName

    -------------------------------------------------
    -- PART II: Reassembling the decoded.txt files --
    -------------------------------------------------
    do persistentPrint("Reassembling the decoded.txt files...") end

    do dofile("scripts\\reassemble.lua") end
    do reassemble(pathway, modName) end

    ---------------------------------
    -- PART III: Reading the Files --
    ---------------------------------
    do persistentPrint("Reading the Files...") end
    
    local languageContentsHashmap = {}

    local getContents = function(tag)
        do persistentWrite("    Attempting to read language \""..tag.."\"...") end
        
        local langPath = decodedDirectory.."\\"..tag
        
        if (fileExists(langPath)) then
        
            local pathToFile = langPath.."\\decoded.txt"
            
            if (fileExists(pathToFile)) then
                
                --get files
                local file = (io.open(pathToFile, "rb"))
                
                --get binary contents
                local binary = file:read("*a")
                do file:close() end
                
                if (binary:sub(1, 2) == LeBom) then
                    do binary = binary:sub(3, #binary) end
                end
                
                --split contents to tables
                local contents = {}
                
                for index, item in pairs(binary:split(linebreak)) do
                    local i, j = item:find(tab)
                    if ((i ~= nil) and (j ~= nil)) then
                        local hash = item:sub(1, i - 1)
                        local text = item:sub(j + 1, #item)
                        do contents[hash] = text end
                    end
                end
                
                --result
                do languageContentsHashmap[tag] = contents end
                do persistentPrint(" Success!") end
                
            else
                do error("ERROR: Could not find the reassembled decoded.txt! Language: \""..tag.."\"") end
            end
        else
            do persistentPrint(" The mod does not support the language!") end
        end
    end

    do getContents("de_DE") end
    do getContents("en_UK") end
    do getContents("es_ES") end
    do getContents("fr_FR") end
    do getContents("hu_HU") end
    do getContents("it_IT") end
    do getContents("pl_PL") end
    do getContents("ru_RU") end

    ------------------------------------
    -- PART IV: Doing the actual work --
    ------------------------------------
    do persistentPrint("Analyzing...") end
    
    local criticalHashes = {}
    
    for currentLanguage, currentLanguageContents in pairs(languageContentsHashmap) do
        for hash, text in pairs(currentLanguageContents) do
            if (text ~= nil) then
                local hasUnsupportedLanguage = false
                local supportedLanguages = {currentLanguage}
                local unsupportedLanguages= {}
                for language, languageContents in pairs(languageContentsHashmap) do
                    if (language ~= currentLanguage) then
                        if (languageContents[hash] == nil) then
                            do hasUnsupportedLanguage = true end
                            do table.insert(unsupportedLanguages, language) end
                        else
                            do table.insert(supportedLanguages, language) end
                        end
                    end
                end
                if (hasUnsupportedLanguage == true) then
                    local cleanHash = hash
                    do cleanHash = cleanHash:gsub(whitechar, "") end
                    do criticalHashes[cleanHash] = {supportedLanguages, unsupportedLanguages} end
                end
            end
        end
    end

    -----------------------
    -- PART V: Exporting --
    -----------------------
    
    local analysisFile = io.open(decodedDirectory.."\\Analysis.txt", "wb")
    do analysisFile:write("Here you can find all the critical hashes which are not defined for all supported languages of your mod.\nKeep in mind that the Analysis is cumulative; Inconsistencies are inherited unless you explicitly fixed them in your mod.\n\n") end
    local justHashes = {}
    for k, v in pairs(criticalHashes) do
        do table.insert(justHashes, k) end
    end
    do table.sort(justHashes) end
    local addln = false
    for hashIndex, hash in ipairs(justHashes) do
        if (addln == true) then
            do analysisFile:write("\n") end
        else
            do addln = true end
        end
        do analysisFile:write(hash) end
        local t = criticalHashes[hash]
        local supportedLanguages = t[1]
        local unsupportedLanguages = t[2]
        do table.sort(supportedLanguages) end
        do table.sort(unsupportedLanguages) end
        
        do analysisFile:write("\n    supported languages: ") end
        local addc = false
        for languageIndex, language in ipairs(supportedLanguages) do
            if (addc == true) then
                do analysisFile:write(", ") end
            else
                do addc = true end
            end
            do analysisFile:write(language) end
        end
        
        do analysisFile:write("\n    unsupported languages: ") end
        local addc = false
        for languageIndex, language in ipairs(unsupportedLanguages) do
            if (addc == true) then
                do analysisFile:write(", ") end
            else
                do addc = true end
            end
            do analysisFile:write(language) end
        end
    end
    do analysisFile:close() end

    ---------------------
    -- PART V: Cleanup --
    ---------------------
    do persistentPrint("Doing Cleanup...") end

    do dofile("scripts\\cleanup.lua") end
    do cleanup(pathway.."\\DECODED") end
end

----------------------
-- PART VI: Finish --
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