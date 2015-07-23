local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Base = Object:extend('Base')

function Base:basePreNew(x, y, w, h, settings)
    self.ix, self.iy = x, y
    self.x, self.y = x, y
    self.w, self.h = w, h
    local settings = settings or {}
    for k, v in pairs(settings) do self[k] = v end

    self.input = self.ui.Input()
    self:bind('mouse1', 'left-click')
    self:bind('mouse2', 'right-click')
    self:bind('return', 'key-enter')

    self.hot = false
    self.selected = false
    self.down = false
    self.pressed = false
    self.released = false
    self.enter = false
    self.exit = false
    self.selected_enter = false
    self.selected_exit = false

    self.collision = function(self, x, y)
        local sax, say, aw, ah = self.x_offset or 0, self.y_offset or 0, self.area_width or self.w, self.area_height or self.h
        if x >= (self.x + sax) and x <= (self.x + sax + aw) and y >= (self.y + say) and y <= (self.y + say + ah) then
            return true
        else return false end
    end

    self.getMousePosition = function() return love.mouse.getPosition() end

    self.pressing = false
    self.previous_hot = false
    self.previous_selected = false
    self.previous_pressed = false
    self.previous_released = false
end

function Base:basePostNew()
    -- Initialize extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.new then extension.new(self) end
    end
end

function Base:basePreUpdate(dt, parent)
    local x, y = self.getMousePosition()
    if parent and not self.draggable and not self.resizable and self.type ~= 'Scrollarea' then self.x, self.y = parent.x + self.ix, parent.y + self.iy end

    -- Check for hot
    self.hot = self:collision(x, y)

    -- Check for enter 
    if self.hot and not self.previous_hot then
        self.enter = true
    else self.enter = false end

    -- Check for exit
    if not self.hot and self.previous_hot then
        self.exit = true
    else self.exit = false end

    -- Set focused or not
    if self.hot and self.input:pressed('left-click') then
        self.selected = true
    elseif not self.hot and self.input:pressed('left-click') then
        self.selected = false
    end

    -- Check for selected_enter
    if self.selected and not self.previous_selected then
        self.selected_enter = true
    else self.selected_enter = false end

    -- Check for selected_exit
    if not self.selected and self.previous_selected then
        self.selected_exit = true
    else self.selected_exit = false end

    -- Check for pressed/released/down on mouse hover
    if self.hot and self.input:pressed('left-click') then
        self.pressed = true
        self.pressing = true
    end
    if self.pressing and self.input:down('left-click') then
        self.down = true
    end
    if self.pressing and self.input:released('left-click') then
        self.released = true
        self.pressing = false
        self.down = false
    end

    -- Check for pressed/released/down on key press
    if self.selected and self.input:pressed('key-enter') then
        self.pressed = true
        self.pressing = true
    end
    if self.pressing and self.input:down('key-enter') then
        self.down = true
    end
    if self.pressing and self.input:released('key-enter') then
        self.released = true
        self.pressing = false
        self.down = false
    end
end

function Base:basePostUpdate(dt)
    if self.pressed and self.previous_pressed then self.pressed = false end
    if self.released and self.previous_released then self.released = false end

    -- Update extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.update then extension.update(self, dt, parent) end
    end
    
    self.previous_hot = self.hot
    self.previous_pressed = self.pressed
    self.previous_released = self.released
    self.previous_selected = self.selected

    self.input:update(dt)
end

function Base:basePreDraw()
    -- Draw extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.draw then extension.draw(self) end
    end
end

function Base:basePostDraw()
    -- Draw extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.overlay then extension.overlay(self) end
    end
end

function Base:bind(key, action)
    self.input:bind(key, action)
end

return Base
