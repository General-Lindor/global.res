if (utilsHaveBeenLoaded ~= true) then
    do dofile("utils.lua") end
end

--deletes all instances of "decoded.txt" fom directory (including subdirectories)
function cleanup(path, noMessage)
    if (noMessage ~= true) then
        do persistentWrite("Cleaning up leftovers...") end
    end
    if fileExists(path) then
        local pfile = io.popen('dir "'..path..'" /b')
        for filename in pfile:lines() do
            if (filename ~= "__BASE__") then
                local newPath = path.."\\"..filename
                if (filename == "decoded.txt") then
                    if fileExists(newPath) then
                        do deleteFile(newPath) end
                    end
                else
                    do cleanup(newPath, true) end
                end
            end
        end
        do pfile:close() end
    end
    if (noMessage ~= true) then
        do persistentPrint(" Success!") end
    end
end