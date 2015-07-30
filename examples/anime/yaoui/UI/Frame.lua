local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Base = require(ui_path .. 'Base')
local Closeable = require(ui_path .. 'Closeable')
local Container = require(ui_path .. 'Container')
local Draggable = require(ui_path .. 'Draggable')
local Resizable = require(ui_path .. 'Resizable')
local Frame = Object:extend('Frame')
Frame:implement(Base)
Frame:implement(Closeable)
Frame:implement(Container)
Frame:implement(Draggable)
Frame:implement(Resizable)

function Frame:new(ui, x, y, w, h, settings)
    local settings = settings or {}
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Frame'

    self:basePreNew(x, y, w, h, settings)
    self:containerNew(settings)

    self.draggable = settings.draggable or false
    if self.draggable then self:draggableNew(settings) end
    self.resizable = settings.resizable or false
    if self.resizable then self:resizableNew(settings) end
    self.closeable = settings.closeable or false
    if self.closeable then
        settings.annotation = "Frame's close button"
        settings.close_margin = self.resize_margin
        self:closeableNew(settings)
    end

    self:basePostNew()
end

function Frame:update(dt, parent)
    if self.closed then return end
    self:basePreUpdate(dt, parent)
    local x, y = love.mouse.getPosition()

    if self.resizable then self:resizableUpdate(dt, parent) end
    if self.draggable then self:draggableUpdate(dt, parent) end
    if self.closeable then self:closeableUpdate(dt) end

    self:containerUpdate(dt, parent)
    self:basePostUpdate(dt)
end

function Frame:draw()
    if self.closed then return end
    self:basePreDraw()
    if self.closeable then self:closeableDraw() end
    self:containerDraw()
    self:basePostDraw()
end

function Frame:addElement(element)
    return self:containerAddElement(element)
end

function Frame:removeElement(id)
    return self:containerRemoveElement(id)
end

function Frame:getElement(id)
    return self:containerGetElement(id)
end

return Frame
