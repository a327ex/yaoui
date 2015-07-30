local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Base = require(ui_path .. 'Base')
local Textarea = Object:extend('Textarea')
Textarea:implement(Base)

local major, minor, rev = love.getVersion()
local love_version = major .. '.' .. minor .. '.' .. rev

function Textarea:new(ui, x, y, w, h, settings)
    local settings = settings or {}
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Textarea'

    self:basePreNew(x, y, w, h, settings)

    self:bind('left', 'move-left')
    self:bind('right', 'move-right')
    self:bind('up', 'move-up')
    self:bind('down', 'move-down')
    self:bind('lshift', 'lshift')
    self:bind('backspace', 'backspace')
    self:bind('delete', 'delete')
    self:bind('lctrl', 'lctrl')
    self:bind('home', 'first')
    self:bind('end', 'last')
    self:bind('return', 'enter')
    self:bind('tab', 'tab')
    self:bind('x', 'cut')
    self:bind('c', 'copy')
    self:bind('v', 'paste')
    self:bind('a', 'all')
    self:bind('z', 'undo')
    self:bind('r', 'redo')
    self:bind('escape', 'unselect')

    self.single_line = settings.single_line
    self.text_margin = settings.text_margin or 5
    self.wrap_width = settings.wrap_width or (self.w - 4*self.text_margin)
    self.text_add_x = 0
    self.text_x, self.text_y = self.x + self.text_margin, self.y + self.text_margin
    self.text_ix, self.text_iy = self.text_x, self.text_y
    self.text_base_x, self.text_base_y = self.text_x, self.text_y
    self.editing_locked = settings.editing_locked
    self.wrap_text_in = {} 
    self.tab_width = settings.tab_width or 4

    self.font = settings.font or love.graphics.getFont()
    self.text_table = {}
    self.tags_table = {}
    self.copy_buffer = {}
    self.tags_buffer = {}
    self.line_text = {}
    self.index = 1
    self.cursor_index = nil
    self.selection_index = nil
    self.selection_positions = {}
    self.selection_sizes = {}
    self.key_pressed_time = 0
    self.mouse_all_selected = false
    self.mouse_pressed_time = false
    self.last_mouse_pressed_time = false
    self.last_action = nil
    self.cursor_visible = true
    self.cursor_blink_timer = 0
    self.cursor_blink_interval = 0.5
    self.undo_pushed = false
    self.disable_undo_redo_keys = settings.disable_undo_redo_keys

    if self.single_line then self.text_settings = {font = self.font}
    else self.text_settings = {font = self.font, wrap_width = self.wrap_width} end
    self.text = self.ui.Text(self.text_x, self.text_y, self:join(), self.text_settings) 
    if self.single_line then self.h = self.text.font:getHeight() + 4*self.text_margin end

    self.undo_stack_size = settings.undo_stack_size or 50
    self.undo_stack = {}
    self.redo_stack = {}

    self:basePostNew()
end

function Textarea:update(dt, parent)
    self:basePreUpdate(dt, parent)
    if parent then self.text_base_x, self.text_base_y = parent.x + self.text_ix, parent.y + self.text_iy end
    self.text_x, self.text_y = self.text_base_x + (self.text_margin or 0) + self.text_add_x, self.text_base_y + (self.text_margin or 0)
    self.text.x, self.text.y = self.text_x, self.text_y
    self.text:update(dt)

    self.undo_pushed = false

    -- Set line text
    self.line_text = {}
    local n = 0
    for i, c in ipairs(self.text_table) do 
        if self.text_table[i] == '\n' then
            table.insert(self.line_text, {character = c, line = n+1})
            n = n + 1
        else table.insert(self.line_text, {character = c, line = (self.text.characters[i-n] and self.text.characters[i-n].line) or 0}) end
    end

    if self.editing_locked then 
        self.selected = false
        return
    end

    if self.selected and self.input:pressed('unselect') then self.selected = false end

    -- Cursor blink
    self.cursor_blink_timer = self.cursor_blink_timer + dt
    if self.cursor_blink_timer > self.cursor_blink_interval then
        self.cursor_blink_timer = 0
        self.cursor_visible = not self.cursor_visible
    end

    -- Everything up has to happen every frame if the textarea is selected or not
    if not self.selected then return end
    -- Everything down has to happen only if the textarea is selected

    local mx, my = self.getMousePosition()

    -- Cursor + character hover information for clicks
    self.cursor_index = nil
    if self.hot then
        for i, c in ipairs(self.line_text) do
            local line_string = self:getLineString(c.line)
            local line_first_index = self:getIndexOfFirstInLine(c.line)
            local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
            local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
            if mx >= x and mx <= x + w and my >= y and my <= y + h then self.cursor_index = i; break end
            if i == #self.line_text and my >= y and my <= y + h then self.cursor_index = i + 1; break end
        end
    end
    
    -- Cursor selection with mouse
    if self.hot and self.input:pressed('left-click') then
        self.selection_index = false
        self.mouse_all_selected = false
        self.mouse_pressing = true
        for i, c in ipairs(self.line_text) do
            local line_string = self:getLineString(c.line)
            local line_first_index = self:getIndexOfFirstInLine(c.line)
            local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
            local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
            if mx >= x and mx <= x + w and my >= y and my <= y + h then self.index = i; break end
            if i == #self.line_text and my >= y and my <= y + h then self.index = i + 1; break end
        end
    end
    if not self.mouse_all_selected and self.mouse_pressing and self.input:down('left-click') then
        for i, c in ipairs(self.line_text) do
            local line_string = self:getLineString(c.line)
            local line_first_index = self:getIndexOfFirstInLine(c.line)
            local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
            local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
            if mx >= x and mx <= x + w and my >= y and my <= y + h then self.selection_index = i; break end
            if i == #self.line_text and my >= y and my <= y + h then self.selection_index = i + 1; break end
            if self.index == self.selection_index then self.selection_index = nil end
        end
        -- Outside textarea right + down on last line
        for i = 1, self:getMaxLines() do
            local y = self.text_y + (i-1)*self.text.font:getHeight()
            if mx >= self.x + self.w - self.text.font:getWidth('w') and my >= y and my <= y + self.text.font:getHeight() then
                self.selection_index = (self:getIndexOfLastInLine(i - 1) or #self.text.characters) + 1
            end
        end
        -- Outside textarea down
        if my >= self.y + self.h and mx >= self.x and mx <= self.x + self.w then
            for i, c in ipairs(self.line_text) do
                if c.line == self:getMaxLines() - 1 then
                    local line_string = self:getLineString(c.line)
                    local line_first_index = self:getIndexOfFirstInLine(c.line)
                    local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
                    local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
                    if mx >= x and mx <= x + w then 
                        self.selection_index = i
                        break
                    elseif mx >= x and i == #self.text.characters then
                        self.selection_index = i + 1
                        break
                    end
                end
            end
        end
        -- Outside textarea left + up
        for i = 1, self:getMaxLines() do
            local y = self.text_y + (i-1)*self.text.font:getHeight()
            if mx <= self.x + self.text.font:getWidth('w') and my >= y and my <= y + self.text.font:getHeight() then
                self.selection_index = self:getIndexOfFirstInLine(i - 1) or 1
            end
        end
        -- Outside textarea up
        if my <= self.y and mx >= self.x and mx <= self.x + self.w then
            for i, c in ipairs(self.line_text) do
                if c.line == 0 then
                    local line_string = self:getLineString(c.line)
                    local line_first_index = self:getIndexOfFirstInLine(c.line)
                    local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
                    local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
                    if mx >= x and mx <= x + w then 
                        self.selection_index = i
                        break
                    end
                end
            end
        end
        -- Outside diagonals
        if mx <= self.x and my <= self.y then self.selection_index = 1
        elseif mx >= self.x + self.w and my >= self.y + self.h then self.selection_index = #self.text.characters + 1 end
    end
    if self.mouse_pressing and self.input:released('left-click') then
        self.mouse_pressing = false
    end

    -- Cursor double click all selection
    if self.hot and self.input:pressed('left-click') then
        self.mouse_pressed_time = love.timer.getTime()
        if self.last_mouse_pressed_time then
            if self.mouse_pressed_time - self.last_mouse_pressed_time < 0.3 then self.mouse_all_selected = true end
        end
    end
    if self.mouse_all_selected then self:selectAll() end

    -- Move cursor left
    if not self.input:down('lshift') and self.input:pressed('move-left') then
        self.key_pressed_time = love.timer.getTime()
        self:moveLeft()
    end
    if not self.input:down('lshift') and self.input:down('move-left') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveLeft() end
    end

    -- Move cursor right
    if not self.input:down('lshift') and self.input:pressed('move-right') then
        self.key_pressed_time = love.timer.getTime()
        self:moveRight()
    end
    if not self.input:down('lshift') and self.input:down('move-right') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveRight() end
    end

    -- Move cursor up
    if not self.input:down('lshift') and self.input:pressed('move-up') then
        self.key_pressed_time = love.timer.getTime()
        self:moveUp()
    end
    if not self.input:down('lshift') and self.input:down('move-up') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveUp() end
    end

    -- Move cursor down
    if not self.input:down('lshift') and self.input:pressed('move-down') then
        self.key_pressed_time = love.timer.getTime()
        self:moveDown()
    end
    if not self.input:down('lshift') and self.input:down('move-down') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveDown() end
    end

    -- Move cursor to beginning
    if self.input:pressed('first') then self:first() end

    -- Move cursor to end
    if self.input:pressed('last') then self:last() end

    -- Select left
    if self.input:down('lshift') and self.input:pressed('move-left') then
        self.key_pressed_time = love.timer.getTime()
        self:selectLeft()
    end
    if self.input:down('lshift') and self.input:down('move-left') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectLeft() end
    end

    -- Select right
    if self.input:down('lshift') and self.input:pressed('move-right') then
        self.key_pressed_time = love.timer.getTime()
        self:selectRight()
    end
    if self.input:down('lshift') and self.input:down('move-right') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectRight() end
    end

    -- Select up
    if self.input:down('lshift') and self.input:pressed('move-up') then
        self.key_pressed_time = love.timer.getTime()
        self:selectUp()
    end
    if self.input:down('lshift') and self.input:down('move-up') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectUp() end
    end

    -- Select down
    if self.input:down('lshift') and self.input:pressed('move-down') then
        self.key_pressed_time = love.timer.getTime()
        self:selectDown()
    end
    if self.input:down('lshift') and self.input:down('move-down') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectDown() end
    end

    -- Select all
    if self.input:down('lctrl') and self.input:pressed('all') then self:selectAll() end

    -- Delete before cursor
    if self.input:pressed('backspace') then
        self.key_pressed_time = love.timer.getTime()
        self:backspace()
    end
    if self.input:down('backspace') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:backspace() end
    end

    -- Delete after cursor
    if self.input:pressed('delete') then
        self.key_pressed_time = love.timer.getTime()
        self:delete()
    end
    if self.input:down('delete') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:delete() end
    end

    if self.input:down('lctrl') and self.input:pressed('cut') then self:cut() end
    if self.input:down('lctrl') and self.input:pressed('copy') then self:copy() end
    if self.input:down('lctrl') and self.input:pressed('paste') then self:paste() end
    if not self.disable_undo_redo_keys then
        if self.input:down('lctrl') and self.input:pressed('undo') then self:undo() end
        if self.input:down('lctrl') and self.input:pressed('redo') then self:redo() end
    end

    -- New line
    if self.input:pressed('enter') then 
        if not self.single_line then
            self:textinput('\n') 
        end
    end

    -- Tab
    if self.input:pressed('tab') then
        for i = 1, self.tab_width do self:textinput(' ') end
    end

    -- Figure out selection/cursor position in pixels
    self.selection_positions = {}
    self.selection_sizes = {}

    -- Set line text
    self.line_text = {}
    local n = 0
    for i, c in ipairs(self.text_table) do 
        if self.text_table[i] == '\n' then
            table.insert(self.line_text, {character = c, line = n+1})
            n = n + 1
        else table.insert(self.line_text, {character = c, line = (self.text.characters[i-n] and self.text.characters[i-n].line) or 0}) end
    end

    local line_string = self:getLineString(self:getIndexLine(self.index) or self:getIndexLine(self.index - 1))
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.index)) or self:getIndexOfFirstInLine(self:getIndexLine(self.index - 1)) or 1
    local line_last_index = self:getIndexOfLastInLine(self:getIndexLine(self.index)) or (line_first_index + #line_string - 1)

    -- No selection, just cursor
    if not self.selection_index then
        local u = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
        local v = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index + 1))
        if self.index == #self.text_table + 1 then v = v + self.text.font:getWidth('a') end
        local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
        table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h*self.font:getHeight()})
        table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})
    -- Selection
    else
        local index_line = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1)
        local selection_index_line = self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index)
        -- Multi line selection
        if index_line ~= selection_index_line then
            -- Forward
            if self.index <= self.selection_index then
                local n_mid_lines = selection_index_line - index_line - 1
                -- Fill starting line
                local u = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
                local v = self.text.font:getWidth(line_string:utf8sub(1, line_last_index - line_first_index + 1))
                local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
                table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})
                -- Fill mid lines
                for i = 1, n_mid_lines do
                    local first_index_in_mid_line = self:getIndexOfFirstInLine(index_line + i)
                    local mid_line_string = self:getLineString(self:getIndexLine(first_index_in_mid_line))
                    table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + (h+i)*self.font:getHeight()})
                    table.insert(self.selection_sizes, {w = self.text.font:getWidth(mid_line_string), h = self.font:getHeight()})
                end
                -- Fill end line
                local next_line_string = self:getLineString(self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index))
                local next_line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index - 1)) or self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
                local z = self.text.font:getWidth(next_line_string:utf8sub(1, self.selection_index - next_line_first_index))
                local h2 = self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index) or 0
                table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + h2*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = z, h = self.font:getHeight()})
            -- Backwards
            else
                local n_mid_lines = index_line - selection_index_line - 1
                -- Fill starting line
                local z = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index + 1))
                local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
                table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + h*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = z, h = self.font:getHeight()})
                -- Fill mid lines
                for i = 1, n_mid_lines do
                    local first_index_in_mid_line = self:getIndexOfFirstInLine(index_line - i)
                    local mid_line_string = self:getLineString(self:getIndexLine(first_index_in_mid_line))
                    table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + (h-i)*self.font:getHeight()})
                    table.insert(self.selection_sizes, {w = self.text.font:getWidth(mid_line_string), h = self.font:getHeight()})
                end
                -- Fill end line
                local previous_line_string = self:getLineString(self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index) or 0)
                local previous_line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index - 1)) or self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
                local previous_line_last_index = self:getIndexOfLastInLine(self:getIndexLine(self.selection_index - 1)) or self:getIndexOfLastInLine(self:getIndexLine(self.selection_index)) or 1
                local u = self.text.font:getWidth(previous_line_string:utf8sub(1, self.selection_index - previous_line_first_index))
                local v = self.text.font:getWidth(previous_line_string:utf8sub(1, previous_line_last_index - previous_line_first_index + 1))
                local h2 = self:getIndexLine(self.selection_index) or self:getIndexLine(self.selection_index - 1) or 0
                table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h2*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})

            end
        -- Single line selection
        else
            local u = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
            local v = self.text.font:getWidth(line_string:utf8sub(1, self.selection_index - line_first_index))
            local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
            table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h*self.font:getHeight()})
            table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})
        end
    end

    -- Single line text scrolling
    local w = self.w - 2*self.text_margin
    if self.single_line and #self.selection_positions > 0 then
        if not self.selection_index then
            local x1, y1 = self.selection_positions[1].x - self.text_x, self.selection_positions[1].y
            local x2, y2 = x1 + self.selection_sizes[1].w, y1 + self.selection_sizes[1].h
            if x2 > w - self.text_add_x then
                self.text_add_x = self.text_add_x - w/4
            elseif x1 < -self.text_add_x then
                self.text_add_x = self.text_add_x + w/4
            end
        else
            local x1, y1 = self.selection_positions[1].x - self.text_x, self.selection_positions[1].y
            local n = #self.selection_positions
            local x2, y2 = self.selection_positions[n].x - self.text_x + self.selection_sizes[n].w, self.selection_positions[n].y + self.selection_sizes[n].h
            if x2 > w - self.text_add_x then
                self.text_add_x = self.text_add_x - w/4
            elseif x2 < -self.text_add_x then
                self.text_add_x = self.text_add_x + w/4
            end
        end
    end

    self:basePostUpdate(dt)

    self.last_mouse_pressed_time = self.mouse_pressed_time
end

function Textarea:draw()
    if love_version == '0.9.1' or love_version == '0.9.2' then
        love.graphics.setStencil(function() love.graphics.rectangle('fill', self.x, self.y, self.w, self.h) end)
        self:basePreDraw()
        self:basePostDraw()
        love.graphics.setStencil()
    else
        love.graphics.stencil(function() love.graphics.rectangle('fill', self.x, self.y, self.w, self.h) end)
        love.graphics.setStencilTest(true)
        self:basePreDraw()
        self:basePostDraw()
        love.graphics.setStencilTest(false)
    end
end

function Textarea:updateText()
    local text_str = ''
    local i = 1
    while i <= #self.text_table do
        if self.tags_table[i] ~= '' then
            text_str = text_str .. '[' .. self.text_table[i]
            while self.tags_table[i] == self.tags_table[i+1] do
                i = i + 1
                text_str = text_str .. self.text_table[i]
            end
            text_str = text_str .. '](' .. self.tags_table[i] .. ')'
        else text_str = text_str .. self.text_table[i] end
        i = i + 1
    end
    self.text = self.ui.Text(self.text_x, self.text_y, text_str, self.text_settings)

    -- Set line text
    self.line_text = {}
    local n = 0
    for i, c in ipairs(self.text_table) do 
        if self.text_table[i] == '\n' then
            table.insert(self.line_text, {character = c, line = n+1})
            n = n + 1
        else table.insert(self.line_text, {character = c, line = (self.text.characters[i-n] and self.text.characters[i-n].line) or 0}) end
    end
end

function Textarea:printText()
    local str = ''
    for i = 1, #self.line_text do
        str = str .. '(' .. i .. ', ' .. self.line_text[i].character .. ', ' .. self.line_text[i].line .. '), '
    end
    print(str)
end

function Textarea:setTextSettings(new_settings)
    local settings = {}
    for k, v in pairs(self.text_settings) do settings[k] = v end
    for k, v in pairs(new_settings) do settings[k] = v end
    self.text_settings = settings
    self:updateText()
end

function Textarea:textinput(text, dont_update)
    if not self.selected then return end
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    if text == '\n' then
        if self.last_action ~= 'textinput' then self:undoPush(self:saveState()) end
        self.last_action = 'textinput'
        self:deleteSelected()
        table.insert(self.text_table, self.index, text)
        table.insert(self.tags_table, self.index, '')
        self.index = self.index + 1
        self.selection_index = nil
        if not dont_update then self:updateText() end
    else
        if self.last_action ~= 'textinput' then self:undoPush(self:saveState()) end
        self.last_action = 'textinput'
        self:deleteSelected()
        table.insert(self.text_table, self.index, text)
        local wrap_text = ''
        for _, tag in ipairs(self.wrap_text_in) do
            wrap_text = wrap_text .. tag .. '; '
        end
        if #wrap_text > 0 then wrap_text = wrap_text:sub(1, -3) end
        table.insert(self.tags_table, self.index, wrap_text)
        self.index = self.index + 1
        self.selection_index = nil
        if not dont_update then self:updateText() end
    end
end

function Textarea:addText(text, dont_update)
    local previous_selected = self.selected
    self.selected = true
    for i = 1, #text do self:textinput(text:utf8sub(i, i), true) end
    self.selected = previous_selected
    if not dont_update then self:updateText() end
end

function Textarea:setText(text)
    local previous_selected = self.selected
    self.selected = true
    self.index = 1
    self.text_table = {}
    self.tags_table = {}
    local text_table = {}
    for i = 1, #text do table.insert(text_table, text:utf8sub(i, i)) end
    for i = 1, #text_table do
        table.insert(self.text_table, i, text_table[i])
        table.insert(self.tags_table, i, '')
        self.index = self.index + 1
    end
    self.selected = previous_selected
    self:updateText()
end

function Textarea:getText()
    return self.text.str_text
end

function Textarea:join(table)
    local table = table or self.text_table
    local string = ''
    for i, c in ipairs(table) do string = string .. c end
    return string
end

function Textarea:getLineString(line)
    local string = ''
    for i, c in ipairs(self.line_text) do
        if c.line == line then string = string .. c.character end
    end
    return string
end

function Textarea:getIndexLine(index)
    for i, c in ipairs(self.line_text) do
        if i == index then return c.line end
    end
end

function Textarea:getIndexOfFirstInLine(line)
    for i, c in ipairs(self.line_text) do
        if c.line == line then return i end
    end
end

function Textarea:getIndexOfLastInLine(line)
    for i, c in ipairs(self.line_text) do
        if c.line ~= line and self.line_text[i-1] and self.line_text[i-1].line == line then return i-1 end
    end
end

function Textarea:getMaxLines()
    local n_lines = 0
    for i, c in ipairs(self.line_text) do 
        if c.character ~= '\n' then
            n_lines = c.line + 1 
        end
    end
    return n_lines
end

function Textarea:moveLeft()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index end
    self.index = self.index - 1
    self.selection_index = nil
    if self.index < 1 then self.index = 1 end
end

function Textarea:moveRight()
    self.cursor_blink_timer = 0
    self.cursor_visible = true 
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index - 1 end
    self.index = self.index + 1
    self.selection_index = nil
    if self.index > #self.text_table + 1 then self.index = #self.text_table + 1 end
end

function Textarea:moveUp()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index end
    local index_line = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1)
    if index_line == 0 then 
        self.index = 1
        self.selection_index = nil
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.index - line_first_index))
    local string = ''
    for i, c in ipairs(self.line_text) do
        if c.line == index_line - 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.index = i
                else 
                    if self:getIndexLine(i+1) == c.line then self.index = i + 1 
                    else self.index = i end
                end
                self.selection_index = nil
                return 
            end
        end
    end
    self.index = self:getIndexOfLastInLine(index_line - 1) or (self:getIndexOfLastInLine(index_line - 2) + 1) or 1
    self.selection_index = nil
end

function Textarea:moveDown()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index end
    local index_line = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1)
    if index_line == self:getMaxLines() - 1 then 
        self.index = #self.line_text + 1
        self.selection_index = nil
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.index - line_first_index))
    local string = ''
    for i, c in ipairs(self.line_text) do
        if c.line == index_line + 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.index = i
                else 
                    if self:getIndexLine(i+1) == c.line then self.index = i + 1 
                    else self.index = i end
                end
                self.selection_index = nil
                return 
            end
        end
    end
    self.index = self:getIndexOfLastInLine(index_line + 1) or (#self.line_text + 1)
    self.selection_index = nil
end

function Textarea:selectLeft()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index - 1
    else self.selection_index = self.selection_index - 1 end
    if self.selection_index < 1 then self.selection_index = 1 end
end

function Textarea:selectRight()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index + 1
    else self.selection_index = self.selection_index + 1 end
    if self.selection_index > #self.text_table + 1 then self.selection_index = #self.text_table + 1 end
end

function Textarea:selectUp()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index end
    local index_line = self:getIndexLine(self.selection_index) or self:getIndexLine(self.selection_index - 1)
    if index_line == 0 then 
        self.selection_index = 1
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.selection_index - line_first_index))
    local string = ''
    for i, c in ipairs(self.line_text) do
        if c.line == index_line - 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.selection_index = i
                else 
                    if self:getIndexLine(i+1) == c.line then self.selection_index = i + 1 
                    else self.selection_index = i end
                end
                return 
            end
        end
    end
    self.selection_index = self:getIndexOfLastInLine(index_line - 1)
end

function Textarea:selectDown()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index + 1 end
    local index_line = self:getIndexLine(self.selection_index) or self:getIndexLine(self.selection_index - 1)
    if index_line == self:getMaxLines() - 1 then 
        self.selection_index = #self.line_text + 1
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.selection_index - line_first_index))
    local string = ''
    for i, c in ipairs(self.line_text) do
        if c.line == index_line + 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.selection_index = i
                else 
                    if self:getIndexLine(i+1) == c.line then self.selection_index = i + 1 
                    else self.selection_index = i end
                end
                return 
            end
        end
    end
    self.selection_index = self:getIndexOfLastInLine(index_line + 1) or (#self.line_text + 1)
end

function Textarea:selectAll()
    self.index = 1
    self.selection_index = #self.line_text + 1
end

function Textarea:first()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.index = 1
    self.selection_index = nil
    self.mouse_all_selected = false
end

function Textarea:last()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.index = #self.line_text + 1
    self.selection_index = nil
    self.mouse_all_selected = false
end

function Textarea:deleteSelected()
    if not self.selection_index then return end
    if self.index == self.selection_index then return end
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self:undoPush(self:saveState())
    local min, max = 0, 0
    local internal_min, internal_max = 0, 0
    if self.index < self.selection_index then min = self.index; max = self.selection_index - 1
    elseif self.selection_index < self.index then min = self.selection_index; max = self.index - 1 end
    for i = max, min, -1 do 
        table.remove(self.text_table, i) 
        table.remove(self.tags_table, i)
    end
    self.index = min
    self.selection_index = nil
    self.mouse_all_selected = false
end

function Textarea:backspace()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    if self.selection_index then self:deleteSelected()
    else 
        if self.index > 1 then
            if self.last_action ~= 'backspace' then self:undoPush(self:saveState()) end
            self.last_action = 'backspace'
            table.remove(self.text_table, self.index - 1) 
            table.remove(self.tags_table, self.index - 1)
            self.index = self.index - 1
        end
    end
    self:updateText()
end

function Textarea:delete()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    if self.selection_index then self:deleteSelected()
    else
        if self.last_action ~= 'delete' then self:undoPush(self:saveState()) end
        self.last_action = 'delete'
        table.remove(self.text_table, self.index) 
        table.remove(self.tags_table, self.index)
        if self.index == #self.line_text then
            self.index = self.index - 1
            if self.index < 1 then self.index = 1 end
        end
    end
    self:updateText()
end

function Textarea:copy()
    if not self.selection_index then return end
    if self.index == self.selection_index then return end
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self.copy_buffer = {}
    self.tags_buffer = {}
    local min, max = 0, 0
    if self.index < self.selection_index then min = self.index; max = self.selection_index - 1
    elseif self.selection_index < self.index then min = self.selection_index; max = self.index - 1 end
    for i = min, max do 
        table.insert(self.copy_buffer, self.line_text[i].character) 
        table.insert(self.tags_buffer, self.tags_table[i])
    end
end

function Textarea:cut()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    if self.selection_index then self:undoPush(self:saveState()) end
    self:copy()
    self:deleteSelected()
    self:updateText()
end

function Textarea:paste()
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    if #self.copy_buffer > 0 then self:undoPush(self:saveState()) end
    self:deleteSelected()
    for i = 1, #self.copy_buffer do
        table.insert(self.text_table, self.index, self.copy_buffer[i])
        table.insert(self.tags_table, self.index, self.tags_buffer[i])
        self.index = self.index + 1
    end
    self:updateText()
end

function Textarea:getIndexTag(index)
    return self.tags_table[index]
end

function Textarea:getIndexTagWord(index)
    local index_tag = self.tags_table[index]
    local left, right = -1, 1
    while self.tags_table[index+right] == index_tag do right = right + 1 end
    while self.tags_table[index+left] == index_tag do left = left - 1 end
    local out_str = ''
    for i = index+left+1, index+right-1 do
        if self.text_table[i] ~= '\n' then
            out_str = out_str .. self.text_table[i]
        end
    end
    return out_str
end

function Textarea:applyTagToSelectedText(tag)
    if not self.selection_index then return end
    self.cursor_blink_timer = 0
    self.cursor_visible = true
    self:undoPush(self:saveState())
    local min, max = 0, 0
    if self.index < self.selection_index then min = self.index; max = self.selection_index else min = self.selection_index; max = self.index end
    for i = min, max-1 do
        if self.tags_table[i] == '' then self.tags_table[i] = tag
        else
            if self.tags_table[i]:find('bold') and not self.tags_table[i]:find('bold_italic') and tag == 'italic' then 
                local u, v = self.tags_table[i]:find('bold')
                local head = self.tags_table[i]:sub(1, v)
                local tail = self.tags_table[i]:sub(v+1, -1)
                self.tags_table[i] = head .. '_italic' .. tail 
            elseif self.tags_table[i]:find('italic') and not self.tags_table[i]:find('bold_italic') and tag == 'bold' then
                local u, v = self.tags_table[i]:find('italic')
                local head = self.tags_table[i]:sub(1, u-1)
                local tail = self.tags_table[i]:sub(u, -1)
                self.tags_table[i] = head .. 'bold_' .. tail
            elseif self.tags_table[i]:find('bold_italic') and tag == 'italic' then
                local u, v = self.tags_table[i]:find('bold_italic')
                local head = self.tags_table[i]:sub(1, u-1)
                local tail = self.tags_table[i]:sub(v+1, -1)
                self.tags_table[i] = head .. 'bold' .. tail
            elseif self.tags_table[i]:find('bold_italic') and tag == 'bold' then
                local u, v = self.tags_table[i]:find('bold_italic')
                local head = self.tags_table[i]:sub(1, u-1)
                local tail = self.tags_table[i]:sub(v+1, -1)
                self.tags_table[i] = head .. 'italic' .. tail
            else 
                if self.tags_table[i]:find(tag) then
                    if self.tags_table[i] == tag then self.tags_table[i] = ''
                    else
                        local u, v = self.tags_table[i]:find(tag)
                        if u == 1 then self.tags_table[i] = self.tags_table[i]:sub(v+3, -1)
                        elseif v == #self.tags_table[i] then self.tags_table[i] = self.tags_table[i]:sub(1, u-3)
                        else
                            local head = self.tags_table[i]:sub(1, u-2)
                            local tail = self.tags_table[i]:sub(v+2, -1)
                            self.tags_table[i] = head .. tail
                        end
                    end
                else self.tags_table[i] = self.tags_table[i] .. '; ' .. tag end
            end
        end
    end
    self:updateText()
end

function Textarea:saveState()
    local state = {}
    state.wrap_text_in = self.wrap_text_in
    state.index = self.index
    state.selection_index = self.selection_index
    state.text_table = {}
    for i, t in ipairs(self.text_table) do table.insert(state.text_table, t) end
    state.tags_table = {}
    for _, t in ipairs(self.tags_table) do table.insert(state.tags_table, t) end
    return state
end

function Textarea:applyState(state)
    self.wrap_text_in = state.wrap_text_in
    self.index = state.index
    self.selection_index = state.selection_index
    self.text_table = {}
    for i, t in ipairs(state.text_table) do table.insert(self.text_table, t) end
    self.tags_table = {}
    for _, t in ipairs(state.tags_table) do table.insert(self.tags_table, t) end
    self:updateText()
end

function Textarea:undo()
    local state = self:undoPop()
    if state then
        self.cursor_blink_timer = 0
        self.cursor_visible = true
        local redo_state = self:saveState()
        self:applyState(state)
        self:redoPush(redo_state)
    end
end

function Textarea:redo()
    local state = self:redoPop()
    if state then
        self.cursor_blink_timer = 0
        self.cursor_visible = true
        local undo_state = self:saveState()
        self:applyState(state)
        self:undoPush(undo_state)
    end
end

function Textarea:undoPop()
    return table.remove(self.undo_stack, 1)
end

function Textarea:undoPush(state)
    self.undo_pushed = self.id
    self.redo_stack = {}
    table.insert(self.undo_stack, 1, state)
    self.undo_stack[self.undo_stack_size+1] = nil
end

function Textarea:redoPop()
    return table.remove(self.redo_stack, 1)
end

function Textarea:redoPush(state)
    table.insert(self.redo_stack, 1, state)
    self.redo_stack[self.undo_stack_size+1] = nil
end

return Textarea
