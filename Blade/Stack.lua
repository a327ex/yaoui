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
        element.parent = self
        self[i] = element
        if element.name then self[element.name] = element end
    end
    if layout.right then
        self.right = {}
        for i, element in ipairs(layout.right) do
            element.parent = self
            self.right[i] = element
            if element.name then self[element.name] = element end
        end
    end
end

function Stack:update(dt)
    for _, element in ipairs(self.layout) do element:update(dt) end
    if self.layout.right then 
        for _, element in ipairs(self.layout.right) do element:update(dt) end
    end
end

function Stack:draw()
    for _, element in ipairs(self.layout) do element:draw() end
    if self.layout.right then 
        for _, element in ipairs(self.layout.right) do element:draw() end
    end
end

return Stack
