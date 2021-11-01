class.name = "ui.option"

function class.option(option, value)
	return function(options)
		options[option] = value
	end
end

function class.width(value)
	return function(options)
		options.width = value
	end
end

function class.height(value)
	return function(options)
		options.height = value
	end
end

function class.minWidth(value)
	return function(options)
		options.width_min = value
	end
end

function class.maxWidth(value)
	return function(options)
		options.width_max = value
	end
end

function class.minHeight(value)
	return function(options)
		options.height_min = value
	end
end

function class.maxHeight(value)
	return function(options)
		options.height_max = value
	end
end

function class.expandWidth(bool)
	return function(options)
		options.width_expand = bool
	end
end

function class.expandHeight(bool)
	return function(options)
		options.height_expand = bool
	end
end

function class.padding(w, h)
	return function(options)
		options.padding_width 	= w
		options.padding_height 	= h
	end
end

function class.paddingWidth(value)
	return function(options)
		options.padding_width = value
	end
end

function class.paddingHeight(value)
	return function(options)
		options.padding_height = value
	end
end

function class.align(alignment)
	return function(options)
		options.align = alignment
	end
end

function class.draw(draw_func)
	return function(options)
		options.draw = draw_func
	end
end