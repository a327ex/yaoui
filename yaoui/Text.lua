local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Text = Object:extend('Text')

function Text:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.text = settings.text or ''
    self.size = settings.size or 20
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_regular, math.floor(self.size*0.7))
    self.w = self.font:getWidth(self.text) + self.size
    self.h = self.font:getHeight() + math.floor(self.size*0.7)
end

function Text:update(dt)

end

function Text:draw()
    self.yui.Theme.Text.draw(self)
end

return Text
