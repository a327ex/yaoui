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

function Stack:build(x, y, w, h)
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

    -- Set width
    local min = 0
    for _, element in ipairs(self.layout) do
        if element.class_name ~= 'Stack' and element.class_name ~= 'Flow' then
            if element.w > min then min = element.w end
        end
    end
    if self.layout.bottom then
        for _, element in ipairs(self.layout.bottom) do
            if element.class_name ~= 'Stack' and element.class_name ~= 'Flow' then
                if element.w > min then min = element.w end
            end
        end
    end
    self.w = self.layout.w or (min + self.margin_left + self.margin_right)

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

function Stack:setChildrenPositions(x, y, w, h)
    local h = 0
    for i, element in ipairs(self.layout) do 
        element.x = self.x + self.margin_left
        element.y = self.y + self.margin_top + h + (i-1)*self.spacing
        h = h + element.h
    end
    if self.layout.bottom then
        local h = 0
        for i = #self.layout.bottom, 1, -1 do
            local element = self.layout.bottom[i]
            element.x = self.x + self.margin_left
            element.y = self.y + self.margin_top + self.h - self.margin_bottom - element.h - (#self.layout.bottom - i)*self.spacing - h
            h = h + element.h
        end
    end
end

return Stack
