local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Button = Object:extend('Button')

function Button:new(yui, settings)
    self.yui = yui
    self.text = settings.text or ''
    self.name = settings.name
    self.x, self.y = 0, 0
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_semibold, 16)
    self.w = self.font:getWidth(self.text) + 20
    self.h = self.font:getHeight() + 14
    self.button = self.yui.UI.Button(0, 0, self.w, self.h, {
        yui = self.yui,
        extensions = {self.yui.Theme.Button},
        font = self.font,
        text = self.text,
    })
    self.onClick = settings.onClick
end

function Button:update(dt)
    if self.button.hot and self.button.released then
        if self.onClick then
            self:onClick()
        end
    end

    self.button.x, self.button.y = self.x, self.y
    self.button:update(dt)
end

function Button:draw()
    self.button:draw()
end

return Button
