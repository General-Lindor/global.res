function ascii_to_binary(a)
    return a:gsub("\\x(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end)
end

local file = io.open("C:\\Users\\Jean-Luc Picard\\Sacred 2 modding\\global.res\\DECODED\\__BASE__\\de_DE\\decoded.txt")
local content = file:read("*a")

function hex(s)
    do return tonumber(s, 16) end
end

local linebreak = string.char(hex("0D"), hex("00"), hex("0A"), hex("00"))
local secondlinebreak = string.char(0x0D, 0x00, 0x0A, 0x00)
local thirdlinebreak = "\n"

local i, j = content:find(linebreak)
print(i, j, content:sub(1, i - 1))

local k, l = content:find(secondlinebreak)
print(k, l, content:sub(1, k - 1))

local m, n = content:find(thirdlinebreak)
print(m, n, content:sub(1, m - 1))

function mysplit(inputstr, sep)
    local t = {}
    for str in inputstr:gmatch("([^"..sep.."]+)") do
        do table.insert(t, str) end
    end
    return t
end

function split(inputstr, sep)
    sep = sep or '%s'
    local t = {}
    for field, s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
        do table.insert(t, field) end
        if s == "" then
            do return t end
        end
    end
end

print(content:sub(1, 2) == string.char(0xFF, 0xFE))
local thing = "thingi"
print(thing:match("([^i]+)i([^i]+)"))