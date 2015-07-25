local foo_path = (...):match('(.-)[^%.]+$')
local Object = require(foo_path .. 'UI.classic.classic')
local IconButton = Object:extend('IconButton')

function IconButton:new(foo, settings)
    self.foo = foo
    self.size = settings.size
    self.name = settings.name
    self.x, self.y = 0, 0
    self.w, self.h = self.size, self.size
    self.button = self.foo.UI.Button(0, 0, self.size, self.size, {
        foo = self.foo,
        extensions = {self.foo.Theme.IconButton},
        icon = self.foo.font_awesome[settings.icon], 
        font = love.graphics.newFont(self.foo.font_awesome_path, settings.size)
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
