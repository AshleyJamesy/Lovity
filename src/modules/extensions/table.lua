function table.count(tbl)
	local i = 0

	for k in pairs(tbl) do 
		i = i + 1 
	end

	return i
end

function table.merge(src, dst)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" then
			table.merge(dst[k], v)
		else
			dst[k] = v
		end
	end

	return dst
end

function table.readOnly(tbl)
	return setmetatable({}, {
		__index = tbl,
		__newindex = function(tbl, key, value)
			error("attempt to update a read-only table")
		end,
		__metatable = false
	});
end

function table.copy(src)
	if type(src) == "table" then
		local tbl = {}
		setmetatable(tbl, getmetatable(src))

		for k, v in pairs(src) do
			tbl[k] = table.Copy(src[k])
		end

		return tbl
	end

	return src
end

function table.clone(tbl)
	return { unpack(tbl) }
end

function table.hasKey(tbl, key)
	for k, v in pairs(tbl) do
		if k == key then 
			return true, k, v
		end
	end

	return false, nil
end

function table.hasValue(tbl, value)
	for k, v in pairs(tbl) do
		if v == value then 
			return true, v, k
		end
	end

	return false, nil
end

function table.tostring(o, i)
	local i, output = i or 0, ""

	if type(o) == "table" then
		for k, v in pairs(o) do
			if type(v) == "table" then
				output = output .. string.rep("\t", i)  .. tostring(k) .. ":\n" .. table.tostring(v, i + 1)
			else
				output = output .. string.rep("\t", i)  .. tostring(k) .. ":" .. table.tostring(v, i + 1) .. "\n"
			end
		end
	else
		if type(o) == "string" then
			output = string.rep("\t", i) .. tostring(o)
		else
			output = string.rep("\t", i) .. tostring(o)
		end
	end

	return output
end

function table.dump(o, i, d)
	local d, i, output 	= d or 1, i or 0, ""

	if type(o) == "table" then
		output = "{\n"

		for k, v in pairs(o) do
			if type(k) == "table" then
				k = tostring(k)
			end

			if i > d then
				output = output .. string.rep("	", i + 1) .. k .. " = " .. tostring(v)
			else
				output = output .. string.rep("	", i + 1) .. k .. " = " .. table.dump(v, i + 1, d)
			end
		end

		output = output .. string.rep("	", i) .. "}"
	else
		if type(o) == "string" then
			output = "\"" .. tostring(o) .. "\""
		else
			output = tostring(o)
		end
	end

	return output .. "\n"
end