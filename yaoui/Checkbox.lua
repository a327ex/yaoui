local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Checkbox = Object:extend('Checkbox')

function Checkbox:new(yui, settings)
    self.yui = yui
    self.checked = settings.checked

end

function Checkbox:update(dt)

end

function Checkbox:draw()

end

return Checkbox
