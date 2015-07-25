local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Base = require(ui_path .. 'Base')
local Container = require(ui_path .. 'Container')
local Scrollarea = Object:extend('Scrollarea')
Scrollarea:implement(Base)
Scrollarea:implement(Container)

function Scrollarea:new(ui, x, y, w, h, settings)
    local settings = settings or {}
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Scrollarea'

    self:basePreNew(x, y, w, h, settings)
    self:containerNew(settings)
    self:bind('left', 'scroll-left')
    self:bind('right', 'scroll-right')
    self:bind('up', 'scroll-up')
    self:bind('down', 'scroll-down')

    self.x_offset, self.y_offset = 0, 0
    self.scroll_x, self.scroll_y = 0, 0
    self.scroll_button_width, self.scroll_button_height = settings.scroll_button_width or 15, settings.scroll_button_height or 15
    self.area_width, self.area_height = settings.area_width or self.w, settings.area_height or self.h
    self.show_scrollbars = settings.show_scrollbars
    self.vertical_step = settings.vertical_step or 5
    self.horizontal_step = settings.horizontal_step or 5 
    self.vertical_scrolling, self.horizontal_scrolling = false, false

    self.last_scroll_pressed_time = 0
    self.mouse_scrolling_x, self.mouse_scrolling_y = false, false
    self.last_drag_x, self.last_drag_y = 0, 0
    local bw, bh, extensions = self.scroll_button_width, self.scroll_button_height, settings.scrollbar_button_extensions
    self.vertical_scrollbar_top_button = self.ui.Button(self.area_width, 0, bw, bh, {extensions = extensions or {}, annotation = "Vertical scrollbar's top button"})
    self.vertical_scrollbar_bottom_button = self.ui.Button(self.area_width, self.area_height - bh, bw, bh, {extensions = extensions or {}, annotation = "Vertical scrollbar's bottom button"})
    self.horizontal_scrollbar_left_button = self.ui.Button(0, self.area_height, bw, bh, {extensions = extensions or {}, annotation = "Horizontal scrollbar's left button"})
    self.horizontal_scrollbar_right_button = self.ui.Button(self.area_width - bw, self.area_height, bw, bh, {extensions = extensions or {}, annotation = "Horizontal scrollbar's right button"})
    self.vertical_scrollbar_button = self.ui.Button(self.area_width, bh, bw, 0, {extensions = extensions or {}, annotation = "Vertical scrollbar button", 
                                                                                draggable = true, drag_margin = 0, only_drag_vertically = true})
    self.horizontal_scrollbar_button = self.ui.Button(self.scroll_button_width, self.area_height, 0, bh, {extensions = extensions or {}, annotation = "Horizontal scrollbar button",
                                                                                                          draggable = true, drag_margin = bh, only_drag_horizontally = true})

    self.dynamic_scroll_set = settings.dynamic_scroll_set
    if self.area_width < self.w then 
        self.horizontal_scrolling = true 
        self.horizontal_scrollbar_button.w = (self.area_width - 2*self.scroll_button_width)/(self.w/self.area_width)
    end
    if self.area_height < self.h then 
        self.vertical_scrolling = true 
        self.vertical_scrollbar_button.h = (self.area_height - 2*self.scroll_button_height)/(self.h/self.area_height)
        self.vertical_scrollbar_button.drag_margin = self.vertical_scrollbar_button.h
    end

    self:basePostNew()
end

function Scrollarea:update(dt, parent)
    self:basePreUpdate(dt, parent)
    local x, y = love.mouse.getPosition()
    local parent_x, parent_y = 0, 0
    if parent then parent_x, parent_y = parent.x, parent.y end

    if self.dynamic_scroll_set then
        if self.area_width < self.w then 
            self.horizontal_scrolling = true 
            self.horizontal_scrollbar_button.w = (self.area_width - 2*self.scroll_button_width)/(self.w/self.area_width)
        end
        if self.area_height < self.h then 
            self.vertical_scrolling = true 
            self.vertical_scrollbar_button.h = (self.area_height - 2*self.scroll_button_height)/(self.h/self.area_height)
            self.vertical_scrollbar_button.drag_margin = self.vertical_scrollbar_button.h
        end
    end

    self:containerUpdate(dt, parent)

    -- Only update elements with one of its corners inside the scroll area
    for _, element in ipairs(self.elements) do 
        local corners = {
            {x = element.x, y = element.y}, {x = element.x + element.w, y = element.y}, 
            {x = element.x, y = element.y + element.h}, {x = element.x + element.w, y = element.y + element.h}
        }
        for _, c in ipairs(corners) do
            if c.x >= self.x + self.x_offset and c.x <= self.x + self.area_width + self.x_offset and 
               c.y >= self.y + self.y_offset and c.y <= self.y + self.area_height + self.y_offset then
                element.inside_scroll_area = true
                break
            end
        end
    end

    -- Scrolling
    if self.show_scrollbars then
        if self.vertical_scrolling then
            -- Settings for vertical scrollbar button
            local h = self.area_height - 2*self.scroll_button_height
            self.vertical_scrollbar_button.h = math.floor(h/(self.h/h))
            self.vertical_scrollbar_button.drag_margin = self.vertical_scrollbar_button.h
            local max_y = self.y + self.y_offset + self.area_height - self.scroll_button_height - self.vertical_scrollbar_button.h
            self.vertical_scrollbar_button:setDragLimits(nil, self.y + self.y_offset + self.scroll_button_height, nil, max_y)

            -- Define is the user is scrolling with the slider or through steps
            if self.vertical_scrollbar_button.pressed then self.mouse_scrolling_y = true end
            if self.vertical_scrollbar_top_button.pressed or self.vertical_scrollbar_bottom_button.pressed or 
               self.input:pressed('scroll-up') or self.input:pressed('scroll-down') then 
                self.mouse_scrolling_y = false 
            end

            -- If using the slider, change the scrollarea's values accordingly
            if self.mouse_scrolling_y then
                self.y_offset = self.vertical_scrollbar_button.drag_y*(self.h - self.area_height)/(h - self.vertical_scrollbar_button.h)
                self.scroll_y = -self.y_offset
                for _, element in ipairs(self.elements) do element:update(0, self) end
            end

            -- Change the scrollbar's position according to the scrollarea's values
            self.vertical_scrollbar_button.drag_y = self.y_offset*(h - self.vertical_scrollbar_button.h)/(self.h - self.area_height)

            -- Snap scrollbar button when near the edges
            local drag_dx = self.vertical_scrollbar_button.drag_y - self.last_drag_y
            if drag_dx > 0 then -- down
                if self.vertical_scrollbar_button.drag_y >= self.area_height - 2*self.scroll_button_height - self.vertical_scrollbar_button.h - self.vertical_step then
                    self.vertical_scrollbar_button.drag_y = self.area_height - 2*self.scroll_button_height - self.vertical_scrollbar_button.h
                end
            elseif drag_dx < 0 then -- up
                if self.vertical_scrollbar_button.drag_y <= self.vertical_step then
                    self.vertical_scrollbar_button.drag_y = 0 
                end
            end
            self.last_drag_y = self.vertical_scrollbar_button.drag_y

            if self.vertical_scrollbar_top_button.released then self:scrollUp(self.vertical_step) end
            if self.vertical_scrollbar_bottom_button.released then self:scrollDown(self.vertical_step) end
        end
        if self.horizontal_scrolling then
            -- Settings for horizontal scrollbar button
            local w = self.area_width - 2*self.scroll_button_width
            self.horizontal_scrollbar_button.w = math.floor(w/(self.w/w))
            local max_x = self.x + self.x_offset + self.area_width - self.scroll_button_width - self.horizontal_scrollbar_button.w
            self.horizontal_scrollbar_button:setDragLimits(self.x + self.x_offset + self.scroll_button_width, nil, max_x, nil)

            -- Define if the user is scrolling with the slider or through steps
            if self.horizontal_scrollbar_button.pressed then self.mouse_scrolling_x = true end
            if self.horizontal_scrollbar_left_button.pressed or self.horizontal_scrollbar_right_button.pressed or
               self.input:pressed('scroll-left') or self.input:pressed('scroll-right') then
                self.mouse_scrolling_x = false
            end

            -- If using the slider, change the scrollarea's values accordingly
            if self.mouse_scrolling_x then
                self.x_offset = self.horizontal_scrollbar_button.drag_x*(self.w - self.area_width)/(w - self.horizontal_scrollbar_button.w)
                self.scroll_x = -self.x_offset
                for _, element in ipairs(self.elements) do element:update(0, self) end
            end

            -- Change the scrollbar's position according to the scrollarea's values
            self.horizontal_scrollbar_button.drag_x = self.x_offset*(w - self.horizontal_scrollbar_button.w)/(self.w - self.area_width)

            -- Snap scrollbar button when near the edges
            local drag_dx = self.horizontal_scrollbar_button.drag_x - self.last_drag_x
            if drag_dx > 0 then -- right
                if self.horizontal_scrollbar_button.drag_x >= self.area_width - 2*self.scroll_button_width - self.horizontal_scrollbar_button.w - self.horizontal_step then
                    self.horizontal_scrollbar_button.drag_x = self.area_width - 2*self.scroll_button_width - self.horizontal_scrollbar_button.w
                end
            elseif drag_dx < 0 then -- left
                if self.horizontal_scrollbar_button.drag_x <= self.horizontal_step then
                    self.horizontal_scrollbar_button.drag_x = 0
                end
            end
            self.last_drag_x = self.horizontal_scrollbar_button.drag_x

            if self.horizontal_scrollbar_left_button.released then self:scrollLeft(self.horizontal_step) end
            if self.horizontal_scrollbar_right_button.released then self:scrollRight(self.horizontal_step) end
        end
        if self.vertical_scrollbar_top_button.selected or self.vertical_scrollbar_bottom_button.selected or self.vertical_scrollbar_button.selected or
           self.horizontal_scrollbar_left_button.selected or self.horizontal_scrollbar_right_button.selected or self.horizontal_scrollbar_button.selected then
            self.selected = true
        end
    end

    -- Scrolling with keyboard keys
    if self.selected and not self.any_selected then
        if self.input:pressed('scroll-up') then 
            self.last_scroll_pressed_time = love.timer.getTime()
            self:scrollUp(self.vertical_step) 
        end
        if self.input:down('scroll-up') then
            local dx = love.timer.getTime() - self.last_scroll_pressed_time
            if dx > 0.2 then self:scrollUp(self.vertical_step) end
        end
        if self.input:pressed('scroll-down') then 
            self.last_scroll_pressed_time = love.timer.getTime()
            self:scrollDown(self.vertical_step) 
        end
        if self.input:down('scroll-down') then
            local dx = love.timer.getTime() - self.last_scroll_pressed_time
            if dx > 0.2 then self:scrollDown(self.vertical_step) end
        end
        if self.input:pressed('scroll-left') then 
            self.last_scroll_pressed_time = love.timer.getTime()
            self:scrollLeft(self.horizontal_step) 
        end
        if self.input:down('scroll-left') then
            local dx = love.timer.getTime() - self.last_scroll_pressed_time
            if dx > 0.2 then self:scrollLeft(self.horizontal_step) end
        end
        if self.input:pressed('scroll-right') then 
            self.last_scroll_pressed_time = love.timer.getTime()
            self:scrollRight(self.horizontal_step) 
        end
        if self.input:down('scroll-right') then
            local dx = love.timer.getTime() - self.last_scroll_pressed_time
            if dx > 0.2 then self:scrollRight(self.horizontal_step) end
        end
    end

    self.x, self.y = parent_x + self.ix + self.scroll_x, parent_y + self.iy + self.scroll_y
    if self.vertical_scrolling then
        self.vertical_scrollbar_button:update(dt, self)
        self.vertical_scrollbar_top_button:update(dt, self)
        self.vertical_scrollbar_bottom_button:update(dt, self)
    end
    if self.horizontal_scrolling then
        self.horizontal_scrollbar_button:update(dt, self)
        self.horizontal_scrollbar_left_button:update(dt, self)
        self.horizontal_scrollbar_right_button:update(dt, self)
    end

    self:basePostUpdate(dt)
end

function Scrollarea:draw()
    if self.vertical_scrolling or self.horizontal_scrolling then 
        love.graphics.setScissor(self.x + self.x_offset, self.y + self.y_offset, self.area_width, self.area_height) 
    end

    self:basePreDraw()
    love.graphics.setScissor(self.x + self.x_offset, self.y + self.y_offset, self.area_width, self.area_height) 
    self:containerDraw()
    love.graphics.setScissor()

    if self.show_scrollbars then
        if self.vertical_scrolling then
            self.vertical_scrollbar_button:draw()
            self.vertical_scrollbar_top_button:draw()
            self.vertical_scrollbar_bottom_button:draw()
        end
        if self.horizontal_scrolling then
            self.horizontal_scrollbar_button:draw()
            self.horizontal_scrollbar_left_button:draw()
            self.horizontal_scrollbar_right_button:draw()
        end
    end
    self:basePostDraw()
end

function Scrollarea:addElement(element)
    return self:containerAddElement(element)
end

function Scrollarea:removeElement(id)
    return self:containerRemoveElement(id)
end

function Scrollarea:getElement(id)
    return self:containerGetElement(id)
end

function Scrollarea:scrollUp(step, stop)
    if self.y_offset - step >= 0 then
        self.y_offset = self.y_offset - step
        self.scroll_y = self.scroll_y + step
        for _, element in ipairs(self.elements) do element:update(0, self) end
    else
        if not stop then
            for i = 1, step do self:scrollUp(1, true) end
        end
    end
end

function Scrollarea:scrollDown(step, stop)
    if self.y_offset + step <= self.h - self.area_height then
        self.y_offset = self.y_offset + step
        self.scroll_y = self.scroll_y - step
        for _, element in ipairs(self.elements) do element:update(0, self) end
    else
        if not stop then
            for i = 1, step do self:scrollDown(1, true) end
        end
    end
end

function Scrollarea:scrollLeft(step, stop)
    if self.x_offset - step >= 0 then
        self.x_offset = self.x_offset - step
        self.scroll_x = self.scroll_x + step
        for _, element in ipairs(self.elements) do element:update(0, self) end
    else
        if not stop then
            for i = 1, step do self:scrollLeft(1, true) end
        end
    end
end

function Scrollarea:scrollRight(step, stop)
    if self.x_offset + step <= self.w - self.area_width then
        self.x_offset = self.x_offset + step
        self.scroll_x = self.scroll_x - step
        for _, element in ipairs(self.elements) do element:update(0, self) end
    else
        if not stop then
            for i = 1, step do self:scrollRight(1, true) end
        end
    end
end

return Scrollarea
