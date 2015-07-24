local blade_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(blade_path .. 'UI.classic.classic')
local View = Object:extend('View')

function View:new(blade, x, y, w, h, layout)
    if not layout then error('No layout specified') end
    self.blade = blade
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.layout = layout 

    if not self.layout[1] or (self.layout[1] and self.layout[1].class_name ~= 'Stack' and self.layout[1].class_name ~= 'Flow') then
        error('View must have a Stack or Flow as its first element') 
    end

    -- Set parents and names
    self.layout[1].parent = self
    if self.layout[1].name then self[self.layout[1].name] = self.layout[1] end

    -- Default settings
    self.margin_left = layout.margin_left or 8
    self.margin_top = layout.margin_top or 8
    self.margin_right = layout.margin_right or 8
    self.margin_bottom = layout.margin_bottom or 8

    -- Set child position and size
    self.layout[1].x, self.layout[1].y = self.x + self.margin_left, self.y + self.margin_top
    self.layout[1].w = self.w - self.margin_left - self.margin_right
    self.layout[1].h = self.h - self.margin_top - self.margin_bottom

    -- Build child
    self.layout[1]:build(self.x + self.margin_left, self.y + self.margin_top, self.w - self.margin_left - self.margin_right, self.h - self.margin_top - self.margin_bottom)
end

function View:update(dt)
    self.layout[1]:update(dt)
    if self.layout.overlay then 
        for _, element in ipairs(self.layout.overlay) do
            element:update(dt)
        end
    end
end

function View:draw()
    self.layout[1]:draw()
    if self.layout.overlay then
        for _, element in ipairs(self.layout.overlay) do
            element:draw()
        end
    end

    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

return View
