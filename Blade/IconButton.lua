local blade_path = (...):match('(.-)[^%.]+$')
local Object = require(blade_path .. 'UI.classic.classic')
local IconButton = Object:extend('IconButton')

function IconButton:new(blade, settings)
    self.blade = blade
    self.size = settings.size
    self.name = settings.name
    self.x, self.y = 0, 0
    self.w, self.h = self.size, self.size
    self.button = self.blade.UI.Button(0, 0, self.size, self.size, {
        blade = self.blade,
        extensions = {self.blade.Theme.IconButton},
        icon = self.blade.font_awesome[settings.icon], 
        font = love.graphics.newFont(self.blade.font_awesome_path, settings.size)
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
end

function IconButton:draw()
    self.button:draw()
end

return IconButton
