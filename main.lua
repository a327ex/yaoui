yui = require 'yaoui'

function love.load()
    yui.UI.registerEvents()

    view = yui.View(50, 50, 200, 200, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Stack({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 40, onClick = function(self) print(1) end}),
            yui.Button({icon = 'fa-close', size = 40, text = 'Button', onClick = function(self) print(2) end}),
        })
    })
end

function love.update(dt)
    view:update(dt)
end

function love.draw()
    view:draw()
end
