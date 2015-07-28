yui = require 'yaoui'

--[[
winapi = require 'winapi'
require 'winapi.colorchooser'
require 'winapi.filedialogs'
]]--

function love.load()
    yui.UI.registerEvents()

    love.graphics.setBackgroundColor(23, 24, 27)

    --yui.debug_draw = true

    view = yui.View(50, 50, 200, 530, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Stack({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 40, onClick = function(self) print(1) end}),
            yui.Button({icon = 'fa-check', icon_right = true, text = 'Button', onClick = function(self) 
                --[[
                local cc, cust = winapi.CHOOSECOLOR({})
                cc = winapi.ChooseColor(cc)
                ]]--
                --[[
                local ok, info = winapi.GetSaveFileName({
                    title = 'Save this thing',
                    filter = {'All Files', '*.*', 'Text Files', '*.txt'},
                })
                ]]--
            end}),
            yui.Checkbox({text = 'Checkbox', size = 20}),
            yui.Text({text = 'Text', size = 20}),
            yui.HorizontalSeparator({w = 100}),
            yui.Dropdown({title = 'Dropdown', options = {'Drop', 'Dropdown', 'Super Dropdown', 'Steam', 'Skype'}, 
                          current_option = 1, size = 20, onSelect = function(self, option) print(option) end}),
            yui.FlatDropdown({title = 'Dropdown', options = {'Drop', 'Dropdown', 'Super Dropdown', 'Steam', 'Skype'}, 
                              current_option = 1, size = 20, onSelect = function(self, option) print(option) end}),
            yui.FlatTextinput({}), 
            yui.Textinput({}), 
        })
    })
end

function love.update(dt)
    view:update(dt)
end

function love.draw()
    view:draw()
end
