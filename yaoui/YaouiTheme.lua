local yaoui_path = (...):sub(1, -12)
yaoui_path = yaoui_path:gsub("%.", "/")
local YaouiTheme = {}

YaouiTheme.colors = {
    hover_bg = {12, 12, 12},
    hover_text = {204, 204, 204},

    text_dark = {188, 190, 192},
    text = {222, 222, 222},
    text_light = {255, 255, 255},

    button_primary = {31, 55, 95},
    button_hot = {34, 86, 148},
    button_pressed = {36, 104, 204},
    button_loading_icon = {45, 117, 223},

    checkbox_bg = {84, 84, 84},
    checkbox_v = {75, 194, 244},

    dropdown_primary = {43, 110, 210},
    dropdown_area_bg = {32, 32, 32},
    dropdown_button_selected_bg = {20, 32, 48},

    flat_dropdown_bg = {57, 59, 61},
    flat_dropdown_outline = {127, 157, 185},
    flat_dropdown_button_selected_bg = {30, 144, 255},

    flat_textinput_bg = {57, 59, 61},
    flat_textinput_selected_text_bg = {51, 153, 255},

    separator = {160, 160, 160},

    icon_button_primary = {204, 204, 204},
    icon_button_hover = {36, 104, 204},

    image_button_primary = {36, 104, 204},

    tab_primary = {36, 104, 204},

    textinput_bg = {12, 12, 12},
    textinput_selected_text_bg = {51, 153, 255},
}

YaouiTheme.font_awesome = require(yaoui_path .. '.FontAwesome')
YaouiTheme.font_awesome_path = yaoui_path .. '/fonts/fontawesome-webfont.ttf'
YaouiTheme.open_sans_regular = yaoui_path .. '/fonts/OpenSans-Regular.ttf'
YaouiTheme.open_sans_light = yaoui_path .. '/fonts/OpenSans-Light.ttf'
YaouiTheme.open_sans_bold = yaoui_path .. '/fonts/OpenSans-Bold.ttf'
YaouiTheme.open_sans_semibold = yaoui_path .. '/fonts/OpenSans-Semibold.ttf'

YaouiTheme.hand_cursor = love.mouse.getSystemCursor("hand")
YaouiTheme.ibeam = love.mouse.getSystemCursor("ibeam")

-- Button
YaouiTheme.Button = {}
YaouiTheme.Button.new = function(self)
    self.color = {unpack(self.yui.Theme.colors.button_primary)}
    self.timer = self.yui.Timer()
    self.hover_alpha = 0
end

YaouiTheme.Button.update = function(self, dt)
    self.timer:update(dt)

    if self.parent.hover then
        if self.enter then
            self.timer:after('hover', 0.3, function()
                self.timer:tween('hover_alpha', 0.1, self, {hover_alpha = 232}, 'linear')
            end)
        end
        if self.exit then 
            self.timer:cancel('hover') 
            self.timer:tween('hover_alpha', 0.1, self, {hover_alpha = 0}, 'linear')
        end
    end
end

YaouiTheme.Button.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {unpack(self.yui.Theme.colors.button_hot)}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {unpack(self.yui.Theme.colors.button_primary)}}, 'linear')
    elseif self.hot and self.pressed then self.timer:tween('color', 0.1, self, {color = {unpack(self.yui.Theme.colors.button_pressed)}}, 'linear')
    elseif self.released then 
        if self.hot then self.timer:tween('color', 0.2, self, {color = {unpack(self.yui.Theme.colors.button_hot)}}, 'linear')
        else self.timer:tween('color', 0.2, self, {color = {unpack(self.yui.Theme.colors.button_primary)}}, 'linear') end
    end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    if self.parent.hover then
        local r, g, b = unpack(self.yui.Theme.colors.hover_bg)
        love.graphics.setColor(r, g, b, self.hover_alpha)
        love.graphics.rectangle('fill', 
                                self.x + self.w/2 - (self.parent.hover_font:getWidth(self.parent.hover) + math.max(self.parent.size, 40)/4)/2, 
                                self.y - math.max(self.parent.size, 40)/1.5,
                                self.parent.hover_font:getWidth(self.parent.hover) + math.max(self.parent.size, 40)/4, 
                                self.parent.hover_font:getHeight(), self.h/16, self.h/16)

        local r, g, b = unpack(self.yui.Theme.colors.hover_text)
        love.graphics.setColor(r, g, b, self.hover_alpha)
        local font = love.graphics.getFont()
        love.graphics.setFont(self.parent.hover_font)
        love.graphics.print(self.parent.hover, self.x + self.w/2 - self.parent.hover_font:getWidth(self.parent.hover)/2, self.y - math.max(self.parent.size, 40)/1.45)
    end

    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, self.w/16, self.w/16)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.w/16, self.w/16)

    love.graphics.setColor(unpack(self.yui.Theme.colors.text))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    if self.icon then
        if self.parent.icon_right then
            love.graphics.setColor(unpack(self.yui.Theme.colors.text))
            love.graphics.print(self.text, self.x + self.parent.size/2, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
            if self.parent.loading then love.graphics.setColor(unpack(self.yui.Theme.colors.button_loading_icon)) end
            love.graphics.print(self.icon, self.x + self.parent.size/2 + self.font:getWidth(self.icon)/2 + self.font:getWidth(self.text .. ' '), 
                                self.y + math.floor(self.parent.size*0.7/2) + self.font:getHeight()/2 - self.parent.size/20, 
                                self.parent.icon_r, 1, 1, self.font:getWidth(self.icon)/2, self.font:getHeight()/2)
        else
            if self.parent.loading then love.graphics.setColor(unpack(self.yui.Theme.colors.button_loading_icon)) end
            love.graphics.print(self.icon, self.x + self.parent.size/2 + self.font:getWidth(self.icon)/2, 
                                self.y + math.floor(self.parent.size*0.7/2) + self.font:getHeight()/2 - self.parent.size/20, 
                                self.parent.icon_r, 1, 1, self.font:getWidth(self.icon)/2, self.font:getHeight()/2)
            love.graphics.setColor(unpack(self.yui.Theme.colors.text))
            love.graphics.print(self.text, self.x + self.parent.size/2 + self.font:getWidth(self.parent.original_icon .. ' '), self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
        end
    else love.graphics.print(self.text, self.x + self.parent.size/2, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20) end
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Checkbox
YaouiTheme.Checkbox = {}
YaouiTheme.Checkbox.new = function(self)
    self.check_alpha = 255
    self.check_draw = false
    self.timer = self.yui.Timer()
end

YaouiTheme.Checkbox.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.Checkbox.draw = function(self)
    if self.checked_enter then 
        self.check_alpha = 255
        self.check_draw = true
    elseif self.checked_exit then self.timer:tween('check', 0.15, self, {check_alpha = 0}, 'linear', function() self.check_draw = false end) end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.yui.Theme.colors.text))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.font:getWidth(self.icon .. '  '), self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(unpack(self.yui.Theme.colors.checkbox_bg))
    love.graphics.rectangle('line', self.x, self.y + self.h/4, 2*self.h/4, 2*self.h/4, self.w/32, self.w/32)
    love.graphics.rectangle('fill', self.x, self.y + self.h/4, 2*self.h/4, 2*self.h/4, self.w/32, self.w/32)
    local r, g, b = unpack(self.yui.Theme.colors.checkbox_v)
    love.graphics.setColor(r, g, b, self.check_alpha)
    if self.check_draw then love.graphics.print(self.icon, self.x + self.parent.size/20, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/18) end
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Dropdown
YaouiTheme.Dropdown = {}
YaouiTheme.Dropdown.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end
    
    local text_color = {unpack(self.yui.Theme.colors.text_dark)}
    if self.hot then text_color = {unpack(self.yui.Theme.colors.text_light)} end

    love.graphics.setColor(unpack(text_color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.title .. '   ', self.x, self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(unpack(self.yui.Theme.colors.dropdown_primary))
    love.graphics.print(self.parent.options[self.parent.current_option] .. ' ', 
                        self.x + self.font:getWidth(self.title .. '   '), 
                        self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(unpack(text_color))
    love.graphics.print(self.icon, 
                        self.x + self.font:getWidth(self.title .. '   ' .. self.parent.options[self.parent.current_option] .. ' '), 
                        self.y + math.floor(self.parent.size*0.7/2.5))
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

YaouiTheme.DropdownScrollarea = {}
YaouiTheme.DropdownScrollarea.draw = function(self)
    -- Draw scrollarea frame
    local r, g, b = unpack(self.yui.Theme.colors.dropdown_area_bg)
    love.graphics.setColor(r, g, b, 220)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    -- Draw scrollbars background
    love.graphics.setScissor()
    love.graphics.setColor(128, 131, 135, 255)
    if self.show_scrollbars then
        if self.vertical_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.area_width,
                                    self.y + self.scroll_button_height,
                                    self.scroll_button_width,
                                    self.area_height - 2*self.scroll_button_height)
        end
        if self.horizontal_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.scroll_button_width,
                                    self.y + self.area_height,
                                    self.area_width - 2*self.scroll_button_width,
                                    self.scroll_button_height)
        end
    end
end

YaouiTheme.DropdownButton = {}
YaouiTheme.DropdownButton.new = function(self)
    self.timer = self.yui.Timer()
    self.add_x = 0
    self.alpha = 220 
    self.draw_bg = false
end

YaouiTheme.DropdownButton.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.DropdownButton.draw = function(self)
    local r, g, b = unpack(self.yui.Theme.colors.dropdown_button_selected_bg)
    if self.dropdown_selected then
        love.graphics.setColor(r, g, b, 220)
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    elseif self.draw_bg then
        love.graphics.setColor(r, g, b, self.alpha)
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    end

    if self.enter then 
        self.draw_bg = true
        self.timer:tween('add_x', 0.2, self, {add_x = self.size/4}, 'in-out-cubic') 
        self.timer:tween('bg', 0.1, self, {alpha = 220}, 'linear')
    end
    if self.exit then 
        self.timer:tween('add_x', 0.1, self, {add_x = 0}, 'in-out-cubic') 
        self.timer:tween('bg', 0.1, self, {alpha = 0}, 'linear', function() self.draw_bg = false end) 
    end

    if self.hot then
        love.graphics.setColor(unpack(self.yui.Theme.colors.dropdown_primary))
        love.graphics.rectangle('fill', self.x, self.y, self.add_x, self.h)
    end

    if self.dropdown_selected then
        self.add_x = self.size/4
        love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
        love.graphics.rectangle('fill', self.x, self.y, self.size/4, self.h)
    end

    if self.hot or self.dropdown_selected then love.graphics.setColor(unpack(self.yui.Theme.colors.text_light))
    else love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark)) end
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.size + self.add_x, self.y + math.floor(self.size*0.65/2))
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- FlatDropdown
YaouiTheme.FlatDropdown = {}
YaouiTheme.FlatDropdown.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.yui.Theme.colors.flat_dropdown_bg))
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    
    love.graphics.setColor(unpack(self.yui.Theme.colors.text))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.parent.options[self.parent.current_option] .. ' ', 
                        self.x + self.parent.size/3, 
                        self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
    love.graphics.print(self.icon, 
                        self.x + self.w - self.parent.size/3 - self.font:getWidth(self.icon), 
                        self.y + math.floor(self.parent.size*0.7/2.5) - self.parent.size/20)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

YaouiTheme.FlatDropdownScrollarea = {}
YaouiTheme.FlatDropdownScrollarea.draw = function(self)
    love.graphics.setLineStyle('rough')
    -- Draw scrollarea frame
    local r, g, b = unpack(self.yui.Theme.colors.flat_dropdown_bg)
    love.graphics.setColor(r, g, b, 255)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(unpack(self.yui.Theme.colors.flat_dropdown_outline))
    love.graphics.rectangle('line', self.x + 1, self.y, self.w - 2, self.h)

    -- Draw scrollbars background
    love.graphics.setScissor()
    love.graphics.setColor(128, 131, 135, 255)
    if self.show_scrollbars then
        if self.vertical_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.area_width,
                                    self.y + self.scroll_button_height,
                                    self.scroll_button_width,
                                    self.area_height - 2*self.scroll_button_height)
        end
        if self.horizontal_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.scroll_button_width,
                                    self.y + self.area_height,
                                    self.area_width - 2*self.scroll_button_width,
                                    self.scroll_button_height)
        end
    end
    love.graphics.setLineStyle('smooth')

end

YaouiTheme.FlatDropdownButton = {}
YaouiTheme.FlatDropdownButton.draw = function(self)
    love.graphics.setLineStyle('rough')
    if self.dropdown_selected then
        love.graphics.setColor(unpack(self.yui.Theme.colors.flat_dropdown_button_selected_bg))
        love.graphics.rectangle('fill', self.x + 1, self.y, self.w - 3, self.h)
    end

    if self.hot then
        love.graphics.setColor(unpack(self.yui.Theme.colors.flat_dropdown_button_selected_bg))
        love.graphics.rectangle('fill', self.x + 1, self.y, self.w - 3, self.h)
    end
    love.graphics.setLineStyle('smooth')

    if self.hot or self.dropdown_selected then love.graphics.setColor(unpack(self.yui.Theme.colors.text_light))
    else love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark)) end
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.parent.size/3, self.y)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- FlatTextinput
YaouiTheme.FlatTextinput = {}
YaouiTheme.FlatTextinput.draw = function(self)
    love.graphics.setLineStyle('rough')

    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)

    -- Draw textinput background
    love.graphics.setColor(unpack(self.yui.Theme.colors.flat_textinput_bg))
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    -- Draw selected text with inverted color and blue selection background
    if self.selection_index and self.index ~= self.selection_index then
        love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
        self.text:draw()

        if self.selected then
            love.graphics.setColor(unpack(self.yui.Theme.colors.flat_textinput_selected_bg))
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
            end

            love.graphics.setColor(unpack(self.yui.Theme.colors.text_light))
            if love_version == '0.9.1' or love_version == '0.9.2' then
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.setStencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    self.text:draw()
                    love.graphics.setStencil()
                end
            else
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.stencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    love.graphics.setStencilTest(true)
                    self.text:draw()
                    love.graphics.setStencilTest(false)
                end
            end
        end

    -- Draw text normally + cursor
    else
        love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
        self.text:draw()

        if self.selected and self.cursor_visible then 
            love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.line(self.selection_positions[i].x, self.selection_positions[i].y, 
                self.selection_positions[i].x, self.selection_positions[i].y + self.selection_sizes[i].h)
            end
        end
    end

    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255, 255)

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- HorizontalSeparator
YaouiTheme.HorizontalSeparator = {}
YaouiTheme.HorizontalSeparator.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.yui.Theme.colors.separator))
    love.graphics.setLineStyle('rough')
    love.graphics.line(self.x + self.margin_left, self.y + self.size/2, self.x + self.w - self.margin_left - self.margin_right, self.y + self.size/2)
    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255)
end

-- HorizontalSpacing
YaouiTheme.HorizontalSpacing = {}
YaouiTheme.HorizontalSpacing.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end
    love.graphics.setColor(255, 255, 255)
end

-- IconButton
YaouiTheme.IconButton = {}
YaouiTheme.IconButton.new = function(self)
    self.hover_alpha = 0
    self.color = {unpack(self.yui.Theme.colors.icon_button_primary)}
    self.timer = self.yui.Timer()
end

YaouiTheme.IconButton.update = function(self, dt)
    self.timer:update(dt)

    if self.parent.hover then
        if self.enter then
            self.timer:after('hover', 0.3, function()
                self.timer:tween('hover_alpha', 0.1, self, {hover_alpha = 232}, 'linear')
            end)
        end
        if self.exit then 
            self.timer:cancel('hover') 
            self.timer:tween('hover_alpha', 0.1, self, {hover_alpha = 0}, 'linear')
        end
    end
end

YaouiTheme.IconButton.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {unpack(self.yui.Theme.colors.icon_button_hover)}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {unpack(self.yui.Theme.colors.icon_button_primary)}}, 'linear') end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    if self.parent.hover then
        local r, g, b = unpack(self.yui.Theme.colors.hover_bg)
        love.graphics.setColor(r, g, b, self.hover_alpha)
        love.graphics.rectangle('fill', 
                                self.x + self.w/2 - self.parent.hover_font:getWidth(self.parent.hover)/2 - math.max(self.parent.size, 40)/8, 
                                self.y - math.max(self.parent.size, 40)/1.5, 
                                self.parent.hover_font:getWidth(self.parent.hover) + math.max(self.parent.size, 40)/4,
                                self.parent.hover_font:getHeight(), self.h/16, self.h/16)

        local r, g, b = unpack(self.yui.Theme.colors.hover_text)
        love.graphics.setColor(r, g, b, self.hover_alpha)
        local font = love.graphics.getFont()
        love.graphics.setFont(self.parent.hover_font)
        love.graphics.print(self.parent.hover, self.x + self.w/2 - self.parent.hover_font:getWidth(self.parent.hover)/2, self.y - math.max(self.parent.size, 40)/1.4)
    end

    local r, g, b = unpack(self.color)
    love.graphics.setColor(r, g, b, 255)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.icon, self.x + self.w/10, self.y + self.h/64)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- ImageButton
YaouiTheme.ImageButton = {}
YaouiTheme.ImageButton.new = function(self)
    self.alpha = 0
    self.timer = self.yui.Timer()
end

YaouiTheme.ImageButton.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.ImageButton.draw = function(self)
    if self.enter then self.timer:tween('alpha', 0.1, self, {alpha = 255}, 'linear')
    elseif self.exit then self.timer:tween('alpha', 0.1, self, {alpha = 0}, 'linear') end

    love.graphics.stencil(function()
        if self.parent.rounded_corners then love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.h/18, self.h/18)
        else love.graphics.rectangle('fill', self.x, self.y, self.w, self.h) end
    end)
    love.graphics.setStencilTest(true)
    love.graphics.draw(self.parent.img, self.x - self.parent.ix, self.y - self.parent.iy)
    love.graphics.setStencilTest(false)

    if self.parent.overlay then self.parent.overlay(self.parent) end
    love.graphics.setColor(255, 255, 255, 255)
end

YaouiTheme.ImageButton.postDraw = function(self)
    love.graphics.setLineWidth(2.5)
    local r, g, b = unpack(self.yui.Theme.colors.image_button_primary)
    love.graphics.setColor(r, g, b, self.alpha)
    if self.parent.rounded_corners then love.graphics.rectangle('line', self.x, self.y, self.w, self.h, self.h/18, self.h/18)
    else love.graphics.rectangle('line', self.x, self.y, self.w, self.h) end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(1)
end

-- Tabs
YaouiTheme.TabButton = {}
YaouiTheme.TabButton.new = function(self)
    self.hover_alpha = 0
    self.timer = self.yui.Timer()
end

YaouiTheme.TabButton.update = function(self, dt)
    self.timer:update(dt)

    if self.hover then
        if self.enter then
            self.timer:after('hover', 0.3, function()
                self.timer:tween('hover_alpha', 0.1, self, {hover_alpha = 232}, 'linear')
            end)
        end
        if self.exit then 
            self.timer:cancel('hover') 
            self.timer:tween('hover_alpha', 0.1, self, {hover_alpha = 0}, 'linear')
        end
    end
end

YaouiTheme.TabButton.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    local text_color = {unpack(self.yui.Theme.colors.text_dark)}
    if self.hot then text_color = {unpack(self.yui.Theme.colors.text_light)} end

    if self.hover then
        local r, g, b = unpack(self.yui.Theme.colors.hover_bg)
        love.graphics.setColor(r, g, b, self.hover_alpha)
        love.graphics.rectangle('fill', 
                                self.x + self.w/2 - self.parent.hover_font:getWidth(self.hover)/2 - math.max(self.parent.size, 40)/8, 
                                self.y - self.parent.hover_font:getHeight()/1.35 - math.max(self.parent.size, 40)/12, 
                                self.parent.hover_font:getWidth(self.hover) + math.max(self.parent.size, 40)/4,
                                self.parent.hover_font:getHeight(), self.h/16, self.h/16)

        local r, g, b = unpack(self.yui.Theme.colors.hover_text)
        love.graphics.setColor(r, g, b, self.hover_alpha)
        local font = love.graphics.getFont()
        love.graphics.setFont(self.parent.hover_font)
        love.graphics.print(self.hover, 
                            self.x + self.w/2 - self.parent.hover_font:getWidth(self.hover)/2, 
                            self.y - self.parent.hover_font:getHeight()/1.35 - math.max(self.parent.size, 40)/16 - math.max(self.parent.size, 40)/12)
    end

    if self.i == self.parent.selected_tab then
        love.graphics.setColor(unpack(self.yui.Theme.colors.tab_primary))
        love.graphics.rectangle('fill', self.x, self.y + self.h - self.parent.size/4, self.w, self.parent.size/4)
    end

    local r, g, b = unpack(text_color)
    love.graphics.setColor(r, g, b, 255)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.parent.font)
    love.graphics.print(self.text, self.x + self.w/2 - self.parent.font:getWidth(self.text)/2, self.y + self.parent.font:getHeight()/4)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255, 255)

end

-- Text
YaouiTheme.Text = {}
YaouiTheme.Text.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.size/6, self.y + self.font:getHeight()/2 + self.size/4)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Textinput
YaouiTheme.Textinput = {}
YaouiTheme.Textinput.draw = function(self)
     love.graphics.setLineStyle('rough')

    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)

    -- Draw textinput background
    love.graphics.setColor(unpack(self.yui.Theme.colors.textinput_bg))
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.h/4, self.h/4)

    -- Draw selected text with inverted color and blue selection background
    if self.selection_index and self.index ~= self.selection_index then
        love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
        self.text:draw()

        if self.selected then
            love.graphics.setColor(unpack(self.yui.Theme.colors.textinput_selected_text_bg))
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
            end

            love.graphics.setColor(unpack(self.yui.Theme.colors.text_light))
            if love_version == '0.9.1' or love_version == '0.9.2' then
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.setStencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    self.text:draw()
                    love.graphics.setStencil()
                end
            else
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.stencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    love.graphics.setStencilTest(true)
                    self.text:draw()
                    love.graphics.setStencilTest(false)
                end
            end
        end

    -- Draw text normally + cursor
    else
        love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
        self.text:draw()

        if self.selected and self.cursor_visible then 
            love.graphics.setColor(unpack(self.yui.Theme.colors.text_dark))
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.line(self.selection_positions[i].x, self.selection_positions[i].y, 
                self.selection_positions[i].x, self.selection_positions[i].y + self.selection_sizes[i].h)
            end
        end
    end

    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255, 255)

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- VerticalSeparator
YaouiTheme.VerticalSeparator = {}
YaouiTheme.VerticalSeparator.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.yui.Theme.colors.separator))
    love.graphics.setLineStyle('rough')
    love.graphics.line(self.x + self.size/2, self.y + self.margin_top, self.x + self.size/2, self.y + self.h - self.margin_top - self.margin_bottom)
    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255)
end

-- VerticalSpacing
YaouiTheme.VerticalSpacing = {}
YaouiTheme.VerticalSpacing.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end
    love.graphics.setColor(255, 255, 255)
end

return YaouiTheme
