local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Flow = Object:extend('Flow')

function Flow:new(yui, layout)
    if not layout then error('No layout specified') end
    self.yui = yui
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

    -- Default settings
    self.margin_left = layout.margin_left or 0
    self.margin_top = layout.margin_top or 0
    self.margin_right = layout.margin_right or 0
    self.margin_bottom = layout.margin_bottom or 0
    self.spacing = layout.spacing or 8
end

function Flow:update(dt)
    for _, element in ipairs(self.layout) do element:update(dt) end
    if self.layout.right then 
        for _, element in ipairs(self.layout.right) do element:update(dt) end
    end
end

function Flow:draw()
    for _, element in ipairs(self.layout) do element:draw() end
    if self.layout.right then 
        for _, element in ipairs(self.layout.right) do element:draw() end
    end

    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

return Flow
