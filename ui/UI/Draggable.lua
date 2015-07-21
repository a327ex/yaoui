local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Draggable = Object:extend('Draggable')

function Draggable:draggableNew(settings)
    local settings = settings or {}
    self.dragging = false
    self.drag_hot = false
    self.drag_enter = false
    self.drag_exit = false
    self.drag_start = false
    self.drag_end = false
    self.drag_margin = settings.drag_margin or self.h/4
    self.drag_x, self.drag_y = 0, 0
    self.drag_min_limit_x, self.drag_min_limit_y = settings.drag_min_limit_x, settings.drag_min_limit_y
    self.drag_max_limit_x, self.drag_max_limit_y = settings.drag_max_limit_x, settings.drag_max_limit_y
    self.only_drag_horizontally = settings.only_drag_horizontally
    self.only_drag_vertically = settings.only_drag_vertically
    self.previous_drag_hot = false
    self.drag_previous_mouse_position = nil
end

function Draggable:draggableUpdate(dt, parent)
    local x, y = self.getMousePosition()

    if self.draggable then
        -- Check for drag_hot
        if self.hot and x >= self.x and x <= (self.x + self.w) and y >= self.y and y <= (self.y + self.drag_margin) then
            self.drag_hot = true
        else self.drag_hot = false end

        -- Check for drag_enter
        if self.drag_hot and not self.previous_drag_hot then
            self.drag_enter = true
        else self.drag_enter = false end

        -- Check for drag_exit
        if not self.drag_hot and self.previous_drag_hot then
            self.drag_exit = true
        else self.drag_exit = false end

        self.drag_start = false
        self.drag_end = false
    end

    -- Drag
    if self.drag_hot and self.input:pressed('left-click') then
        self.dragging = true
        self.drag_start = true
    end
    -- Resizing has precedence over dragging
    if self.dragging and not self.resizing and self.input:down('left-click') then
        local dx, dy = x - self.drag_previous_mouse_position.x, y - self.drag_previous_mouse_position.y
        local parent_x, parent_y = 0, 0
        if parent then parent_x, parent_y = parent.x, parent.y end
        if self.only_drag_horizontally or (not self.only_drag_horizontally and not self.only_drag_vertically) then 
            self.drag_x = self.drag_x + dx
            if self.drag_min_limit_x then 
                if (parent_x + self.ix + self.drag_x) < self.drag_min_limit_x then
                    self.drag_x = self.drag_x - dx
                end
            end
            if self.drag_max_limit_x then 
                if (parent_x + self.ix + self.drag_x) > self.drag_max_limit_x then
                    self.drag_x = self.drag_x - dx
                end
            end
        end
        if self.only_drag_vertically or (not self.only_drag_vertically and not self.only_drag_horizontally) then 
            self.drag_y = self.drag_y + dy
            if self.drag_min_limit_y then
                if (parent_y + self.iy + self.drag_y) < self.drag_min_limit_y then
                    self.drag_y = self.drag_y - dy
                end
            end
            if self.drag_max_limit_y then
                if (parent_y + self.iy + self.drag_y) > self.drag_max_limit_y then
                    self.drag_y = self.drag_y - dy
                end
            end
        end
    end
    if self.dragging and self.input:released('left-click') then
        self.dragging = false
        self.drag_end = true
    end

    if parent then self.x, self.y = parent.x + self.ix + self.drag_x + (self.resize_x or 0), parent.y + self.iy + self.drag_y + (self.resize_y or 0)
    else self.x, self.y = self.ix + self.drag_x + (self.resize_x or 0), self.iy + self.drag_y + (self.resize_y or 0) end

    -- Set previous frame state
    self.previous_drag_hot = self.drag_hot
    self.drag_previous_mouse_position = {x = x, y = y}
end

function Draggable:setDragLimits(x_min, y_min, x_max, y_max)
    self.drag_min_limit_x = x_min
    self.drag_min_limit_y = y_min
    self.drag_max_limit_x = x_max
    self.drag_max_limit_y = y_max
end

return Draggable
