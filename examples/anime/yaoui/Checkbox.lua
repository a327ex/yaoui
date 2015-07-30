local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Checkbox = Object:extend('Checkbox')

function Checkbox:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.name = settings.name
    self.size = settings.size or 20
    self.checked = settings.checked
    self.text = settings.text
    self.icon = self.yui.Theme.font_awesome['fa-check'] 
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_regular, math.floor(self.size*0.7))
    self.font:setFallbacks(love.graphics.newFont(self.yui.Theme.font_awesome_path, math.floor(self.size*0.7)))
    self.w = self.font:getWidth(self.icon .. self.text) + self.size
    self.h = self.font:getHeight() + math.floor(self.size*0.7)
    self.checkbox = self.yui.UI.Checkbox(0, 0, self.w, self.h, {
        yui = self.yui,
        extensions = {self.yui.Theme.Checkbox},
        icon = self.yui.Theme.font_awesome['fa-check'],
        font = self.font,
        parent = self,
        text = self.text,
        checked = self.checked,
    })
    self.onClick = settings.onClick
end

function Checkbox:update(dt)
    if self.checkbox.hot and self.checkbox.released then
        if self.onClick then
            self:onClick()
        end
    end
    
    self.checkbox.x, self.checkbox.y = self.x, self.y
    self.checkbox:update(dt)

    self.checked = self.checkbox.checked
    if self.checkbox.hot then love.mouse.setCursor(self.yui.Theme.hand_cursor) end
end

function Checkbox:draw()
    self.checkbox:draw()
end

return Checkbox
