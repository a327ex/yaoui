local text_path = (...):match('(.-)[^%.]+$') .. '.'
local Text = {}
Text.__index = Text
require(text_path .. 'utf8-l')

local tableContains = function(t, value) for k, v in pairs(t) do if v == value then return true end end end
local stringToAny = function(str) return loadstring("return " .. str)() end

function Text.new(x, y, text, settings)
    local self = {}
    self.x, self.y = x, y
    local settings = settings or {}
    for k, v in pairs(settings) do self[k] = v end

    text = string.gsub(text, '\n', '@n')
    text = string.gsub(text, '\r', '@n')
    self.text = text
    self.config = settings
    if not self.font then self.font = love.graphics.getFont() end
    self.font_multiplier = settings.font_multiplier or 1

    -- Store modifier names and parameters in m
    local m = {}
    local i = 1
    while i <= text:utf8len() do
        local c = text:utf8sub(i, i)
        local d = text:utf8sub(i+1, i+1)

        if c == '@' and (d == '[' or d == ']' or d == '(' or d == ')' or d == '@' or d == 'n') then i = i + 1 end

        if c == '[' then
            local modifier = {}
            modifier.init_text_delimiter = i
            -- Look for pairing ']'
            local delimiter_ignore = 0
            local finding_pair = true
            local j = 0
            while finding_pair do
                j = j + 1
                local d = text:utf8sub(i+j, i+j) 
                local e = text:utf8sub(i+j+1, i+j+1)
                if d == '@' and (e == '[' or e == ']' or e == '(' or e == ')' or e == '@' or e == 'n') then j = j + 1 end
                if d == '[' then delimiter_ignore = delimiter_ignore + 1 end -- [ inside [, delimiter_ignore++ to ignore next ]
                if d == ']' and delimiter_ignore == 0 then finding_pair = false end -- reached the final pairing ], end loop
                if d == ']' and delimiter_ignore > 0 then delimiter_ignore = delimiter_ignore - 1 end -- ignore ] if delimiter_ignore > 0 
            end
            modifier.end_text_delimiter = i+j
            modifier.text = text:utf8sub(modifier.init_text_delimiter+1, modifier.end_text_delimiter-1)
            local k = i+j+1
            modifier.init_modifier_delimiter = k
            -- Look for pairing ')'
            finding_pair = true
            j = 0
            while finding_pair do
                j = j + 1
                local d = text:utf8sub(k+j, k+j)
                if d == ')' then finding_pair = false end -- reached the final pairing ), end loop
            end
            modifier.end_modifier_delimiter = k+j
            modifier.modifier_text = text:utf8sub(modifier.init_modifier_delimiter+1, modifier.end_modifier_delimiter-1)
            table.insert(m, modifier)
        end
        i = i + 1
    end

    --[[
    print(self.text)
    print()
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        print(w.init_text_delimiter, w.end_text_delimiter, w.init_modifier_delimiter, w.end_modifier_delimiter)
        print()
    end
    print()
    ]]--

    -- Assign correct modifier texts to each word in a manner that respects recursion
    for i, w in ipairs(m) do
        if w.text:find('[', 1, true) then
            local j, k = w.text:find('[', 1, true) 
            if (w.text:utf8sub(j-1, j-1) == '@' and w.text:utf8sub(j-2, j-2) == '@') or (w.text:utf8sub(j-1, j-1) ~= '@') then
                for j, in_w in ipairs(m) do
                    if in_w.init_text_delimiter > w.init_text_delimiter and
                       in_w.end_text_delimiter < w.end_text_delimiter then
                        in_w.modifier_text = in_w.modifier_text .. '; ' .. w.modifier_text
                    end
                end
            end
        end
    end

    --[[
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        print(w.init_text_delimiter, w.end_text_delimiter, w.init_modifier_delimiter, w.end_modifier_delimiter)
        print()
    end
    print()
    ]]--

    -- Remove extra spaces and @
    for i, modifier in ipairs(m) do
        -- Remove spaces from modifier texts
        modifier.modifier_text = modifier.modifier_text:gsub(' ', '')
        -- Remove @ if preceeds []()@
        local i, j = 0, 0
        while j do
            i = modifier.text:find('@', j+1, true)
            if i then 
                j = i
                local c = modifier.text:utf8sub(i+1, i+1)
                if c == '(' or c == ')' or c == '[' or c == ']' or c == '@' or c == 'n' then
                    modifier.text = modifier.text:utf8sub(1, i-1) .. modifier.text:utf8sub(i+1)
                end
            else j = nil end
        end
    end

    --[[
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        print()
    end
    ]]--

    -- Turn modifier_texts into tables
    for i, w in ipairs(m) do
        local i, j = 0, 0
        w.modifiers = {}
        while i do
            i = w.modifier_text:find(';', i+1, true)
            if i then
                table.insert(w.modifiers, w.modifier_text:utf8sub(j+1, i-1))
                j = i
            else
                table.insert(w.modifiers, w.modifier_text:utf8sub(j+1, w.modifier_text:utf8len())) 
            end
        end
    end

    --[[
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        for _, u in ipairs(w.modifiers) do
            print(u)
        end
        print()
    end
    ]]--

    -- Turn modifier_texts that have parameters into tables
    for a, w in ipairs(m) do
        for b, u in ipairs(w.modifiers) do
            if u:find(':', 1, true) then
                local mod_params = {}
                local i = u:find(':', 1, true)
                table.insert(mod_params, u:utf8sub(1, i-1))
                local params = u:sub(i+1, u:utf8len())
                local j, k = 0, 0
                while j do
                    j = params:find(',', j+1, true)
                    if j then
                        table.insert(mod_params, params:utf8sub(k+1, j-1))
                        k = j
                    else
                        table.insert(mod_params, params:utf8sub(k+1, params:utf8len()))
                    end
                end
                w.modifiers[b] = mod_params
            end
        end
    end

    --[[
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        for _, u in ipairs(w.modifiers) do
            if type(u) == 'table' then
                for _, v in ipairs(u) do
                    print(v)
                end
            else print(u) end
        end
        print()
    end
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        print(w.init_text_delimiter, w.end_text_delimiter, w.init_modifier_delimiter, w.end_modifier_delimiter)
        print()
    end
    print()
    ]]--

    -- Strip text, removing [], () and everything inside ()
    local n_a_positions = {}
    local new_line_positions = {}
    local stripped_text = ""
    local delimiter = 0 
    local modifier_delimiter = 0
    local i = 1
    while i <= text:len() do
        local c = text:utf8sub(i, i)
        local d = text:utf8sub(i+1, i+1)
        if c == '[' then delimiter = delimiter + 1 end
        if c == ']' then delimiter = delimiter - 1 end
        if c == '(' then modifier_delimiter = modifier_delimiter + 1 end
        if c == ')' then modifier_delimiter = modifier_delimiter - 1 end

        if modifier_delimiter == 0 then 
            if c ~= '[' and c ~= ']' and c ~= '(' and c ~= ')' then
                if c == '@' and (d == '(' or d == ')' or d == '[' or d == ']' or d == '@') then 
                    stripped_text = stripped_text .. d
                    table.insert(n_a_positions, i) 
                    i = i + 1
                elseif c == '@' and d == 'n' then 
                    table.insert(new_line_positions, i)
                    i = i + 1 
                elseif c == '@' then stripped_text = stripped_text .. c
                else stripped_text = stripped_text .. c end
            end
        end
        i = i + 1
    end

    -- Recalculate m delimiter positions
    -- Recalculate @ removal
    for _, w in ipairs(m) do
        local witd, wetd = w.init_text_delimiter, w.end_text_delimiter
        local wimd, wemd = w.init_modifier_delimiter, w.end_modifier_delimiter
        for _, p in ipairs(n_a_positions) do
            if w.init_text_delimiter > p then
                witd = witd - 1
            end
            if w.end_text_delimiter > p then
                wetd = wetd - 1
            end
            if w.init_modifier_delimiter > p then
                wimd = wimd - 1
            end
            if w.end_modifier_delimiter > p then
                wemd = wemd - 1
            end
        end
        w.init_text_delimiter, w.end_text_delimiter = witd, wetd
        w.init_modifier_delimiter, w.end_modifier_delimiter = wimd, wemd

        local witd, wetd = w.init_text_delimiter, w.end_text_delimiter
        local wimd, wemd = w.init_modifier_delimiter, w.end_modifier_delimiter
        for _, p in ipairs(new_line_positions) do
            if w.init_text_delimiter > p then
                witd = witd - 2
            end
            if w.end_text_delimiter > p then
                wetd = wetd - 2
            end
            if w.init_modifier_delimiter > p then
                wimd = wimd - 2
            end
            if w.end_modifier_delimiter > p then
                wemd = wemd - 2
            end
        end
        w.init_text_delimiter, w.end_text_delimiter = witd, wetd
        w.init_modifier_delimiter, w.end_modifier_delimiter = wimd, wemd
    end
    for i, p in ipairs(new_line_positions) do
        for j, q in ipairs(new_line_positions) do
            if q > p then
                new_line_positions[j] = new_line_positions[j] - 2
            end
        end
    end

    -- Recalculate [ removal
    for _, w in ipairs(m) do
        w.end_text_delimiter = w.end_text_delimiter - 1
        w.init_modifier_delimiter = w.init_modifier_delimiter - 1
        w.end_modifier_delimiter = w.end_modifier_delimiter - 1

        for _, u in ipairs(m) do
            if u.init_text_delimiter > w.init_text_delimiter then
                u.init_text_delimiter = u.init_text_delimiter - 1
            end
            if u.end_text_delimiter > w.init_text_delimiter then
                u.end_text_delimiter = u.end_text_delimiter - 1
            end
            if u.init_modifier_delimiter > w.init_text_delimiter then
                u.init_modifier_delimiter = u.init_modifier_delimiter - 1
                u.end_modifier_delimiter = u.end_modifier_delimiter - 1
            end
        end

        for i, p in ipairs(new_line_positions) do
            if p > w.init_text_delimiter then
                new_line_positions[i] = new_line_positions[i] - 1
            end
        end
    end

    -- Recalculate ] removal
    for _, w in ipairs(m) do
        w.init_modifier_delimiter = w.init_modifier_delimiter - 1
        w.end_modifier_delimiter = w.end_modifier_delimiter - 1

        for _, u in ipairs(m) do
            if u.init_text_delimiter > w.end_text_delimiter then
                u.init_text_delimiter = u.init_text_delimiter - 1
            end
            if u.end_text_delimiter > w.end_text_delimiter then
                u.end_text_delimiter = u.end_text_delimiter - 1
            end
            if u.init_modifier_delimiter > w.end_text_delimiter then
                u.init_modifier_delimiter = u.init_modifier_delimiter - 1
                u.end_modifier_delimiter = u.end_modifier_delimiter - 1
            end
        end

        for i, p in ipairs(new_line_positions) do
            if p > w.end_text_delimiter then
                new_line_positions[i] = new_line_positions[i] - 1
            end
        end
    end

    -- Recalculate (.....) removal
    for _, w in ipairs(m) do
        local d = w.end_modifier_delimiter - w.init_modifier_delimiter + 1

        for _, u in ipairs(m) do
            if u.init_text_delimiter > w.init_modifier_delimiter then
                u.init_text_delimiter = u.init_text_delimiter - d
            end
            if u.end_text_delimiter > w.init_modifier_delimiter then
                u.end_text_delimiter = u.end_text_delimiter - d
            end
            if u.init_modifier_delimiter > w.end_modifier_delimiter then
                u.init_modifier_delimiter = u.init_modifier_delimiter - d
                u.end_modifier_delimiter = u.end_modifier_delimiter - d
            end
        end

        for i, p in ipairs(new_line_positions) do
            if p > w.init_modifier_delimiter then
                new_line_positions[i] = new_line_positions[i] - d
            end
        end
    end

    -- Add new line positions when over wrap width
    local str = ""
    for i = 1, stripped_text:utf8len() do
        local c = stripped_text:utf8sub(i, i)

        local new_line_index = nil
        for _, p in ipairs(new_line_positions) do
            if i == p-1 then new_line_index = true end
        end

        if self.wrap_width then
            local w0 = self.font:getWidth(str .. stripped_text:utf8sub(i, i))*self.font_multiplier
            local w = self.font:getWidth(str .. stripped_text:utf8sub(i+1, i+1))*self.font_multiplier
            local previous_c = stripped_text:utf8sub(i-1, i-1)
            if previous_c == ' ' then
                local t = stripped_text:utf8sub(i, stripped_text:utf8len())
                local next_word = t:utf8sub(1, t:find(' '))
                local tw = self.font:getWidth(str .. next_word)*self.font_multiplier
                if tw > self.wrap_width then 
                    table.insert(new_line_positions, i) 
                    str = ""
                end
            elseif w0 > self.wrap_width then 
                table.insert(new_line_positions, i) 
                str = ""
            end
        end

        if not new_line_index then str = str .. c
        else str = "" end
    end
    table.sort(new_line_positions, function(a, b) return a < b end)

    --[[
    print(stripped_text)
    print()
    for _, w in ipairs(m) do
        print(w.text, w.modifier_text)
        print(w.init_text_delimiter, w.end_text_delimiter, w.init_modifier_delimiter, w.end_modifier_delimiter)
        print()
    end
    print()
    for _, p in ipairs(new_line_positions) do
        print(p)
    end
    print()
    ]]--

    self.str_text = stripped_text
    self.new_line_positions = new_line_positions

    self.characters = {}
    local str = ""
    local line = 0
    for i = 1, stripped_text:utf8len() do
        local c = stripped_text:utf8sub(i, i)
        local modifiers = {}
        for _, w in ipairs(m) do
            if i >= w.init_text_delimiter and i <= w.end_text_delimiter then
                modifiers = w.modifiers
            end
        end

        -- Move to new line if got to a @n
        for j, p in ipairs(new_line_positions) do
            if i == p and line < j then 
                line = j 
                str = ""
            end
        end

        local text_w = self.font:getWidth(str)*self.font_multiplier
        text_w = self.font:getWidth(str)*self.font_multiplier
        local w = self.font:getWidth(c)*self.font_multiplier

        local char_struct = {position = i, character = c, text = self, str_text = stripped_text, x = text_w, 
                             y = 0 + line*(self.line_height or 1)*self.font:getHeight()*self.font_multiplier, 
                             modifiers = modifiers, line = line, pivot = {x = 0, y = 0}}
        table.insert(self.characters, char_struct)
        str = str .. c
    end

    -- Set alignment
    if self.wrap_width then
        if self.align_right then
            for i = 0, line do
                local s = ''
                for j, c in ipairs(self.characters) do
                    if c.character == ' ' and self.characters[j+1] and self.characters[j+1].line == i+1 then break end
                    if c.line == i then s = s .. c.character end
                end
                local w = self.font:getWidth(s)*self.font_multiplier
                local add_x = self.wrap_width - w
                for _, c in ipairs(self.characters) do
                    if c.line == i then c.x = c.x + add_x end
                end
            end

        elseif self.align_center then
            for i = 0, line do
                local s = ''
                for j, c in ipairs(self.characters) do
                    if c.character == ' ' and self.characters[j+1] and self.characters[j+1].line == i+1 then break end
                    if c.line == i then s = s .. c.character end
                end
                local w = self.font:getWidth(s)*self.font_multiplier
                local add_x = (self.wrap_width - w)/2
                for _, c in ipairs(self.characters) do
                    if c.line == i then c.x = c.x + add_x end
                end
            end

        elseif self.justify then
            for i = 0, line do
                local s = ''
                local spaces = 0
                local lines_end = {}
                for j, c in ipairs(self.characters) do
                    if i == line and j == #self.characters then lines_end[i] = j; break end
                    if c.character == ' ' and self.characters[j+1] and self.characters[j+1].line == i+1 then lines_end[i] = j; break end
                    if c.line == i then s = s .. c.character end
                    if c.line == i and c.character == ' ' then spaces = spaces + 1 end
                end
                local w = self.font:getWidth(s)*self.font_multiplier
                if i == line then spaces = spaces + 1 end
                local add_x = (self.wrap_width - w)/spaces
                for j, c in ipairs(self.characters) do
                    if c.line == i and c.character == ' ' then 
                        for k = j+1, lines_end[i] do
                            self.characters[k].x = self.characters[k].x + add_x
                        end
                    end
                end
            end
        end
    end

    self.n_lines = #new_line_positions + 1
    self.dt = 0
    self.custom_draw = false
    for k, v in pairs(self) do
        if type(v) == 'function' and k == 'customDraw' then
            self.custom_draw = v
        end
    end

    -- Call Init functions from TextConfig
    for k, v in pairs(self) do
        if type(v) == 'function' then
            if k:find('Init', 1, true) then
                for _, c in ipairs(self.characters) do
                    local called_functions = {}
                    for _, modifier in ipairs(c.modifiers) do
                        if type(modifier) == 'table' then
                            local n = k:find('Init', 1, true)
                            local params = {}
                            for i = 2, #modifier do table.insert(params, modifier[i]) end
                            if modifier[1] == k:utf8sub(1, n-1) and not tableContains(called_functions, k) then 
                                v(c, unpack(params)) 
                                table.insert(called_functions, k)
                            end
                        else 
                            local n = k:find('Init', 1, true)
                            if modifier == k:utf8sub(1, n-1) and not tableContains(called_functions, k) then 
                                v(c) 
                                table.insert(called_functions, k)
                            end
                        end
                    end
                end
            end
        end
    end

    return setmetatable(self, Text)
end

function Text:update(dt)
    self.dt = dt
end

function Text:draw(x, y)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font or font)

    local regular_font = true
    for _, c in ipairs(self.characters) do
        -- Call each modifier function
        regular_font = true
        local called_functions = {}
        for _, modifier in ipairs(c.modifiers) do
            if type(modifier) == 'table' then
                local params = {}
                for i = 2, #modifier do 
                    table.insert(params, stringToAny(modifier[i])) 
                end
                if not self[modifier[1]] and not self[modifier[1] .. 'Init'] then
                    error("undefined function: " .. modifier[1])
                elseif self[modifier[1]] and not tableContains(called_functions, modifier[1]) then 
                    self[modifier[1]](self.dt, c, unpack(params)) 
                    table.insert(called_functions, modifier[1])
                end
            else 
                if not self[modifier] and not self[modifier .. 'Init'] then
                    error("undefined function: " .. modifier)
                elseif self[modifier] and not tableContains(called_functions, modifier) then 
                    if type(modifier) == 'function' or type(self[modifier]) == 'function' then
                        self[modifier](self.dt, c) 
                        table.insert(called_functions, modifier)
                    else
                        love.graphics.setFont(self[modifier])
                        regular_font = false
                    end
                end
            end
        end
        if regular_font then love.graphics.setFont(self.font) end
        if self.custom_draw then self.custom_draw(x or self.x, y or self.y, c)
        else love.graphics.print(c.character, (x or self.x) + c.x, (y or self.y) + c.y, c.r or 0, c.sx or 1, c.sy or 1, 0, 0) end
    end
    love.graphics.setFont(font)
end

return setmetatable({new = new}, {__call = function(_, ...) return Text.new(...) end})
