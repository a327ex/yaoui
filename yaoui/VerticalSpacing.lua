local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local VerticalSpacing = Object:extend('VerticalSpacing')

function VerticalSpacing:new(yui, settings)
    self.yui = yui
    self.name = settings.name
    self.x, self.y = 0, 0
    self.size = settings.size or 20
    self.w, self.h = self.size, settings.h
end

function VerticalSpacing:update(dt)

end

function VerticalSpacing:draw()
    self.yui.Theme.VerticalSpacing.draw(self)
end

return VerticalSpacing
