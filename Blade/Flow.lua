local blade_path = (...):match('(.-)[^%.]+$')
local Object = require(blade_path .. 'UI.classic.classic')
local Flow = Object:extend('Flow')

function Flow:new(blade, layout)
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
    if layout.bottom then
        self.bottom = {}
        for _, element in ipairs(layout.bottom) do
            element.parent = self
            self.bottom[i] = element
            if element.name then self[element.name] = element end
        end
    end
end

function Flow:update(dt)
    for _, element in ipairs(self.layout) do element:update(dt) end
    if self.layout.bottom then 
        for _, element in ipairs(self.layout.bottom) do element:update(dt) end
    end
end

function Flow:draw()
    for _, element in ipairs(self.layout) do element:draw() end
    if self.layout.bottom then 
        for _, element in ipairs(self.layout.bottom) do element:draw() end
    end
end

return Flow
