local blade_path = (...):match('(.-)[^%.]+$')
local Object = require(blade_path .. 'UI.classic.classic')
local Stack = Object:extend('Stack')

function Stack:new(blade, layout)
    if not layout then error('No layout specified') end
    self.blade = blade
    self.layout = layout
    self.name = layout.name

    -- Set parents and names
    for i, element in ipairs(layout) do
        if element.class_name == 'Stack' then error("Stacks cannot have Stacks as their children") end
        element.parent = self
        self[i] = element
        if element.name then self[element.name] = element end
    end
    if layout.bottom then
        self.bottom = {}
        for i, element in ipairs(layout.bottom) do
            if element.class_name == 'Stack' then error("Stacks cannot have Stacks as their children") end
            element.parent = self
            self.bottom[i] = element
            if element.name then self[element.name] = element end
        end
    end

    -- Default settings
    self.margin_left = layout.margin_left or 0
    self.margin_top = layout.margin_top or 0
    self.margin_right = layout.margin_right or 0
    self.margin_bottom = layout.margin_bottom or 0
    self.spacing = layout.spacing or 8
end

function Stack:update(dt)
    for _, element in ipairs(self.layout) do element:update(dt) end
    if self.layout.bottom then 
        for _, element in ipairs(self.layout.bottom) do element:update(dt) end
    end
end

function Stack:draw()
    for _, element in ipairs(self.layout) do element:draw() end
    if self.layout.bottom then 
        for _, element in ipairs(self.layout.bottom) do element:draw() end
    end

    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

return Stack
