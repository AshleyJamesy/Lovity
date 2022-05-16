local MODULES, MODULE = (...):match("(.-)[^%.]+$"), (...) .. "."

require(MODULE .. "math")
require(MODULE .. "string")
require(MODULE .. "table")