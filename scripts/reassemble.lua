function reassemble(pathway, nameOfMainMod)
    -----------------------
    -- PART 0: FUNCTIONS --
    -----------------------

    if (utilsHaveBeenLoaded ~= true) then
        do dofile("utils.lua") end
    end
    
    --------------------------------
    -- PART I: BUILDING THE PATHS --
    --------------------------------
    
    local pathToMainMod = pathway.."\\DECODED\\"..nameOfMainMod
    if (not fileExists(pathToMainMod)) then
        do error("ERROR: This mod does not seem to exist: "..pathToMainMod..", Aborting..", 0) end
        do return end
    end
    
    -------------------------
    -- PART II: ASSEMBLING --
    -------------------------
    
    local getDecodedContents = function(pathToFile, justHashes)
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
    
    local assemble
    do assemble = function(nameOfMod, language)
        if nameOfMod == "__BASE__" then
            local decodedFile = pathway.."\\DECODED\\".."__BASE__\\"..language.."\\decoded.txt"
            local contents = getDecodedContents(decodedFile)
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
            
            local adds = getDecodedContents(langPath.."\\adds.txt")
            local smallChanges = getDecodedContents(langPath.."\\smallChanges.txt")
            local changes = getDecodedContents(langPath.."\\changes.txt")
            local removes = getDecodedContents(langPath.."\\removes.txt", true)
            
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
    end end

    local buildDecoded = function(language)
        do persistentWrite("    Attempting to assemble language \""..language.."\"...") end
        local langPath = pathToMainMod.."\\"..language
        if (not (fileExists(langPath))) then
            do persistentPrint(" The Mod does not have the language; could not assemble!") end
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
        do persistentPrint(" Success!") end
    end
    
    do buildDecoded("de_DE") end
    do buildDecoded("en_UK") end
    do buildDecoded("es_ES") end
    do buildDecoded("fr_FR") end
    do buildDecoded("hu_HU") end
    do buildDecoded("it_IT") end
    do buildDecoded("pl_PL") end
    do buildDecoded("ru_RU") end
end