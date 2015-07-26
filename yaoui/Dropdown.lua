local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Dropdown = Object:extend('Dropdown')

function Dropdown:new(yui, settings)
    self.yui = yui

end

function Dropdown:update(dt)

end

function Dropdown:draw()

end

return Dropdown
