foo = require 'footsies'

function love.load()
    foo.UI.registerEvents()

    test1 = foo.View(50, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        foo.Stack({name = 'MainStack', spacing = 4,
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
        })
    })

    test2 = foo.View(200, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        foo.Flow({name = 'MainStack', spacing = 4,
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
        })
    })

    test3 = foo.View(350, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        foo.Flow({name = 'MainStack', spacing = 4,
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            foo.Stack({name = 'MainStack', spacing = 4,
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
            })
        })
    })

    test4 = foo.View(500, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        foo.Stack({name = 'MainStack', spacing = 4,
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            foo.Flow({name = 'MainStack', spacing = 4,
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
            })
        })
    })

    test5 = foo.View(50, 200, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        foo.Flow({name = 'MainStack', spacing = 4,
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            foo.Stack({name = 'MainStack', spacing = 4,
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                foo.Flow({name = 'MainStack', spacing = 4,
                    foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    foo.Stack({name = 'MainStack', spacing = 4,
                        foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                    })
                })
            })
        })
    })

    test6 = foo.View(200, 200, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        foo.Stack({name = 'MainStack', spacing = 4,
            foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            foo.Flow({name = 'MainStack', spacing = 4,
                foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                foo.Stack({name = 'MainStack', spacing = 4,
                    foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    foo.Flow({name = 'MainStack', spacing = 4,
                        foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                        foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                        foo.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
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
