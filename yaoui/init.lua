
local yaoui_path = ... .. '.'

local yaoui = {}
yaoui.UI = require(yaoui_path .. 'UI')
yaoui.Theme = require(yaoui_path .. 'YaouiTheme')
yaoui.Timer = require(yaoui_path .. 'Timer')

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
local HorizontalSpacing = require(yaoui_path .. 'HorizontalSpacing')
yaoui.HorizontalSpacing = function(...) return HorizontalSpacing(yaoui, ...) end
local IconButton = require(yaoui_path .. 'IconButton')
yaoui.IconButton = function(...) return IconButton(yaoui, ...) end
local ImageButton = require(yaoui_path .. 'ImageButton')
yaoui.ImageButton = function(...) return ImageButton(yaoui, ...) end
local Tabs = require(yaoui_path .. 'Tabs')
yaoui.Tabs = function(...) return Tabs(yaoui, ...) end
local Text = require(yaoui_path .. 'Text')
yaoui.Text = function(...) return Text(yaoui, ...) end
local Textinput = require(yaoui_path .. 'Textinput')
yaoui.Textinput = function(...) return Textinput(yaoui, ...) end
local VerticalSeparator = require(yaoui_path .. 'VerticalSeparator')
yaoui.VerticalSeparator = function(...) return VerticalSeparator(yaoui, ...) end
local VerticalSpacing = require(yaoui_path .. 'VerticalSpacing')
yaoui.VerticalSpacing = function(...) return VerticalSpacing(yaoui, ...) end

yaoui.update = function(views)
    love.mouse.setCursor()

    -- When a dropdown list is being interacted with, then prevent elements under it from being updated
    local all_elements = {}
    for _, view in ipairs(views) do
        local elements = view:getAllElements()
        for _, e in ipairs(elements) do table.insert(all_elements, e) end
    end
    local any_dropdown_area_hot = false
    for i, element in ipairs(all_elements) do
        element.dont_update = false
        if element.class_name == 'Dropdown' or element.class_name == 'FlatDropdown' then
            if element.down_area.hot then any_dropdown_area_hot = i end
        end
    end
    if any_dropdown_area_hot then
        for i, element in ipairs(all_elements) do
            if i == any_dropdown_area_hot then element.dont_update = false
            else element.dont_update = true end
        end
    end
end

--[[
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
]]--

return yaoui
