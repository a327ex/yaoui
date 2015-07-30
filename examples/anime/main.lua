yui = require 'yaoui'

function love.load()
    yui.UI.registerEvents()
    love.graphics.setBackgroundColor(23, 24, 27)
    love.window.setMode(1200, 755)

    -- Create anime grid
    anime_view = generateAnimeGrid('All')

    -- Create top left tabs bar
    tabs_bar = yui.View(0, 0, 600, 80, {
        yui.Stack({
            bottom = {
                yui.Flow({
                    yui.Tabs({
                        tabs = {
                            {text = 'All', hover = 'All', onClick = function(self) anime_view = regenerateAnimeGrid('All') end},
                            {text = 'Action', hover = 'Action', onClick = function(self) anime_view = regenerateAnimeGrid({'Action'}) end},
                            {text = 'Fantasy', hover = 'Fantasy', onClick = function(self) anime_view = regenerateAnimeGrid({'Fantasy'}) end},
                            {text = 'Magic', hover = 'Magic', onClick = function(self) anime_view = regenerateAnimeGrid({'Magic'}) end},
                            {text = 'Sci-Fi', hover = 'Sci-Fi', onClick = function(self) anime_view = regenerateAnimeGrid({'Sci-Fi'}) end},
                            {text = 'Shounen', hover = 'Shounen', onClick = function(self) anime_view = regenerateAnimeGrid({'Shounen'}) end},
                            {text = 'Super Power', hover = 'Super Power', onClick = function(self) anime_view = regenerateAnimeGrid({'Super Power'}) end},
                            {text = 'Supernatural', hover = 'Supernatural', onClick = function(self) anime_view = regenerateAnimeGrid({'Supernatural'}) end},
                        }
                    }),
                }),
            }
        })
    })

    -- Create top right dropdown + settings bar
    right_bar = yui.View(600, 0, 600, 80, {
        yui.Stack({
            bottom = {
                yui.Flow({margin_right = 10, spacing = 5,
                    yui.Dropdown({
                        options = { 
                            'All',
                            'Action', 'Adventure', 'Comedy', 'Drama', 'Fantasy', 'Historical', 'Horror', 'Magic', 'Mecha', 'Military', 'Music', 
                            'Mystery', 'Parody', 'Police', 'Psychological', 'Romance', 'Samurai', 'School', 'Sci-Fi', 'Seinen', 'Shounen', 
                            'Slice of Life', 'Space', 'Sports', 'Super Power', 'Supernatural', 'Thriller',
                        },

                        onSelect = function(self, option) 
                            if option == 'All' then anime_view = regenerateAnimeGrid(option) 
                            else anime_view = regenerateAnimeGrid({option}) end
                        end,
                    }),

                    right = {
                        yui.IconButton({icon = 'fa-cutlery', hover = 'PORN', size = 28}),
                        yui.IconButton({icon = 'fa-eye', hover = 'PORN', size = 28}),
                        yui.HorizontalSpacing({w = 1}),
                        yui.IconButton({icon = 'fa-wheelchair', hover = 'PORN', size = 28}),
                        yui.IconButton({icon = 'fa-bell', hover = 'the Bells of Awakening', size = 28}),
                        yui.IconButton({icon = 'fa-tree', hover = 'PORN', size = 28}),
                        yui.IconButton({icon = 'fa-cog', hover = 'Settings', size = 28}),
                    },
                })
            }
        })
    })

    -- Store ImageButton objects so that they don't have to be recreated on regeneration
    -- Recreating too many objects (which would happen if we recreated them on every regeneration)
    -- currently bugs Thranduil out and I haven't figured out a fix
    animes = {}
    for i = 1, 8 do table.insert(animes, anime_view[1][1][i]) end
    for i = 1, 8 do table.insert(animes, anime_view[1][2][i]) end
    for i = 1, 8 do table.insert(animes, anime_view[1][3][i]) end
end

function love.update(dt)
    yui.update({anime_view, tabs_bar, right_bar})
    anime_view:update(dt)
    tabs_bar:update(dt)
    right_bar:update(dt)
end

function love.draw()
    anime_view:draw()
    love.graphics.setColor(unpack(yui.Theme.colors.hover_bg))
    love.graphics.rectangle('fill', 0, 0, 1200, 80)
    love.graphics.setColor(255, 255, 255)
    tabs_bar:draw()
    right_bar:draw()
end

function regenerateAnimeGrid(genres_filter)
    local animeGenreInGenresFilter = function(anime_genres, genres_filter)
        for _, genre in ipairs(anime_genres) do
            for _, filter_genre in ipairs(genres_filter) do
                if genre == filter_genre then return true end
            end
        end
    end

    local anime_info = getAnimeInfo()
    local grid = {}
    for i = 1, 24 do
        local insert_current_anime = false
        if genres_filter == 'All' then insert_current_anime = true
        elseif animeGenreInGenresFilter(anime_info[i].genres, genres_filter) then insert_current_anime = true end
        if insert_current_anime then table.insert(grid, animes[i]) end
    end

    local rows = {}
    rows[1], rows[2], rows[3] = {}, {}, {}
    for i = 1, 8 do table.insert(rows[1], grid[i]) end
    for i = 9, 16 do table.insert(rows[2], grid[i]) end
    for i = 17, 24 do table.insert(rows[3], grid[i]) end

    local anime_view = yui.View(0, 80, 1200, 755, {
        yui.Stack({
            yui.Flow(rows[1]),
            yui.Flow(rows[2]),
            yui.Flow(rows[3]),
        })
    })
    return anime_view
end

function generateAnimeGrid()
    local anime_info = getAnimeInfo()
    local grid = {}
    for i = 1, 24 do
        table.insert(grid, yui.ImageButton({
            image = anime_info[i].image, 
            w = 150, h = 225, 
            ix = anime_info[i].image_offsets[1] or 0, 
            iy = anime_info[i].image_offsets[2] or 0,

            onClick = function(self) 
                love.system.openURL(anime_info[i].link) 
            end,

            overlayNew = function(self)
                self.font_awesome_font = love.graphics.newFont(self.yui.Theme.font_awesome_path, 14)
                self.overlay_font = love.graphics.newFont(self.yui.Theme.open_sans_bold, 14)
                self.title = anime_info[i].title
                self.score = anime_info[i].score
            end,

            overlay = function(self)
                -- Draw overlay rectangle
                love.graphics.setColor(50, 50, 50, self.alpha/3)
                love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

                -- Draw title
                if self.title then
                    local r, g, b = unpack(self.yui.Theme.colors.text_light)
                    love.graphics.setColor(r, g, b, self.alpha)
                    love.graphics.setFont(self.overlay_font)
                    if type(self.title) == 'string' then
                        love.graphics.print(self.title, self.x + self.w - self.overlay_font:getWidth(self.title) - 10, self.y + 5)
                    elseif type(self.title) == 'table' then
                        love.graphics.print(self.title[1], self.x + self.w - self.overlay_font:getWidth(self.title[1]) - 10, self.y + 5)
                        love.graphics.print(self.title[2], self.x + self.w - self.overlay_font:getWidth(self.title[2]) - 10, self.y + self.overlay_font:getHeight() + 5)
                    end
                    love.graphics.setColor(255, 255, 255, 255)
                end

                -- Draw score 
                love.graphics.setColor(255, 255, 255, self.alpha)
                local score_text = self.score .. '/10'
                local score_text_w = self.overlay_font:getWidth(score_text)
                love.graphics.print(score_text, 
                                    self.x + self.w - score_text_w - 5, 
                                    self.y + self.h - 5 - self.overlay_font:getHeight())

                -- Draw stars
                love.graphics.setFont(self.font_awesome_font)
                love.graphics.setColor(222, 222, 64, self.alpha)
                love.graphics.setScissor(self.x + 5, 
                                         self.y + self.h - 6 - self.font_awesome_font:getHeight(), 
                                         (self.score/10)*75, 
                                         self.font_awesome_font:getHeight())
                love.graphics.print(self.yui.Theme.font_awesome['fa-star'], self.x + 5, self.y + self.h - 6 - self.font_awesome_font:getHeight())
                love.graphics.print(self.yui.Theme.font_awesome['fa-star'], self.x + 5 + 15, self.y + self.h - 6 - self.font_awesome_font:getHeight())
                love.graphics.print(self.yui.Theme.font_awesome['fa-star'], self.x + 5 + 30, self.y + self.h - 6 - self.font_awesome_font:getHeight())
                love.graphics.print(self.yui.Theme.font_awesome['fa-star'], self.x + 5 + 45, self.y + self.h - 6 - self.font_awesome_font:getHeight())
                love.graphics.print(self.yui.Theme.font_awesome['fa-star'], self.x + 5 + 60, self.y + self.h - 6 - self.font_awesome_font:getHeight())
                love.graphics.setScissor()
                love.graphics.setFont(self.overlay_font)
                love.graphics.setColor(255, 255, 255, 255)
            end,
        })) 
    end

    local rows = {}
    rows[1], rows[2], rows[3] = {}, {}, {}
    for i = 1, 8 do table.insert(rows[1], grid[i]) end
    for i = 9, 16 do table.insert(rows[2], grid[i]) end
    for i = 17, 24 do table.insert(rows[3], grid[i]) end

    local anime_view = yui.View(0, 80, 1200, 755, {
        yui.Stack({
            yui.Flow(rows[1]),
            yui.Flow(rows[2]),
            yui.Flow(rows[3]),
        })
    })
    return anime_view
end

function getAnimeInfo()
    local info = {}

    local titles = {
        'Shin Sekai Yori', 'Hunter x Hunter', {'Fullmetal Alchemist', 'Brotherhood'}, 'Steins;Gate', 'Gintama', {'Clannad', 'After Story'},
        {'Great Teacher', 'Onizuka'}, 'Death Note', 'Monster', {"Howl's Moving", "Castle"}, 'Haikyuu!!', 'Attack on Titan',
        {'The Disappearance', 'of Haruhi Suzumiya'}, 'Hajime no Ippo', 'Samurai X', 'Gurren Lagann', 'Mononoke Hime', 'Fate/Zero',
        {'Legend of Galactic', 'Heroes'}, 'Code Geass', 'Spirited Away', 'Your Lie in April', 'Mushishi', 'Wolf Children'
    }

    local scores = {
        8.54, 9.15, 9.25, 9.18, 9.16, 9.12,
        8.79, 8.76, 8.75, 8.73, 8.67, 8.68,
        8.88, 8.86, 8.45, 8.82, 8.81, 8.58,
        9.08, 8.86, 8.93, 8.93, 8.80, 8.88,
    }

    local genres = {
        {'Mystery', 'Drama', 'Horror', 'Sci-Fi', 'Supernatural'},
        {'Action', 'Adventure', 'Shounen', 'Super Power'},
        {'Action', 'Adventure', 'Drama', 'Fantasy', 'Magic', 'Shounen', 'Military'},
        {'Sci-Fi', 'Thriller'},
        {'Action', 'Comedy', 'Historical', 'Parody', 'Samurai', 'Sci-Fi', 'Shounen'},
        {'Drama', 'Fantasy', 'Romance', 'Slice of Life', 'Supernatural'},
        {'Comedy', 'Drama', 'School', 'Shounen', 'Slice of Life'},
        {'Mystery', 'Supernatural', 'Police', 'Psychological', 'Thriller'},
        {'Mystery', 'Drama', 'Horror', 'Police', 'Psychological', 'Thriller', 'Seinen'},
        {'Adventure', 'Drama', 'Fantasy', 'Romance'},
        {'Comedy', 'Drama', 'School', 'Shounen', 'Sports'},
        {'Action', 'Drama', 'Fantasy', 'Shounen', 'Super Power'},
        {'Comedy', 'Mystery', 'Romance', 'School', 'Sci-Fi', 'Supernatural'},
        {'Comedy', 'Drama', 'Shounen', 'Sports'},
        {'Action', 'Adventure', 'Comedy', 'Historical', 'Samurai', 'Romance'},
        {'Action', 'Comedy', 'Mecha', 'Sci-Fi'},
        {'Action', 'Adventure', 'Fantasy'},
        {'Action', 'Fantasy', 'Supernatural'},
        {'Drama', 'Sci-Fi', 'Space', 'Military'},
        {'Action', 'Mecha', 'School', 'Sci-Fi', 'Super Power', 'Military'},
        {'Adventure', 'Drama', 'Supernatural'},
        {'Drama', 'Music', 'Romance', 'School', 'Shounen'},
        {'Adventure', 'Mystery', 'Fantasy', 'Historical', 'Slice of Life', 'Supernatural', 'Seinen'},
        {'Fantasy', 'Slice of Life'},
    }

    local images = {
        love.graphics.newImage('images/ssy.jpg'),
        love.graphics.newImage('images/hxh.jpg'),
        love.graphics.newImage('images/fma.jpg'),
        love.graphics.newImage('images/sg.jpg'),
        love.graphics.newImage('images/gin.jpg'),
        love.graphics.newImage('images/clan.jpg'),
        love.graphics.newImage('images/oni.jpg'),
        love.graphics.newImage('images/dn.jpg'),
        love.graphics.newImage('images/mons.jpg'),
        love.graphics.newImage('images/howl.jpg'),
        love.graphics.newImage('images/hai.jpg'),
        love.graphics.newImage('images/tit.jpg'),
        love.graphics.newImage('images/haru.jpg'),
        love.graphics.newImage('images/ippo.jpg'),
        love.graphics.newImage('images/x.jpg'),
        love.graphics.newImage('images/lag.jpg'),
        love.graphics.newImage('images/hime.jpg'),
        love.graphics.newImage('images/fate.jpg'),
        love.graphics.newImage('images/den.jpg'),
        love.graphics.newImage('images/geass.jpg'),
        love.graphics.newImage('images/sen.jpg'),
        love.graphics.newImage('images/lie.jpg'),
        love.graphics.newImage('images/shi.jpg'),
        love.graphics.newImage('images/wolf.jpg'),
    }

    local image_offsets = {
        {450, 160}, {55, 50}, {40, 60}, {50, 80}, {20, 0}, {260, 130}, {10, 10}, {30, 30},
        {175, 80}, {70, 0}, {150, 240}, {240, 40}, {45, 60}, {20, 0}, {50, 80}, {25, 0},
        {60, 20}, {180, 180}, {80, 0}, {30, 10}, {50, 25}, {20, 30}, {25, 80}, {50, 120},
    }

    local links = {
        'http://myanimelist.net/anime/13125/Shinsekai_yori',
        'http://myanimelist.net/anime/11061/Hunter_x_Hunter_%282011%29',
        'http://myanimelist.net/anime/5114/Fullmetal_Alchemist:_Brotherhood',
        'http://myanimelist.net/anime/9253/Steins;Gate',
        'http://myanimelist.net/anime/28977/Gintama%C2%B0',
        'http://myanimelist.net/anime/4181/Clannad:_After_Story',
        'http://myanimelist.net/anime/245/Great_Teacher_Onizuka',
        'http://myanimelist.net/anime/1535/Death_Note',
        'http://myanimelist.net/anime/19/Monster',
        'http://myanimelist.net/anime/431/Howl_no_Ugoku_Shiro',
        'http://myanimelist.net/anime/20583/Haikyuu!!',
        'http://myanimelist.net/anime/16498/Shingeki_no_Kyojin',
        'http://myanimelist.net/anime/7311/Suzumiya_Haruhi_no_Shoushitsu',
        'http://myanimelist.net/anime/263/Hajime_no_Ippo',
        'http://myanimelist.net/anime/45/Rurouni_Kenshin:_Meiji_Kenkaku_Romantan',
        'http://myanimelist.net/anime/2001/Tengen_Toppa_Gurren_Lagann',
        'http://myanimelist.net/anime/164/Mononoke_Hime',
        'http://myanimelist.net/anime/10087/Fate_Zero',
        'http://myanimelist.net/anime/820/Ginga_Eiyuu_Densetsu',
        'http://myanimelist.net/anime/1575/Code_Geass:_Hangyaku_no_Lelouch',
        'http://myanimelist.net/anime/199/Sen_to_Chihiro_no_Kamikakushi',
        'http://myanimelist.net/anime/23273/Shigatsu_wa_Kimi_no_Uso',
        'http://myanimelist.net/anime/457/Mushishi',
        'http://myanimelist.net/anime/12355/Ookami_Kodomo_no_Ame_to_Yuki',
    }

    for i = 1, 24 do
        table.insert(info, {
            title = titles[i],
            link = links[i],
            score = scores[i],
            image = images[i],
            image_offsets = image_offsets[i] or {},
            genres = genres[i],
        })
    end

    return info
end
