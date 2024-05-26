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

    do io.write("    Please wait for the PopUp and choose a mod to inherit from: ") end
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
    local encodedDirectory = pathway.."\\ENCODED\\"..modName

    local toolsDirectory = pathway.."\\scripts\\decoding"
    local rwPath = toolsDirectory.."\\S2rw.v1.7.exe"

    -------------------------------------------------
    -- PART II: Reassembling the decoded.txt files --
    -------------------------------------------------
    do persistentPrint("Reassembling the decoded.txt files...") end

    do dofile("scripts\\reassemble.lua") end
    do reassemble(pathway, modName) end

    -------------------------------------
    -- PART III: Defining the Function --
    -------------------------------------
    do persistentPrint("Defining the Function...") end

    local cdCommand = "cd \""..toolsDirectory.."\""

    local encodeLanguage = function(tag, shorttag, shorttagplus)
        do persistentWrite("    Attempting to encode language \""..tag.."\"...") end
        
        local langPath = decodedDirectory.."\\"..tag
        
        if (fileExists(langPath)) then
        
            local pathToFile = langPath.."\\decoded.txt"
            
            if (fileExists(pathToFile)) then
                local encodeCommand = "\""..rwPath.."\" \""..pathToFile.."\" "..shorttagplus
                local mergedCommand = "\"("..cdCommand.. ") && ("..encodeCommand..")\""
                
                do os.execute(mergedCommand) end
                
                -- delete old global.res...
                local pathToOldGlobalRes = encodedDirectory.."\\"..tag.."\\global.res"
                if (fileExists(pathToOldGlobalRes)) then
                    do deleteFile(pathToOldGlobalRes) end
                end
                
                -- ...and replace with new one!
                local pathToNewGlobalRes = toolsDirectory.."\\global.res_"..shorttag.."_new"
                if (fileExists(pathToNewGlobalRes)) then
                    do os.rename(pathToNewGlobalRes, pathToOldGlobalRes) end
                else
                    do error("ERROR: Could not find the newly encoded global.res! Language: \""..tag.."\"") end
                end
                
                -- delete char report, if present
                local pathToCharReport = toolsDirectory.."\\global"..shorttag.."_char_report.txt"
                if (fileExists(pathToCharReport)) then
                    do deleteFile(pathToCharReport) end
                end
                do persistentPrint(" Success!") end
            else
                do error("ERROR: Could not find the reassembled decoded.txt! Language: \""..tag.."\"") end
            end
        else
            do persistentPrint(" The mod does not support the language!") end
        end
    end

    ------------------------------------
    -- PART IV: Doing the actual work --
    ------------------------------------
    do persistentPrint("Encoding the languages...") end

    do encodeLanguage("de_DE", "De", "De+") end
    do encodeLanguage("en_UK", "En", "En+") end
    do encodeLanguage("es_ES", "Sp", "Sp+") end
    do encodeLanguage("fr_FR", "Fr", "Fr+") end
    do encodeLanguage("hu_HU", "Hu", "Hu+") end
    do encodeLanguage("it_IT", "It", "It+") end
    do encodeLanguage("pl_PL", "Pl", "Pl+") end
    do encodeLanguage("ru_RU", "Ru", "Ru+") end

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