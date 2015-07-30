local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local VerticalSeparator = Object:extend('VerticalSeparator')

function VerticalSeparator:new(yui, settings)
    self.yui = yui
    self.name = settings.name
    self.x, self.y = 0, 0
    self.size = settings.size or 20
    self.w, self.h = self.size, settings.h
    self.margin_top = settings.margin_top or 0
    self.margin_bottom = settings.margin_bottom or 0
end

function VerticalSeparator:update(dt)

end

function VerticalSeparator:draw()
    self.yui.Theme.VerticalSeparator.draw(self)
end

return VerticalSeparator
