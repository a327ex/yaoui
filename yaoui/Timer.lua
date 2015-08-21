local Timer = {}
Timer.__index = Timer

local humpTimer = require((...):sub(1, -7) .. '.hump_timer.timer')

function Timer.new()
    local self = {}

    self.timer = humpTimer.new()
    self.tags = {}

    return setmetatable(self, Timer)
end

function Timer:update(dt)
    self.timer:update(dt)
end

function Timer:tween(tag, duration, table, tween_table, tween_function, after)
    if type(tag) == 'number' or type(tag) == 'table' then
        return self.timer:tween(tag, duration, table, tween_table, tween_function, after)
    end

    if not self.tags[tag] then
        self.tags[tag] = self.timer:tween(duration, table, tween_table, tween_function, after)
    else
        self.timer:cancel(self.tags[tag])
        self.tags[tag] = self.timer:tween(duration, table, tween_table, tween_function, after)
    end
end

function Timer:after(tag, duration, func)
    if type(tag) == 'number' or type(tag) == 'table' then
        return self.timer:after(tag, duration, func)
    end

    if not self.tags[tag] then
        self.tags[tag] = self.timer:after(duration, func)
    else
        self.timer:cancel(self.tags[tag])
        self.tags[tag] = self.timer:after(duration, func)
    end
end

function Timer:every(tag, duration, func, count)
    if type(tag) == 'number' or type(tag) == 'table' then
        return self.timer:every(tag, duration, func, count)
    end

    if not self.tags[tag] then
        self.tags[tag] = self.timer:every(duration, func, count)
    else
        self.timer:cancel(self.tags[tag])
        self.tags[tag] = self.timer:every(duration, func, count)
    end
end

function Timer:during(tag, duration, func, after)
    if type(tag) == 'number' or type(tag) == 'table' then
        return self.timer:during(tag, duration, func, after)
    end

    if not self.tags[tag] then
        self.tags[tag] = self.timer:during(duration, func, after)
    else
        self.timer:cancel(self.tags[tag])
        self.tags[tag] = self.timer:during(duration, func, after)
    end
end

function Timer:cancel(tag)
    if self.tags[tag] then
        self.timer:cancel(self.tags[tag])
        self.tags[tag] = nil
    else self.timer:cancel(tag) end
end

function Timer:clear()
    self.timer:clear()
    self.tags = {}
end

function Timer:destroy()
    self.timer:clear()
    self.tags = {}
    self.timer = nil
end

return setmetatable({new = new}, {__call = function(_, ...) return Timer.new(...) end})
