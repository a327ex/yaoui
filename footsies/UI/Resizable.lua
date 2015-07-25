local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Resizable = Object:extend('Resizable')

function Resizable:resizableNew(settings)
    local settings = settings or {}
    self.resizing = false
    self.resize_hot = false
    self.resize_enter = false
    self.resize_exit = false
    self.resize_start = false
    self.resize_end = false
    self.resize_corner = settings.resize_corner
    self.resize_corner_width = settings.resize_corner_width or 0
    self.resize_corner_height = settings.resize_corner_height or 0
    self.resize_margin_top = settings.resize_margin_top or 0 
    self.resize_margin_bottom = settings.resize_margin_bottom or 0 
    self.resize_margin_right = settings.resize_margin_right or 0 
    self.resize_margin_left = settings.resize_margin_left or 0 
    self.min_width = settings.min_width
    self.min_height = settings.min_height
    self.max_width = settings.max_width 
    self.max_height = settings.max_height
    self.resize_drag_x, self.resize_drag_y = nil, nil
    self.resize_x, self.resize_y = 0, 0
    self.resize_previous_mouse_position = nil
    self.previous_resize_hot = false
    self.only_resize_horizontally = settings.only_resize_horizontally
    self.only_resize_vertically = settings.only_resize_vertically
end

function Resizable:resizableUpdate(dt, parent)
    local x, y = self.getMousePosition()
    local sax, say, aw, ah = self.x_offset or 0, self.y_offset or 0, self.area_width or self.w, self.area_height or self.h
    local horizontal = self.only_resize_horizontally or (not self.only_resize_horizontally and not self.only_resize_vertically)
    local vertical = self.only_resize_vertically or (not self.only_resize_horizontally and not self.only_resize_vertically)
    if self.resize_corner then 
        self.resize_margin_top = self.resize_corner_height 
        self.resize_margin_bottom = self.resize_corner_height 
        self.resize_margin_right = self.resize_corner_width 
        self.resize_margin_left = self.resize_corner_width 
    end

    if self.resizable then
        -- Check for resize_hot
        self.resize_hot = false
        self.resize_start = false
        self.resize_end = false

        -- Only resize on corners
        if self.resize_corner then
            local rw, rh = self.resize_corner_width, self.resize_corner_height
            if self.resize_corner == 'top-left' then
                if (x >= (self.x + sax) and x <= (self.x + sax + rw) and y >= (self.y + say) and y <= (self.y + say + rh)) then
                    self.resize_hot = true
                end
            elseif self.resize_corner == 'top-right' then
                if (x >= (self.x + sax + aw - rw) and x <= (self.x + sax + aw) and y >= (self.y + say) and y <= (self.y + say + rh)) then
                    self.resize_hot = true
                end
            elseif self.resize_corner == 'bottom-left' then
                if (x >= (self.x + sax) and x <= (self.x + sax + rw) and y >= (self.y + say + ah - rh) and y <= (self.y + say + ah)) then
                    self.resize_hot = true
                end
            elseif self.resize_corner == 'bottom-right' then
                if (x >= (self.x + sax + aw - rw) and x <= (self.x + sax + aw) and y >= (self.y + say + ah - rh) and y <= (self.y + say + ah)) then
                    self.resize_hot = true
                end
            end
        -- Resize on all margins
        else
            if horizontal then
                if (x >= (self.x + sax) and x <= (self.x + sax + self.resize_margin_left) and y >= (self.y + say) and y <= (self.y + say + ah)) or
                   (x >= (self.x + sax + aw - self.resize_margin_right) and x <= (self.x + sax + aw) and y >= (self.y + say) and y <= (self.y + say + ah)) then
                    self.resize_hot = true 
                end
            end
            if vertical then
                if (x >= (self.x + sax) and x <= (self.x + sax + aw) and y >= (self.y + say) and y <= (self.y + say + self.resize_margin_top)) or
                   (x >= (self.x + sax) and x <= (self.x + sax + aw) and y >= (self.y + say + ah - self.resize_margin_bottom) and y <= (self.y + say + ah)) then
                    self.resize_hot = true 
                end
            end
        end

        -- Check for resize_enter
        if self.resize_hot and not self.previous_resize_hot then
            self.resize_enter = true
        else self.resize_enter = false end

        -- Check for resize_exit
        if not self.resize_hot and self.previous_resize_hot then
            self.resize_exit = true
        else self.resize_exit = false end
    end

    if self.resize_hot and self.input:pressed('left-click') then
        self.resizing = true
        self.resize_start = true
        if horizontal then
            if (x >= (self.x + sax) and x <= (self.x + sax + self.resize_margin_left) and y >= (self.y + say) and y <= (self.y + say + ah)) then self.resize_drag_x = -1 end
            if (x >= (self.x + sax + aw - self.resize_margin_right) and x <= (self.x + sax + aw) and y >= (self.y + say) and y <= (self.y + say + ah)) then self.resize_drag_x = 1 end
        end
        if vertical then
            if (x >= (self.x + sax) and x <= (self.x + sax + aw) and y >= (self.y + say) and y <= (self.y + say + self.resize_margin_top)) then self.resize_drag_y = -1 end
            if (x >= (self.x + sax) and x <= (self.x + sax + aw) and y >= (self.y + say + ah - self.resize_margin_bottom) and y <= (self.y + say + ah)) then self.resize_drag_y = 1 end
        end
    end

    if self.resizing and self.input:down('left-click') then
        local dx, dy = x - self.resize_previous_mouse_position.x, y - self.resize_previous_mouse_position.y
        if horizontal then
            if self.resize_drag_x == -1 then self.resize_x = self.resize_x + dx end
            if self.resize_drag_x then 
                self.w = self.w + self.resize_drag_x*dx
                if self.min_width then self.w = math.max(self.w, self.min_width) end
                if self.max_width then self.w = math.min(self.w, self.max_width) end
            end
        end
        if vertical then
            if self.resize_drag_y == -1 then self.resize_y = self.resize_y + dy end
            if self.resize_drag_y then 
                self.h = self.h + self.resize_drag_y*dy
                if self.min_height then self.h = math.max(self.h, self.min_height) end
                if self.max_height then self.h = math.min(self.h, self.max_height) end
            end
        end
    end

    if not self.draggable then 
        if self.parent then self.x, self.y = parent.x + self.ix + self.resize_x, parent.y + self.iy + self.resize_y
        else self.x, self.y = self.ix + self.resize_x, self.iy + self.resize_y end
    end

    if self.resizing and self.input:released('left-click') then
        self.resize_end = true
        self.resizing = false
        self.resize_drag_x = nil
        self.resize_drag_y = nil
    end

    -- Set previous frame state
    self.previous_resize_hot = self.resize_hot
    self.resize_previous_mouse_position = {x = x, y = y}
end

return Resizable
