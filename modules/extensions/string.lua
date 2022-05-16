local gsub = string.gsub

function string.comma(n)
	local f = n

	while true do
		f, k = gsub(f, "^(-?%d+)(%d%d%d)", '%1,%2')

		if (k == 0) then
			break
		end
	end

	return f
end

function string.endsWith(s, e)
	return e == "" or s:sub(-#e) == e
end

local function esc(s)
	return s:gsub('%%', '%%%%'):gsub('^%^', '%%^'):gsub('%$$', '%%$'):gsub('%(', '%%('):gsub('%)', '%%)'):gsub('%.', '%%.'):gsub('%[', '%%['):gsub('%]', '%%]'):gsub('%*', '%%*'):gsub('%+', '%%+'):gsub('%-', '%%-'):gsub('%?', '%%?')
end

function string.explode(s, d, p)
	local t = {}
	
	for word in (s .. d):gmatch(p == true and d or ("(.-)" .. esc(d))) do
		table.insert(t, word)
	end

	return t
end

function string.getExtension(path)
	return path:match("^.*/[^/]*%.(.*)$")
end

function string.getFilename(path)
	return path:match("^.*/([^/]*%..*)$")
end

function string.getFile(path)
	return path:match("^.*/([^/]*)%..*$")
end

function string.getPath(path)
	return path:match("^(.*/)[^/]*%..*$")
end

function string.left(s, n)
	return s:sub(1, n)
end

local sizes = { "bytes", "kb", "mb", "gb", "tb", "pb", "eb", "zb", "yb" }

function string.niceSize(n, t)
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
			return (n / (1024 ^ i)) .. " " .. ((i + 1) > 1 and sizes[i + 1]:upper() or sizes[i + 1]:properCase())
		end
	end
end

local function replacement(a, b)
	return a:upper() .. b:lower()
end

function string.properCase(s)
	local str = s:gsub("(%a)([%w_']*)", replacement); return str
end

function string.replace(s, f, r)
	local str = s:gsub(f, r); return str
end

function string.right(s, n)
	return s:sub(#s - n + 1, #s)
end

function string.setChar(s, i, r)
	if i > #s or i < 1 then
		return s
	end

	return s:sub(1, i - 1) .. r .. s:sub(i + 1)
end

function string.startsWith(s, e)
	return s:sub(1, #e) == e
end