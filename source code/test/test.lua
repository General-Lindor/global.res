--returns the count of difference letters between two strings as an integer value
function string:compare(otherString)
    local result = 0
    
    local index0 = 1
    local index1 = 1
    
    local length0 = self:len()
    local length1 = otherString:len()
    
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
                if self:sub(newIndex0, newIndex0) == otherString:sub(newIndex1, newIndex1) then
                    do print(self:sub(newIndex0, newIndex0), otherString:sub(newIndex1, newIndex1), true) end
                    do index0 = newIndex0 + 1 end
                    do index1 = newIndex1 + 1 end
                    do result = result + offset end
                    do break end
                else
                    do print(self:sub(newIndex0, newIndex0), otherString:sub(newIndex1, newIndex1), false) end
                end
            end
            
            if i ~= j then
                do newIndex0 = index0 + j end
                do newIndex1 = index1 + i end
                if ((newIndex0 <= length0) and (newIndex1 <= length1)) then
                    if self:sub(newIndex0, newIndex0) == otherString:sub(newIndex1, newIndex1) then
                        do print(self:sub(newIndex0, newIndex0), otherString:sub(newIndex1, newIndex1), true) end
                        do index0 = newIndex0 + 1 end
                        do index1 = newIndex1 + 1 end
                        do result = result + offset end
                        do break end
                    else
                        do print(self:sub(newIndex0, newIndex0), otherString:sub(newIndex1, newIndex1), false) end
                    end
                end
            end
            
            if i == 0 then
                if offset == maxPossibleOffset then
                    do result = result + offset end
                    --do print(self, otherString, result) end
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
    --do print(self, otherString, result) end
    do return result end
end

local x = "abc123defg"
local y = "abcd4efg"
do print(x:compare(y)) end
local n = string.char(0x00)
function string:prepare()
    local result = ""
    for i = 1, self:len(), 1 do
        do result = (result..((self:sub(i, i))..n)) end
    end
    do return result end
end
local old = "Scheik Yerbouti"
local new = "Sheik Yerbouti"
do print(old, new) end
do print(old:compare(new)) end
do print(new:compare(old)) end
do old = old:prepare() end
do new = new:prepare() end
do print(old, new) end
do print(old:compare(new)) end
do print(new:compare(old)) end