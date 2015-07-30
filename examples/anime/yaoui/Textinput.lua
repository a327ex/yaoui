local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Textinput = Object:extend('Textinput')

function Textinput:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.name = settings.name
    self.size = settings.size or 20
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_semibold, math.floor(self.size*0.7))
    self.w = settings.w or 100 + 2*self.size
    self.h = self.font:getHeight() + math.floor(self.size*0.7)
    self.textarea = self.yui.UI.Textarea(0, 0, self.w, self.h, {
        yui = self.yui,
        font = self.font,
        parent = self,
        extensions = {self.yui.Theme.Textinput},
        single_line = true,
    })
    self.h = self.textarea.h

    self.onEnter = settings.onEnter
end

function Textinput:update(dt)
    if self.textarea.input:pressed('enter') then
        if self.onEnter then
            self:onEnter(self.textarea:getText())
        end
    end

    self.textarea.x, self.textarea.y = self.x, self.y
    self.h = self.textarea.h
    self.textarea.text_base_x, self.textarea.text_base_y = self.x + self.textarea.text_margin, self.y + self.textarea.text_margin
    self.textarea:update(dt)

    if self.textarea.hot then love.mouse.setCursor(self.yui.Theme.ibeam) end
end

function Textinput:draw()
    self.textarea:draw()
end

function Textinput:setText(text)
    self.textarea:setText(text)
end

return Textinput
