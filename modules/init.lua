local MODULES = (...):match("(.-)[^%.]+$")

bit = require "bit"
ffi = require "ffi"
jit = require "jit"
enet = require "enet"
socket = require "socket"

require(MODULES .. "extensions")

ansicolour = require(MODULES .. "ansicolour")
ini = require(MODULES .. "ini")
sqlite3 = require(MODULES .. "sqlite3")
obj = require(MODULES .. "obj")
class = require(MODULES .. "class")