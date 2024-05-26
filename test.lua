do dofile("res/utils.lua") end

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

local s = "xnynzndnaninhn"
for k, v in pairs(s:split("dnan")) do print(k, v) end

do s = "xnyndndnananhn" end
for k, v in pairs(s:split("dnan")) do print(k, v) end

function t()
do return 1 end
end
function s()
function t()
do return 2 end
end
print(t())
end
print(t())
s()
print(t())

local tt = function()
do return 1 end
end
local ss = function()
local tt = function()
do return 2 end
end
print(tt())
end
print(tt())
ss()
print(tt())

print(getFolderPath("cd"))