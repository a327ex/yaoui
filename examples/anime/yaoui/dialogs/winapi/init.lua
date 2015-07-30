
--core/winapi: winapi namespace + core + ffi: the platform for loading any proc/ file or oo/ file.
--Written by Cosmin Apreutesei. Public Domain.

local yui_path = (...):match('(.-)[^%.]+$')
setfenv(1, require(yui_path .. 'namespace'))
require(yui_path .. 'debug')
require(yui_path .. 'types')
require(yui_path .. 'util')
require(yui_path .. 'struct')
require(yui_path .. 'wcs')
require(yui_path .. 'bitmask')
return _M
