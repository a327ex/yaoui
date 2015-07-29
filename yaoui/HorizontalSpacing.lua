local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local HorizontalSpacing = Object:extend('HorizontalSpacing')

function HorizontalSpacing:new(yui, settings)
    self.yui = yui
    self.name = settings.name
    self.x, self.y = 0, 0
    self.size = settings.size or 20
    self.w, self.h = settings.w, self.size
end

function HorizontalSpacing:update(dt)

end

function HorizontalSpacing:draw()
    self.yui.Theme.HorizontalSpacing.draw(self)
end

return HorizontalSpacing
