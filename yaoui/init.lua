local yaoui_path = ... .. '.'

local yaoui = {}
yaoui.UI = require(yaoui_path .. 'UI')
yaoui.Theme = require(yaoui_path .. 'yaouiTheme')
yaoui.Timer = require(yaoui_path .. 'Timer')
yaoui.font_awesome = require(yaoui_path .. 'FontAwesome')
yaoui.font_awesome_path = yaoui_path:gsub("%.", "/") .. 'fonts/fontawesome-webfont.ttf'

local View = require(yaoui_path .. 'View')
yaoui.View = function(...) return View(yaoui, ...) end
local Stack = require(yaoui_path .. 'Stack')
yaoui.Stack = function(...) return Stack(yaoui, ...) end
local Flow = require(yaoui_path .. 'Flow')
yaoui.Flow = function(...) return Flow(yaoui, ...) end

local IconButton = require(yaoui_path .. 'IconButton')
yaoui.IconButton = function(...) return IconButton(yaoui, ...) end

return yaoui
