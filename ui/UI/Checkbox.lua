local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Base = require(ui_path .. 'Base')
local Draggable = require(ui_path .. 'Draggable')
local Resizable = require(ui_path .. 'Resizable')
local Checkbox = Object:extend('Checkbox')
Checkbox:implement(Base)
Checkbox:implement(Draggable)
Checkbox:implement(Resizable)

function Checkbox:new(ui, x, y, w, h, settings)
    local settings = settings or {}
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Checkbox'

    self:basePreNew(x, y, w, h, settings)

    self.draggable = settings.draggable or false
    if self.draggable then self:draggableNew(settings) end
    self.resizable = settings.resizable or false
    if self.resizable then self:resizableNew(settings) end

    self.checked_enter = false
    self.checked_exit = false
    self.checked = false
    self.previous_checked = false

    self:basePostNew()
end

function Checkbox:update(dt, parent)
    self:basePreUpdate(dt, parent)

    if self.resizable then self:resizableUpdate(dt, parent) end
    if self.draggable then self:draggableUpdate(dt, parent) end

    -- Check for checked_enter
    if self.checked and not self.previous_checked then
        self.checked_enter = true
    else self.checked_enter = false end

    -- Check for checked_exit
    if not self.checked and self.previous_checked then
        self.checked_exit = true
    else self.checked_exit = false end

    self:basePostUpdate(dt)

    -- Change state
    if self.released and (self.hot or self.selected) then
        self.checked = not self.checked
    end

    self.previous_checked = self.checked
end

function Checkbox:draw()
    self:basePreDraw()
    self:basePostDraw()
end

function Checkbox:toggle()
    self.checked = not self.checked
end

return Checkbox
