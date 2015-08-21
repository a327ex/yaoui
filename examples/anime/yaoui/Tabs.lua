local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Tabs = Object:extend('Tabs')

function Tabs:new(yui, settings)
    self.yui = yui
    self.size = settings.size or 20
    self.name = settings.name
    self.x, self.y = 0, 0
    self.tabs = settings.tabs
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_semibold, math.floor(self.size*0.7))
    self.hover_font = love.graphics.newFont(self.yui.Theme.open_sans_light, math.floor(math.max(self.size, 40)*0.4))
    local tabs_w = 0
    self.h = self.font:getHeight() + math.floor(self.size*0.7)
    self.selected_tab = settings.selected_tab or 1
    self.buttons = {}
    for i, tab in ipairs(self.tabs) do
        local w = self.font:getWidth(tab.text) + self.size
        tabs_w = tabs_w + w
        local button = self.yui.UI.Button(0, 0, w, self.h, {
            yui = self.yui,
            extensions = {self.yui.Theme.TabButton},
            parent = self,
            hover = tab.hover,
            text = tab.text,
            i = i,
        })
        table.insert(self.buttons, button)
        self[i] = button
        if tab.name then self[tab.name] = button end
    end
    self.w = tabs_w
end

function Tabs:update(dt)
    local w = 0
    for i, button in ipairs(self.buttons) do 
        if i == 1 then
            button.x, button.y = self.x, self.y
            w = w + button.w
        else
            button.x, button.y = self.x + w, self.y
            w = w + button.w
        end
        if button.hot and button.pressed then
            self.selected_tab = i
            if self.tabs[i].onClick then 
                self.tabs[i]:onClick() 
            end
        end
        button:update(dt) 
        if button.hot then love.mouse.setCursor(self.yui.Theme.hand_cursor) end
    end
end

function Tabs:draw()
    for _, button in ipairs(self.buttons) do button:draw() end
end

return Tabs
