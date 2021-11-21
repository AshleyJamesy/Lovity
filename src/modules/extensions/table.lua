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

local floor = math.floor

function table.binarySearch(array, target, method)
	local low, high, mid, obj = 1, #array, 0, nil

	if type(method) == "function" then
		while low <= high do
			mid = floor((low + high) / 2)
			obj = array[mid]

			if method(obj) < method(target) then
				low = mid + 1
			elseif method(obj) > method(target) then
				high = mid - 1
			else
				return obj, mid
			end
		end
	else
		while low <= high do
			mid = floor((low + high) / 2)
			obj = array[mid]

			if obj < target then
				low = mid + 1
			elseif obj > target then
				high = mid - 1
			else
				return obj, mid
			end
		end
	end

	if low == 1 and high == 0 then
		return nil, 0
	end

	return nil, mid - (method(obj) > target and 1 or 0)
end

local weak_mt = {
	__metatable = "",
	__mode = "v",

	__index = function(tbl, key)
		local reference = rawget(tbl, "reference")
		if reference == nil then
			error("reference to table no longer exists", 2)
		end

		return reference[key]
	end,

	__newindex = function(tbl, key, value)
		local reference = rawget(tbl, "reference")
		if reference == nil then
			error("reference to table no longer exists", 2)
		end

		reference[key] = value
	end
}

function table.reference(tbl)
	return setmetatable({
		reference = tbl
	}, weak_mt)
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
		local dst = setmetatable({}, getmetatable(src))

		for k, v in pairs(src) do
			dst[k] = table.copy(v)
		end

		return dst
	end

	return src
end

function table.clone(src)
	local dst = {}
	for k, v in pairs(src) do
		dst[k] = v
	end

	return dst
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
	local d, i, output = d or 1, i or 0, ""

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