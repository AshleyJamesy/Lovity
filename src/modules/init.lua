local MODULES = (...):match("(.-)[^%.]+$")

bit = require "bit"
ffi = require "ffi"
jit = require "jit"

require(MODULES .. "extensions")
require(MODULES .. "libs")