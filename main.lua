Blade = require 'Blade'

function love.load()
    Blade.UI.registerEvents()
    view = Blade.View(50, 50, 600, 400, {
        Blade.Stack({name = 'MainStack',
            Blade.Flow({name = 'Flow1',
                Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(1) end}),
                Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(1) end}),
            }),
            Blade.Flow({name = 'Flow2',
                Blade.Stack({name = 'Stack1',
                    Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(2) end}),
                    Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(3) end}),
                    Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(4) end}),
                }),
                Blade.Stack({name = 'Stack2',
                    Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(5) end}),
                    Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(6) end}),
                    Blade.IconButton({icon = 'fa-close', size = 80, onClick = function(self) print(7) end}),
                }),
            })
        })
    })
end

function love.update(dt)
    view:update(dt)
end

function love.draw()
    view:draw()
end
