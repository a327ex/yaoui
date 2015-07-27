local yaoui_path = ... .. '.'

local yaoui = {}
yaoui.UI = require(yaoui_path .. 'UI')
yaoui.Theme = require(yaoui_path .. 'YaouiTheme')
yaoui.Timer = require(yaoui_path .. 'Timer')

local View = require(yaoui_path .. 'View')
yaoui.View = function(...) return View(yaoui, ...) end
local Stack = require(yaoui_path .. 'Stack')
yaoui.Stack = function(...) return Stack(yaoui, ...) end
local Flow = require(yaoui_path .. 'Flow')
yaoui.Flow = function(...) return Flow(yaoui, ...) end

local Button = require(yaoui_path .. 'Button')
yaoui.Button = function(...) return Button(yaoui, ...) end
local Checkbox = require(yaoui_path .. 'Checkbox')
yaoui.Checkbox = function(...) return Checkbox(yaoui, ...) end
local Dropdown = require(yaoui_path .. 'Dropdown')
yaoui.Dropdown = function(...) return Dropdown(yaoui, ...) end
local FlatDropdown = require(yaoui_path .. 'FlatDropdown')
yaoui.FlatDropdown = function(...) return FlatDropdown(yaoui, ...) end
local HorizontalSeparator = require(yaoui_path .. 'HorizontalSeparator')
yaoui.HorizontalSeparator = function(...) return HorizontalSeparator(yaoui, ...) end
local IconButton = require(yaoui_path .. 'IconButton')
yaoui.IconButton = function(...) return IconButton(yaoui, ...) end
local Text = require(yaoui_path .. 'Text')
yaoui.Text = function(...) return Text(yaoui, ...) end

return yaoui
