local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local ImageButton = Object:extend('ImageButton')

function ImageButton:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.settings = settings
    self.ix, self.iy = settings.ix or self.x, settings.iy or self.y
    self.rounded_corners = settings.rounded_corners
    self.name = settings.name
    self.img = settings.image
    self.w, self.h = settings.w or self.img:getWidth(), settings.h or self.img:getHeight()
    self.button = self.yui.UI.Button(0, 0, self.w, self.h, {
        yui = self.yui,
        extensions = {self.yui.Theme.ImageButton},
        parent = self,
    })
    self.onClick = settings.onClick
    self.overlay = settings.overlay or function(self)
        love.graphics.setColor(50, 50, 50, self.alpha/3)
        if self.rounded_corners then love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.h/18, self.h/18) 
        else love.graphics.rectangle('fill', self.x, self.y, self.w, self.h) end
        love.graphics.setColor(255, 255, 255, 255)
    end
    self.alpha = 0

    self.hover_color = settings.hover_color or {36, 104, 204}
end

function ImageButton:update(dt)
    self.ix, self.iy = self.settings.ix or self.x, self.settings.iy or self.y

    if self.button.hot and self.button.released then
        if self.onClick then
            self:onClick()
        end
    end

    self.button.x, self.button.y = self.x, self.y
    self.button:update(dt)
    self.alpha = self.button.alpha

    if self.button.hot then love.mouse.setCursor(self.yui.Theme.hand_cursor) end
end

function ImageButton:draw()
    self.button:draw()
end

return ImageButton
