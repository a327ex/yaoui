local blade_path = ... .. '.'
local Blade = {}
Blade.UI = require(blade_path .. 'UI')
Blade.Theme = require(blade_path .. 'BladeTheme')
Blade.Timer = require(blade_path .. 'Timer')
Blade.font_awesome = require(blade_path .. 'FontAwesome')
Blade.font_awesome_path = blade_path:gsub("%.", "/") .. 'fonts/fontawesome-webfont.ttf'

local View = require(blade_path .. 'View')
Blade.View = function(...) return View(Blade, ...) end
local Stack = require(blade_path .. 'Stack')
Blade.Stack = function(...) return Stack(Blade, ...) end
local Flow = require(blade_path .. 'Flow')
Blade.Flow = function(...) return Flow(Blade, ...) end

local IconButton = require(blade_path .. 'IconButton')
Blade.IconButton = function(...) return IconButton(Blade, ...) end

return Blade
