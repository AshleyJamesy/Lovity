function string.Comma(n)
	local f = n

	while true do
		f, k = string.gsub(f, "^(-?%d+)(%d%d%d)", '%1,%2')

		if (k == 0) then
			break
		end
	end

	return f
end

function string.EndsWith(s, e)
	return e == "" or s:sub(-#e) == e
end

function string.Explode(s, d, p)
	local t = {}
	
	for word in (s .. d):gmatch(p == true and d or ("(.-)" .. d)) do
		table.insert(t, #t + 1, word)
	end

	return t
end

function string.GetExtension(path)
	return path:match("^.*/[^/]*%.(.*)$")
end

function string.GetFilename(path)
	return path:match("^.*/([^/]*%..*)$")
end

function string.GetFile(path)
	return path:match("^.*/([^/]*)%..*$")
end

function string.GetPath(path)
	return path:match("^(.*/)[^/]*%..*$")
end

function string.Left(s, n)
	return s:sub(1, n)
end

local sizes = { "bytes", "kb", "mb", "gb", "tb", "pb", "eb", "zb", "yb" }

function string.NiceSize(n, t)
	local s = 0

	if t then
		t = t:lower()

		for k, size in pairs(sizes) do
			if t == size then
				s = k
				n = n * (1024 ^ (k - 1))
				break
			end
		end
	end

	for i = 0, #sizes - 1 do
		if (n / (1024 ^ (i + 1))) < 1.0 then
			return (n / (1024 ^ i)) .. " " .. ((i + 1) > 1 and sizes[i + 1]:upper() or sizes[i + 1]:ProperCase())
		end
	end
end

function string.ProperCase(s)
	s = s:gsub("(%a)([%w_']*)", function(a, b) 
		return a:upper() .. b:lower()
	end)
	
	return s
end

--TODO
--[[
function string.NiceTime(n)
	local m = math.floor(n / (60 ^ 1))
	local h = math.floor(n / (60 ^ 2))
	local d = math.floor(n / (60 ^ 2) / 24)
	local y = math.floor(n / (60 ^ 2) / 24 / 365)

	return y, d, h, m
end
]]

function string.Replace(s, f, r)
	return s:gsub(f, r)
end

function string.Right(s, n)
	return s:sub(#s - n + 1, #s)
end

function string.SetChar(s, i, r)
	if i > #s or i < 1 then
		return s
	end

	return s:sub(1, i - 1) .. r .. s:sub(i + 1)
end

function string.StartsWith(s, e)
	return s:sub(1, #e) == e
end