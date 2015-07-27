local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Textinput = Object:extend('Textinput')

function Textinput:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.name = settings.name
    self.size = settings.size or 20
    self.default_text = settings.default_text or ''
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_semibold, math.floor(self.size*0.7))
    self.w = settings.w or 100 + 2*self.size
    self.h = self.font:getHeight() + math.floor(self.size)*0.7
    self.textarea = self.yui.UI.Textarea(0, 0, self.w, self.h, {
        yui = self.yui,
        font = self.font,
        parent = self,
        extensions = {self.yui.Theme.Textinput},
        single_line = true,
    })
end

function Textinput:update(dt)
    self.textarea.x, self.textarea.y = self.x, self.y
    self.textarea.text_base_x, self.textarea.text_base_y = self.x + self.textarea.text_margin, self.y + self.textarea.text_margin
    self.textarea:update(dt)
end

function Textinput:draw()
    self.textarea:draw()
end

return Textinput
