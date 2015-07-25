local foo_path = ... .. '.'

local foo = {}
foo.UI = require(foo_path .. 'UI')
foo.Theme = require(foo_path .. 'fooTheme')
foo.Timer = require(foo_path .. 'Timer')
foo.font_awesome = require(foo_path .. 'FontAwesome')
foo.font_awesome_path = foo_path:gsub("%.", "/") .. 'fonts/fontawesome-webfont.ttf'

local View = require(foo_path .. 'View')
foo.View = function(...) return View(foo, ...) end
local Stack = require(foo_path .. 'Stack')
foo.Stack = function(...) return Stack(foo, ...) end
local Flow = require(foo_path .. 'Flow')
foo.Flow = function(...) return Flow(foo, ...) end

local IconButton = require(foo_path .. 'IconButton')
foo.IconButton = function(...) return IconButton(foo, ...) end

return foo
