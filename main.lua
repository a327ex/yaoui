Blade = require 'Blade'

function love.load()
    Blade.UI.registerEvents()

    test1 = Blade.View(50, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        Blade.Stack({name = 'MainStack', spacing = 4,
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
        })
    })

    test2 = Blade.View(200, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        Blade.Flow({name = 'MainStack', spacing = 4,
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
        })
    })

    test3 = Blade.View(350, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        Blade.Flow({name = 'MainStack', spacing = 4,
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            Blade.Stack({name = 'MainStack', spacing = 4,
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
            })
        })
    })

    test4 = Blade.View(500, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        Blade.Stack({name = 'MainStack', spacing = 4,
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            Blade.Flow({name = 'MainStack', spacing = 4,
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
            })
        })
    })

    test5 = Blade.View(50, 200, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        Blade.Flow({name = 'MainStack', spacing = 4,
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            Blade.Stack({name = 'MainStack', spacing = 4,
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                Blade.Flow({name = 'MainStack', spacing = 4,
                    Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    Blade.Stack({name = 'MainStack', spacing = 4,
                        Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                    })
                })
            })
        })
    })

    test6 = Blade.View(200, 200, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        Blade.Stack({name = 'MainStack', spacing = 4,
            Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            Blade.Flow({name = 'MainStack', spacing = 4,
                Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                Blade.Stack({name = 'MainStack', spacing = 4,
                    Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    Blade.Flow({name = 'MainStack', spacing = 4,
                        Blade.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                    })
                })
            })
        })
    })
end

function love.update(dt)
    test1:update(dt)
    test2:update(dt)
    test3:update(dt)
    test4:update(dt)
    test5:update(dt)
    test6:update(dt)
end

function love.draw()
    test1:draw()
    test2:draw()
    test3:draw()
    test4:draw()
    test5:draw()
    test6:draw()
end
