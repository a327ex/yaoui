Blade = require 'Blade'

function love.load()
    Blade.UI.registerEvents()
    view = Blade.View(0, 0, 100, 100, {
        Blade.Stack({name = 'MainStack',
            Blade.IconButton({name = 'CloseButton', icon = 'fa-close', size = 80, onClick = function(self) print(1) end})
        })
    })
end

function love.update(dt)
    view:update(dt)
end

function love.draw()
    view:draw()
end
