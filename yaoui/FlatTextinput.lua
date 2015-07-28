local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local FlatTextinput = Object:extend('FlatTextinput')

function FlatTextinput:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.name = settings.name
    self.size = settings.size or 20
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_regular, math.floor(self.size*0.7))
    self.w = settings.w or 100 + 2*self.size
    self.h = self.font:getHeight() + math.floor(self.size*0.7)
    self.textarea = self.yui.UI.Textarea(0, 0, self.w, self.h, {
        yui = self.yui,
        font = self.font,
        parent = self,
        extensions = {self.yui.Theme.FlatTextinput},
        single_line = true,
    })
    self.h = self.textarea.h
end

function FlatTextinput:update(dt)
    self.textarea.x, self.textarea.y = self.x, self.y
    self.textarea.text_base_x, self.textarea.text_base_y = self.x + self.textarea.text_margin, self.y + self.textarea.text_margin
    self.textarea:update(dt)
end

function FlatTextinput:draw()
    self.textarea:draw()
end

return FlatTextinput
