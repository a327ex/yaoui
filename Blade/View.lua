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

    -- Set parents
    self.layout[1].parent = self

    -- Set names
    if self.layout[1].name then self[self.layout[1].name] = self.layout[1] end
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
end

return View
