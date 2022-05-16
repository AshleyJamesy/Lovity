local floor = math.floor
local insert = table.insert
local rep = string.rep

local function clone(src)
	if type(src) == "table" then
		local dst = setmetatable({}, getmetatable(src))

		for k, v in pairs(src) do
			dst[k] = clone(v)
		end

		return dst
	end

	return src
end

function table.clone(src)
	return clone(src)
end

local function copy(src, deep)
	if type(src) == "table" then
		local dst = {}

		for k, v in pairs(src) do
			dst[k] = deep == true and copy(v) or v
		end

		return dst
	end

	return src
end

function table.copy(src, deep)
	return copy(src, deep)
end

function table.count(tbl)
	local i = 0

	for k in pairs(tbl) do 
		i = i + 1 
	end

	return i
end

function table.filter(tbl, method)
	local t = {}

	for k, v in pairs(tbl) do
		if method(v, k, tbl) == true then
			t[k] = v
		end
	end

	return t
end

function table.find(tbl, method)
	for k, v in pairs(tbl) do
		if method(v, k, tbl) == true then
			return v, k
		end
	end
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

function table.join(tbl, delim)
	local s = ""
	for k, v in pairs(tbl) do
		s = s .. tostring(v) .. delim
	end
	
	return s:left(#s - #delim)
end

function table.keys(tbl)
	local t = {}
	for k, v in pairs(tbl) do
		insert(t, k)
	end
	return t
end

local function merge(src, dst)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" then
			merge(dst[k], v)
		else
			dst[k] = v
		end
	end

	return dst
end

function table.merge(src, dst)
	return merge(src, dst)
end

function table.readOnly(tbl)
	return setmetatable(copy(tbl), {
		__index = tbl,
		__newindex = function(tbl, key, value)
			error("attempt to update a read-only table")
		end,
		__metatable = false, 
	});
end

local reference_mt = {
	__metatable = false, __mode = "v",

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
	return setmetatable({ reference = tbl }, reference_mt)
end

function table.search(tbl, target, method)
	local low, high, mid, obj = 1, #tbl, 0, nil

	if type(method) == "function" then
		while low <= high do
			mid = floor((low + high) / 2)
			obj = tbl[mid]

			if method(obj) < target then
				low = mid + 1
			elseif method(obj) > target then
				high = mid - 1
			else
				return obj, mid
			end
		end

		if low == 1 and high == 0 then
			return nil, 0
		end

		return nil, mid - (method(obj) > target and 1 or 0)
	else
		while low <= high do
			mid = floor((low + high) / 2)
			obj = tbl[mid]

			if obj < target then
				low = mid + 1
			elseif obj > target then
				high = mid - 1
			else
				return obj, mid
			end
		end

		if low == 1 and high == 0 then
			return nil, 0
		end

		return nil, mid - (obj > target and 1 or 0)
	end
end

local function __tostring(o, i)
	local i, output = i or 0, ""

	if type(o) == "table" then
		for k, v in pairs(o) do
			local key = tostring(k)

			if type(k) == "string" then
				key = "\"" .. tostring(k) .. "\""
			end

			if type(v) == "table" then
				output = output .. rep("\t", i)  .. key .. ":\n" .. __tostring(v, i + 1)
			else
				output = output .. rep("\t", i)  .. key .. ":" .. __tostring(v, i + 1) .. "\n"
			end
		end
	else
		local value

		if type(o) == "nil" then
			value = "nil"
		elseif type(o) == "string" then
			value = "\"" .. tostring(o) .. "\""
		else
			value = tostring(o)
		end

		output = rep("\t", i) .. value
	end

	return output
end

function table.tostring(tbl)
	return __tostring(tbl)
end

function table.values(tbl)
	local t = {}
	for k, v in pairs(tbl) do
		table.insert(t, v)
	end
	return t
end