local function load(path)
	if path:getFilename():endsWith(".ini") then
		local contents = love.filesystem.read(path)

		if contents ~= nil then
			local output = {}; local target = output

			for _, line in pairs(contents:explode("\r\n")) do
				local section = line:match("^%[([^%[%]]+)%]$")
				if section == nil then
					section = line:match("^%[%]$") ~= nil and "" or nil
				end

				if section ~= nil then
					target = output

					if section ~= "" then
						for _, name in pairs(section:explode(".")) do
							if type(target[name]) ~= "table" then
								target[name] = {}
							end

							target = target[name]
						end
					end
				else
					local key, value = line:match("^([%w|_]+)%s-=%s-(.+)$")

					if key ~= nil and value ~= nil then
						if tonumber(value) then
							value = tonumber(value)
						elseif value == "true" then
							value = true
						elseif value == "false" then
							value = false
						end

						if tonumber(key) then
							key = tonumber(key)
						end

						target[key] = value
					end
				end
			end

			return output
		end
	end
end

return {
	load = load
}