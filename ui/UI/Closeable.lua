local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Closeable = Object:extend('Closeable')

function Closeable:closeableNew(settings)
    local settings = settings or {}
    self.closing = false
    self.closed = settings.closed or false
    self.close_margin_top = settings.close_margin_top or 5
    self.close_margin_right = settings.close_margin_right or 5
    self.close_button_width = settings.close_button_width or 10
    self.close_button_height = settings.close_button_height or 10
    self.close_button = self.ui.Button(self.w - self.close_margin_right - self.close_button_width, self.close_margin_top, self.close_button_width, self.close_button_height,
                                      {extensions = settings.close_button_extensions or {}, annotation = settings.annotation})
    self:bind('escape', 'close')
end

function Closeable:closeableUpdate(dt)
    if self.close_button.pressed then
        self.closing = true
    end
    if self.closing and self.close_button.released then
        self.closed = true
        self.closing = false
    end
    if self.selected and not self.any_selected and self.input:pressed('close') then
        self.closed = true
    end
    self.close_button:update(dt, self)
end

function Closeable:closeableDraw()
    self.close_button:draw()
end

return Closeable
