local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local IconButton = Object:extend('IconButton')

function IconButton:new(yui, settings)
    self.yui = yui
    self.size = settings.size or 20
    self.name = settings.name
    self.x, self.y = 0, 0
    self.w, self.h = self.size, self.size
    self.hover = settings.hover
    self.hover_font = love.graphics.newFont(self.yui.Theme.open_sans_light, math.floor(math.max(self.size, 40)*0.4))
    self.button = self.yui.UI.Button(0, 0, self.size, self.size, {
        yui = self.yui,
        extensions = {self.yui.Theme.IconButton},
        icon = self.yui.Theme.font_awesome[settings.icon], 
        font = love.graphics.newFont(self.yui.Theme.font_awesome_path, settings.size),
        parent = self,
    })
    self.onClick = settings.onClick
end

function IconButton:update(dt)
    if self.button.hot and self.button.released then
        if self.onClick then
            self:onClick()
        end
    end

    self.button.x, self.button.y = self.x, self.y
    self.button:update(dt)

    if self.button.hot then love.mouse.setCursor(self.yui.Theme.hand_cursor) end
end

function IconButton:draw()
    self.button:draw()
end

return IconButton
