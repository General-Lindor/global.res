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