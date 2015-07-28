local yaoui_path = ... .. '.'

local yaoui = {}
yaoui.UI = require(yaoui_path .. 'UI')
yaoui.Theme = require(yaoui_path .. 'YaouiTheme')
yaoui.Timer = require(yaoui_path .. 'Timer')
yaoui.winapi = require(yaoui_path .. 'dialogs.winapi')
yaoui.colorchooser = require(yaoui_path .. 'dialogs.winapi.colorchooser')
yaoui.filedialogs = require(yaoui_path .. 'dialogs.winapi.filedialogs')

yaoui.openColorPicker = function()
    local cc, cust = yaoui.winapi.CHOOSECOLOR({flags = 'CC_FULLOPEN'})
    cc = yaoui.winapi.ChooseColor(cc)
    local bit = require('bit')
    local r, g, b = bit.band(bit.rshift(cc.result, 0), 255), bit.band(bit.rshift(cc.result, 8), 255), bit.band(bit.rshift(cc.result, 16), 255)
    return r, g, b
end

yaoui.openSaveDialog = function(title, filter, filter_index, flags)
    local ok, info = yaoui.winapi.GetSaveFileName({
        title = title,
        filter = filter,
        filter_index = filter_index,
        flags = flags or 'OFN_ALLOWMULTISELECT|OFN_EXPLORER|OFN_ENABLESIZING|OFN_FORCESHOWHIDDEN'
    })
    if ok then return info.filepath, info.filename, info.filter_index end
end

yaoui.openOpenDialog = function(title, filter, filter_index, flags)
    local ok, info = yaoui.winapi.GetOpenFileName({
        title = title,
        filter = filter,
        filter_index = filter_index,
        flags = flags or 'OFN_ALLOWMULTISELECT|OFN_EXPLORER|OFN_ENABLESIZING|OFN_FORCESHOWHIDDEN'
    })
    if ok then return info.filepath, info.filename, info.filter_index end
end

local View = require(yaoui_path .. 'View')
yaoui.View = function(...) return View(yaoui, ...) end
local Stack = require(yaoui_path .. 'Stack')
yaoui.Stack = function(...) return Stack(yaoui, ...) end
local Flow = require(yaoui_path .. 'Flow')
yaoui.Flow = function(...) return Flow(yaoui, ...) end

local Button = require(yaoui_path .. 'Button')
yaoui.Button = function(...) return Button(yaoui, ...) end
local Checkbox = require(yaoui_path .. 'Checkbox')
yaoui.Checkbox = function(...) return Checkbox(yaoui, ...) end
local Dropdown = require(yaoui_path .. 'Dropdown')
yaoui.Dropdown = function(...) return Dropdown(yaoui, ...) end
local FlatDropdown = require(yaoui_path .. 'FlatDropdown')
yaoui.FlatDropdown = function(...) return FlatDropdown(yaoui, ...) end
local FlatTextinput = require(yaoui_path .. 'FlatTextinput')
yaoui.FlatTextinput = function(...) return FlatTextinput(yaoui, ...) end
local HorizontalSeparator = require(yaoui_path .. 'HorizontalSeparator')
yaoui.HorizontalSeparator = function(...) return HorizontalSeparator(yaoui, ...) end
local IconButton = require(yaoui_path .. 'IconButton')
yaoui.IconButton = function(...) return IconButton(yaoui, ...) end
local ImageButton = require(yaoui_path .. 'ImageButton')
yaoui.ImageButton = function(...) return ImageButton(yaoui, ...) end
local Text = require(yaoui_path .. 'Text')
yaoui.Text = function(...) return Text(yaoui, ...) end
local Textinput = require(yaoui_path .. 'Textinput')
yaoui.Textinput = function(...) return Textinput(yaoui, ...) end

return yaoui
