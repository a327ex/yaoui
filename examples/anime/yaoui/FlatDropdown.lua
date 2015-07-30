local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local FlatDropdown = Object:extend('FlatDropdown')

function FlatDropdown:new(yui, settings)
    self.yui = yui
    self.x, self.y = 0, 0
    self.name = settings.name
    self.size = settings.size or 20
    self.options = settings.options
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_regular, math.floor(self.size*0.7))
    self.font:setFallbacks(love.graphics.newFont(self.yui.Theme.font_awesome_path, math.floor(self.size*0.7)))
    self.icon = self.yui.Theme.font_awesome['fa-sort-desc'] 
    self.current_option = settings.current_option or 1
    self.title = settings.title or ''
    self.drop_up = settings.drop_up
    self.show_dropdown = false

    local min_w = 0
    for i = 1, #self.options do
        local w = self.font:getWidth(self.options[i]) + 2*self.size
        if w > min_w then min_w = w end
    end

    self.w = settings.w or math.max(min_w, self.font:getWidth(self.options[self.current_option] .. ' ' .. self.icon) + 2*self.size)
    self.h = self.font:getHeight() + math.floor(self.size)*0.7
    self.main_button = self.yui.UI.Button(0, 0, self.w, self.h, {
        yui = self.yui,
        extensions = {self.yui.Theme.FlatDropdown},
        font = self.font,
        parent = self,
        icon = self.icon,
    })

    local h = self.font:getHeight()
    self.down_area = self.yui.UI.Scrollarea(0, 0, math.max(min_w, self.w), #self.options*h, {
        yui = self.yui,
        extensions = {self.yui.Theme.FlatDropdownScrollarea},
        parent = self,
        size = self.size,
        show_scrollbars = true,
    })
    for i, option in ipairs(self.options) do
        self.down_area:addElement(self.yui.UI.Button(0, 1 + (i-1)*h, math.max(min_w, self.w), h, {
            yui = self.yui,
            extensions = {self.yui.Theme.FlatDropdownButton},
            font = love.graphics.newFont(self.yui.Theme.open_sans_regular, math.floor(self.size*0.7)),
            text = self.options[i],
            size = self.size,
        }))
    end

    self.onSelect = settings.onSelect
end

function FlatDropdown:update(dt)
    self.main_button.x, self.main_button.y = self.x, self.y
    if self.drop_up then self.down_area.ix, self.down_area.iy = self.x, self.y - self.down_area.h
    else self.down_area.ix, self.down_area.iy = self.x, self.y + self.h end

    for i, element in ipairs(self.down_area.elements) do
        if element.released and element.hot then 
            self.current_option = i 
            self.show_dropdown = false
            if self.onSelect then self:onSelect(self.options[self.current_option]) end
            self.down_area:update(0)
            self.down_area.hot = false
        end
    end

    if self.main_button.pressed then self.show_dropdown = not self.show_dropdown end

    local any_hot = false
    if self.main_button.hot then any_hot = true end
    for i, element in ipairs(self.down_area.elements) do 
        if element.hot then any_hot = true end
        if i == self.current_option then element.dropdown_selected = true
        else element.dropdown_selected = false end
    end

    if self.main_button.input:pressed('left-click') and not any_hot then
        self.show_dropdown = false
        self.down_area:update(0)
        self.down_area.hot = false
    end

    for i, element in ipairs(self.down_area.elements) do
        if any_hot then element.dropdown_selected = false end
    end

    self.main_button:update(dt)
    if self.show_dropdown then self.down_area:update(dt) end

    if self.main_button.hot then love.mouse.setCursor(self.yui.Theme.hand_cursor) end
end

function FlatDropdown:draw()
    self.main_button:draw()
end

function FlatDropdown:postDraw()
    if self.show_dropdown then self.down_area:draw() end
end

return FlatDropdown
