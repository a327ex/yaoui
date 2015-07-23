local BladeTheme = {}

BladeTheme.IconButton = {}
BladeTheme.IconButton.new = function(self)
    self.color = {255, 255, 255}
    self.timer = self.blade.Timer()
end

BladeTheme.IconButton.update = function(self, dt)
    self.timer:update(dt)
end

BladeTheme.IconButton.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {160, 160, 160}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {255, 255, 255}}, 'linear') end
    
    love.graphics.setColor(222, 36, 36)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)

    love.graphics.setColor(unpack(self.color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.icon, self.x + self.w/10, self.y + self.h/64)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

return BladeTheme
