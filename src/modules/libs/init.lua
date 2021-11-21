local MODULES, MODULE = (...):match("(.-)[^%.]+$"), (...) .. "."

ansicolour = require(MODULE .. "ansicolour")
class = require(MODULE .. "class")
obj = require(MODULE .. "obj")
net = require(MODULE .. "net")