-- Popcorn Time

main = View(0, 0, w, h, {
    Stack({name = 'Main',
        Flow({name = 'TopBar',

            Tabs({name = 'LeftTabs',
                TabButton({title = 'Movies', hover = 'YTS'}),
                TabButton({title = 'TV Series', hover = 'TVAPI'}),
                TabButton({title = 'Anime', hover = 'Haruhichan'}),
            }),
            Spacing(10),
            Dropdown({title = 'Genre', options = {'All', ...}}),
            Dropdown({title = 'Sort By', options = {'Popularity', ...}}),

            right = {
                SearchButton({default_text = 'Search'}),
                IconButton({hover = 'Randomize', icon = icon_img}),
                IconButton({hover = 'Connection', icon = icon_img}),
                IconButton({hover = 'Watchlist', icon = icon_img}),
                IconButton({hover = 'Favorites', icon = icon_img}),
                IconButton({hover = 'Torrents', icon = icon_img}),
                IconButton({hover = 'About', icon = icon_img}),
                IconButton({hover = 'Settings', icon = icon_img}),
            },
        }),
    }),
})

main.layout.Main.TopBar.LeftTabs.Movies.onSelect = function() changeMainDropdowns('Movies') end
main.layout.Main.TopBar.LeftTabs['TV Series'].onSelect = function() changeMainDropdowns('TV Series') end
main.layout.Main.TopBar.LeftTabs.Anime.onSelect = function() changeMainDropdowns('TV Series') end
main.layout.Main.TopBar.Genre.onSelect = function(options) contentApplicationFunction(options) end
main.layout.Main.TopBar['Sort By'].onSelect = function(options) contentApplicationFunction(options) end
main.layout.Main.TopBar.right[1].onEnter = function(text) searchApplicationFunction(text) end
main.layout.Main.TopBar.right[8].onClick = function() changeToSettingsView() end

changeMainDropdowns = function(state)
    if state == 'Movies' or state == 'TV Series' then
        main.layout.Main.TopBar[3] = Dropdown({title = 'Genre', options = {'All', }})
        main.layout.Main.TopBar[4] = Dropdown({title = 'Sort By', options = {'Popularity', }})
    elseif state == 'Anime' then
        main.layout.Main.TopBar[3] = Dropdown({title = 'Type', options = {'All', }})
        main.layout.Main.TopBar[4] = Dropdown({title = 'Genre', options = {'All', }})
        main.layout.Main.TopBar[5] = Dropdown({title = 'Sort By', options = {'Popularity', }})
    end
end

settings = View(0, 0, w, h, {
    overlay = {
        IconButton({icon = icon_img})
    },

    Stack({name = 'Main',
        Flow({name = 'Settings',
            Stack({name = 'LeftBar',
                Text('Settings', {bold = true, color = 'white', size = n}),
                Text('User interface', {color = 'blue', size = n-m}),
                Spacing(x),
                Text('Subtitles', {color = 'blue', size = n-m}),
                Spacing(y),
                Text('Quality', {color = 'blue', size = n-m}),
                Spacing(z),
                Text('Playback', {color = 'blue', size = n-m}),
                Spacing(a),
                Text('Trakt.tv', {color = 'blue', size = n-m}),
                Spacing(b),
                Text('TVShow Time', {color = 'blue', size = n-m}),
                Spacing(c),
                Text('Features', {color = 'blue', size = n-m}),
                Spacing(d),
                Text('Remote Control', {color = 'blue', size = n-m}),
                Spacing(e),
                Text('Connection', {color = 'blue', size = n-m}),
                Spacing(f),
                Text('Cache Directory', {color = 'blue', size = n-m}),
                Spacing(g),
                Text('Database', {color = 'blue', size = n-m}),
                Spacing(h),
                Text('Miscellaneous', {color = 'blue', size = n-m}),
            }),

            VerticalSeparator(),

            Stack({name = 'RightContent',
                Flow({
                    IconButton({hover = 'Keyboard Shortcuts', icon = icon_img}),
                    IconButton({hover = 'Help Section', icon = icon_img}),
                    Checkbox({checked = application.show_advanced_settings, text = 'Show advanced settings'}),
                }),
                Spacing(10),
                -- ... and so on
            })
        }),

        Flow({name = 'BottomButtons',
            right = {
                Button({title = 'Flush bookmarks database'}),
                Button({title = 'Flush subtitles cache'}),
                Button({title = 'Flush all databases'}),
                Button({title = 'Reset to Default settings'}),
            },
        })
    }),
})
