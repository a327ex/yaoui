local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local ImageButton = Object:extend('ImageButton')

function ImageButton:new(yui, settings)
    self.yui = yui

end

function ImageButton:update(dt)

end

function ImageButton:draw()

end

return ImageButton
