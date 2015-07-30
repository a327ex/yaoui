local yui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(yui_path .. 'UI.classic.classic')
local View = Object:extend('View')

function View:new(yui, x, y, w, h, layout)
    if not layout then error('No layout specified') end
    self.yui = yui
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.layout = layout 
    self.name = self.layout.name

    if not self.layout[1] or (self.layout[1] and self.layout[1].class_name ~= 'Stack' and self.layout[1].class_name ~= 'Flow') then
        error('View must have a Stack or Flow as its first element') 
    end

    self[1] = self.layout[1]

    -- Set parents and names
    self.layout[1].parent = self
    if self.layout[1].name then self[self.layout[1].name] = self.layout[1] end

    -- Default settings
    self.margin_left = layout.margin_left or 0
    self.margin_top = layout.margin_top or 0
    self.margin_right = layout.margin_right or 0
    self.margin_bottom = layout.margin_bottom or 0

    -- Set child position and size
    self.layout[1].x, self.layout[1].y = self.x + self.margin_left, self.y + self.margin_top
    self.layout[1].w = self.w - self.margin_left - self.margin_right
    self.layout[1].h = self.h - self.margin_top - self.margin_bottom

    self:setElementSize(self.layout[1])
    self:setElementPosition(self.layout[1], self.x + self.margin_left, self.y + self.margin_top)
    self:reSetElementSize(self.layout[1], self)
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

    if self.layout[1].postDraw then self.layout[1]:postDraw() end

    if self.yui.debug_draw then
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end
end

function View:getAllElements()
    return self.layout[1]:getAllElements()
end

function View:setElementPosition(element, x, y)
    element.x, element.y = x, y

    if element.class_name == 'Stack' then
        local h = 0
        for i, e in ipairs(element.layout) do
            self:setElementPosition(e, element.x + element.margin_left, element.y + element.margin_top + h + (i-1)*element.spacing)
            h = h + e.h
        end
        if element.layout.bottom then
            h = 0
            for i = #element.layout.bottom, 1, -1 do
                local e = element.layout.bottom[i]
                self:setElementPosition(e, 
                                        element.x + element.margin_left, 
                                        element.y + element.h - element.parent.margin_top - element.margin_bottom - e.h - (#element.layout.bottom - i)*element.spacing - h)
                h = h + e.h
            end
        end

    elseif element.class_name == 'Flow' then
        local w = 0
        for i, e in ipairs(element.layout) do
            self:setElementPosition(e, element.x + element.margin_left + w + (i-1)*element.spacing, element.y + element.margin_top)
            w = w + e.w
        end
        if element.layout.right then
            w = 0
            for i = #element.layout.right, 1, -1 do
                local e = element.layout.right[i]
                self:setElementPosition(e, 
                                        element.x + element.w - element.parent.margin_left - element.margin_right - e.w - (#element.layout.right - i)*element.spacing - w,
                                        element.y + element.margin_top)
                w = w + e.w
            end
        end
    end
end

function View:reSetElementSize(element, parent)
    if element.class_name == 'Stack' then
        element.h = parent.y + parent.h - parent.margin_bottom - element.y
        if element.x + element.w > parent.x + parent.w - parent.margin_right then
            element.w = parent.x + parent.w - parent.margin_right - element.x
        end
        for _, e in ipairs(element.layout) do
            if e.class_name == 'Stack' or e.class_name == 'Flow' then
                self:reSetElementSize(e, element)
            end
        end
        if element.layout.bottom then
            for _, e in ipairs(element.layout.bottom) do
                if e.class_name == 'Stack' or e.class_name == 'Flow' then
                    self:reSetElementSize(e, element)
                end
            end
        end
    elseif element.class_name == 'Flow' then
        element.w = parent.x + parent.w - parent.margin_right - element.x
        if element.y + element.h > parent.y + parent.h - parent.margin_bottom then
            element.h = parent.y + parent.h - parent.margin_bottom - element.y
        end
        for _, e in ipairs(element.layout) do
            if e.class_name == 'Stack' or e.class_name == 'Flow' then
                self:reSetElementSize(e, element)
            end
        end
        if element.layout.right then
            for _, e in ipairs(element.layout.right) do
                if e.class_name == 'Stack' or e.class_name == 'Flow' then
                    self:reSetElementSize(e, element)
                end
            end
        end
    end
end

function View:setElementSize(element)
    if element.class_name == 'Stack' then
        for _, e in ipairs(element.layout) do
            if not e.w or not e.h then self:setElementSize(e) end
        end
        if element.layout.bottom then
            for _, e in ipairs(element.layout.bottom) do
                if not e.w or not e.h then self:setElementSize(e) end
            end
        end

        -- Set sizes 
        local min = 0
        for _, e in ipairs(element.layout) do
            if e.w > min then min = e.w end
        end
        if element.layout.bottom then
            for _, element in ipairs(element.layout.bottom) do
                if element.w > min then min = element.w end
            end
        end
        element.w = element.layout.w or (min + element.margin_left + element.margin_right)
        element.h = element.layout.h or self.h -- dummy

    elseif element.class_name == 'Flow' then
        for _, e in ipairs(element.layout) do
            if not e.w or not e.h then self:setElementSize(e) end
        end
        if element.layout.right then
            for _, e in ipairs(element.layout.right) do
                if not e.w or not e.h then self:setElementSize(e) end
            end
        end

        -- Set sizes 
        local min = 0
        for _, e in ipairs(element.layout) do
            if e.h > min then min = e.h end
        end
        if element.layout.right then
            for _, e in ipairs(element.layout.right) do
                if e.h > min then min = e.h end
            end
        end
        element.h = element.layout.h or (min + element.margin_top + element.margin_bottom)
        element.w = element.layout.w or self.w -- dummy
    end
end

return View
