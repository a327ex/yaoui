yui = require 'yaoui'

function love.load()
    yui.UI.registerEvents()

    test1 = yui.View(50, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Stack({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
        })
    })

    test2 = yui.View(200, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Flow({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
        })
    })

    test3 = yui.View(350, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Flow({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            yui.Stack({name = 'MainStack', spacing = 4,
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
            })
        })
    })

    test4 = yui.View(500, 50, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Stack({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            yui.Flow({name = 'MainStack', spacing = 4,
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
            })
        })
    })

    test5 = yui.View(50, 200, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Flow({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            yui.Stack({name = 'MainStack', spacing = 4,
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                yui.Flow({name = 'MainStack', spacing = 4,
                    yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    yui.Stack({name = 'MainStack', spacing = 4,
                        yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                    })
                })
            })
        })
    })

    test6 = yui.View(200, 200, 100, 100, {margin_left = 4, margin_right = 4, margin_top = 4, margin_bottom = 4,
        yui.Stack({name = 'MainStack', spacing = 4,
            yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(1) end}),
            yui.Flow({name = 'MainStack', spacing = 4,
                yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(2) end}),
                yui.Stack({name = 'MainStack', spacing = 4,
                    yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(3) end}),
                    yui.Flow({name = 'MainStack', spacing = 4,
                        yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                        yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
                        yui.IconButton({icon = 'fa-close', size = 20, onClick = function(self) print(4) end}),
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
