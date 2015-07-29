yui = require 'yaoui'

--[[
winapi = require 'winapi'
require 'winapi.colorchooser'
require 'winapi.filedialogs'
]]--

function love.load()
    yui.UI.registerEvents()

    love.graphics.setBackgroundColor(23, 24, 27)

    -- yui.debug_draw = true

    view = yui.View(50, 0, 200, 530, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Stack({name = 'MainStack', spacing = 4,
            yui.Checkbox({text = 'Checkbox', size = 20}),
            yui.Text({text = 'Text', size = 20}),
            yui.HorizontalSeparator({w = 100}),
            yui.Dropdown({title = 'Dropdown', options = {'Drop', 'Dropdown', 'Super Dropdown', 'Steam', 'Skype'}, current_option = 1, size = 20}),
            yui.FlatDropdown({title = 'Dropdown', options = {'Drop', 'Dropdown', 'Super Dropdown', 'Steam', 'Skype'}, current_option = 1, size = 20}),
            yui.FlatTextinput({}),
            yui.Textinput({}),
            yui.VerticalSpacing({h = 100}),
            yui.ImageButton({image = love.graphics.newImage('hxh2.jpg'), ix = 200, iy = 200, w = 200, h = 200}),
            yui.IconButton({icon = 'fa-close', hover = 'Close', size = 40, onClick = function(self) print(1) end}),
            yui.Button({size = 20, hover = 'Button', icon = 'fa-check', icon_right = true, text = 'Button'}),
            yui.Tabs({
                tabs = {
                    {text = 'Asahfdfj', hover = 'Aiuue'},
                    {text = 'shfd', hover = 'Ahdueieoooooo'},   
                    {text = 'adwdsfsdfsdssahfdfj', hover = 'Hue'},   
                }
            }),
        })
    })
end

function love.update(dt)
    view:update(dt)
end

function love.draw()
    view:draw()
end
