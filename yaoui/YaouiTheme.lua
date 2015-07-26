local yaoui_path = (...):sub(1, -12)
local YaouiTheme = {}

YaouiTheme.font_awesome = require(yaoui_path .. '.FontAwesome')
YaouiTheme.font_awesome_path = yaoui_path .. '/fonts/fontawesome-webfont.ttf'
YaouiTheme.open_sans_regular = yaoui_path .. '/fonts/OpenSans-Regular.ttf'
YaouiTheme.open_sans_semibold = yaoui_path .. '/fonts/OpenSans-Semibold.ttf'
YaouiTheme.hand_cursor = love.mouse.getSystemCursor("hand")

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
    --[[
    if self.checked then love.graphics.setColor(222, 222, 222)
    else love.graphics.setColor(64, 64, 64) end
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, self.w/16, self.w/16)
    ]]--

    if self.checked_enter then 
        self.check_alpha = 255
        self.check_draw = true
    elseif self.checked_exit then self.timer:tween('check', 0.15, self, {check_alpha = 0}, 'linear', function() self.check_draw = false end) end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 36, 36)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(222, 222, 222)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.font:getWidth(self.icon .. '  '), self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(84, 84, 84)
    love.graphics.rectangle('line', self.x, self.y + self.h/4, 2*self.h/4, 2*self.h/4, self.w/32, self.w/32)
    love.graphics.rectangle('fill', self.x, self.y + self.h/4, 2*self.h/4, 2*self.h/4, self.w/32, self.w/32)
    love.graphics.setColor(75, 194, 244, self.check_alpha)
    if self.check_draw then love.graphics.print(self.icon, self.x + self.parent.size/20, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/18) end
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Button
YaouiTheme.Button = {}
YaouiTheme.Button.new = function(self)
    self.color = {31, 55, 95}
    self.timer = self.yui.Timer()
end

YaouiTheme.Button.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.Button.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {34, 86, 148}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {31, 55, 95}}, 'linear')
    elseif self.hot and self.pressed then self.timer:tween('color', 0.25, self, {color = {36, 104, 204}}, 'linear')
    elseif self.released then 
        if self.hot then self.timer:tween('color', 0.25, self, {color = {34, 86, 148}}, 'linear')
        else self.timer:tween('color', 0.25, self, {color = {31, 55, 95}}, 'linear') end
    end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 36, 36)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, self.w/16, self.w/16)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.w/16, self.w/16)

    love.graphics.setColor(222, 222, 222)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    if self.icon then
        if self.parent.icon_position == 'right' then
            love.graphics.setColor(222, 222, 222)
            love.graphics.print(self.text, self.x + self.parent.size/2, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
            if self.parent.loading then love.graphics.setColor(45, 117, 223) end
            love.graphics.print(self.icon, self.x + self.parent.size/2 + self.font:getWidth(self.icon)/2 + self.font:getWidth(self.text .. ' '), 
                                self.y + math.floor(self.parent.size*0.7/2) + self.font:getHeight()/2 - self.parent.size/20, 
                                self.parent.icon_r, 1, 1, self.font:getWidth(self.icon)/2, self.font:getHeight()/2)
        else
            if self.parent.loading then love.graphics.setColor(45, 117, 223) end
            love.graphics.print(self.icon, self.x + self.parent.size/2 + self.font:getWidth(self.icon)/2, 
                                self.y + math.floor(self.parent.size*0.7/2) + self.font:getHeight()/2 - self.parent.size/20, 
                                self.parent.icon_r, 1, 1, self.font:getWidth(self.icon)/2, self.font:getHeight()/2)
            love.graphics.setColor(222, 222, 222)
            love.graphics.print(self.text, self.x + self.parent.size/2 + self.font:getWidth(self.parent.original_icon .. ' '), self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
        end
    else love.graphics.print(self.text, self.x + self.parent.size/2, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20) end
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- IconButton
YaouiTheme.IconButton = {}
YaouiTheme.IconButton.new = function(self)
    self.color = {204, 204, 204}
    self.timer = self.yui.Timer()
end

YaouiTheme.IconButton.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.IconButton.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {255, 255, 255}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {204, 204, 204}}, 'linear') end
    
    if self.yui.debug_draw then
        love.graphics.setColor(222, 36, 36)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.icon, self.x + self.w/10, self.y + self.h/64)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

return YaouiTheme
