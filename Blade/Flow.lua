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
        if element.class_name == 'Flow' then error("Flows cannot have Flows as their children") end
        element.parent = self
        self[i] = element
        if element.name then self[element.name] = element end
    end
    if layout.right then
        self.right = {}
        for i, element in ipairs(layout.right) do
            if element.class_name == 'Flow' then error("Flows cannot have Flows as their children") end
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

function Flow:build(x, y, w, h)
    self.x, self.y = x, y
    self.w, self.h = self.layout.w or w, self.layout.h or h

    -- Build children
    local add_x, add_y = 0, 0
    for _, element in ipairs(self.layout) do
        if element.class_name == 'Stack' then
            local stack = element:build(self.x + self.margin_left + add_x, self.y + self.margin_top + add_y, 
                                        self.w - self.margin_left - self.margin_right, self.h - self.margin_top - self.margin_bottom)
            add_x = add_x + stack.w + self.spacing
        elseif element.class_name == 'Flow' then
            local flow = element:build(self.x + self.margin_left + add_x, self.y + self.margin_top + add_y, 
                                       self.w - self.margin_left - self.margin_right, self.h - self.margin_top - self.margin_bottom)
            add_y = add_y + flow.h + self.spacing
        end
    end

    -- Set height
    local min = 0
    for _, element in ipairs(self.layout) do
        if element.h > min then min = element.h end
    end
    if self.layout.right then
        for _, element in ipairs(self.layout.right) do
            if element.h > min then min = element.h end
        end
    end
    self.h = self.layout.h or (min + self.margin_top + self.margin_bottom)

    -- Set children positions
    self:setChildrenPositions(self.x, self.y, self.w, self.h)

    -- Reset child Stack and Flow children positions
    for _, element in ipairs(self.layout) do
        if element.class_name == 'Stack' or element.class_name == 'Flow' then
            element:setChildrenPositions(self.x, self.y, self.w, self.h)
        end
    end

    return self
end

function Flow:setChildrenPositions(x, y, w, h)
    local w = 0
    for i, element in ipairs(self.layout) do 
        element.x = self.x + self.margin_left + w + (i-1)*self.spacing
        element.y = self.y + self.margin_top
        w = w + element.w
    end
    if self.layout.right then
        local w = 0
        for i = #self.layout.right , 1, -1 do
            local element = self.layout.right[i]
            element.x = self.x + self.margin_left + self.w - self.margin_right - element.w - (#self.layout.right - i)*self.spacing - w
            element.y = self.y + self.margin_top
            w = w + element.w
        end
    end
end

return Flow
