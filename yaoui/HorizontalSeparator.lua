local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local HorizontalSeparator = Object:extend('HorizontalSeparator')

function HorizontalSeparator:new(yui, settings)
    self.yui = yui
    self.name = settings.name
    self.x, self.y = 0, 0
    self.size = settings.size or 20
    self.w, self.h = settings.w, self.size
    self.margin_left = settings.margin_left or 0
    self.margin_right = settings.margin_right or 0
end

function HorizontalSeparator:update(dt)

end

function HorizontalSeparator:draw()
    self.yui.Theme.HorizontalSeparator.draw(self)
end

return HorizontalSeparator
