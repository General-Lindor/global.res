if (utilsHaveBeenLoaded ~= true) then
    do dofile("utils.lua") end
end

--deletes all instances of "decoded.txt" fom directory (including subdirectories)
function cleanup(path, noSleep)
    if (noSleep ~= true) then
        do persistentWrite("Cleaning up leftovers...") end
    end
    if fileExists(path) then
        do io.write("Attempting to cleanup \""..path.."\"...") end
        do io.flush() end
        local pfile = io.popen('dir "'..path..'" /b')
        for filename in pfile:lines() do
            if (filename ~= "__BASE__") then
                local newPath = path.."\\"..filename
                if (filename == "decoded.txt") then
                    if fileExists(newPath) then
                        do io.write(" \"decoded.txt\"-file detected, deleting...") end
                        do io.flush() end
                        do deleteFile(newPath) end
                        do io.write(" Success!\n") end
                        do io.flush() end
                    end
                else
                    do cleanup(newPath, true) end
                end
            end
        end
        do pfile:close() end
    end
    if (noSleep ~= true) then
        do sleep(5) end
        do persistentPrint(" Success!") end
    end
end