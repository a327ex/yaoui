--this is so that you can load winapi with the standard package.path setting.
local yui_path = (...):match('(.-)[^%.]+$')
return require(yui_path .. 'winapi.init')
