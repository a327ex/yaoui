# WARNING

### NO LONGER MAINTAINED

This project is no longer being maintained or updated in any way.

---

**yaoui** is a UI kit for LÖVE. If you need a fast way to build half-decent looking UI without having to worry about much then this module is for you. There are options for customization like changing theme colors or even how each UI element looks, but those are not the main problems this kit tries to solve.

<p align="center">
 <a href="https://imgrush.com/cogghKLdAEuv">
  <img border="0" src="http://i.imgur.com/z1h7AUH.jpg">
 </a>
</p>

## Table of Contents

* [Introduction](#introduction)
  * [View](#view)
  * [Stack](#stack)
  * [Flow](#flow)
  * [Accessing elements](#accessing-elements)
* [Elements](#elements)
  * [Button](#button)
  * [Checkbox](#checkbox)
  * [Dropdown](#dropdown)
  * [FlatDropdown](#flatdropdown)
  * [FlatTextinput](#flattextinput)
  * [HorizontalSeparator](#horizontalseparator)
  * [HorizontalSpacing](#horizontalspacing)
  * [IconButton](#iconbutton)
  * [ImageButton](#imagebutton)
  * [Tabs](#tabs)
  * [Textinput](#textinput)
  * [VerticalSeparator](#verticalseparator)
  * [VerticalSpacing](#verticalspacing)
* [Theme](#theme)
  * [Changing the theme](#changing-the-theme)

## Usage

Require the [module](https://github.com/adonaac/yaoui/tree/master/yaoui):

```lua
yui = require 'yaoui'
```

Register it to most of LÖVE's callbacks:

```lua
function love.load()
  yui.UI.registerEvents()
end
```

And update:

```lua
function love.update(dt)
  yui.update({})
end
```

## Introduction

The main idea behind yaoui is the usage of 3 main elements for directing UI layout: **views**, **stacks** and **flows**. The idea is taken from the Ruby [shoes](http://shoesrb.com/) library. Check that link out since it's immediately obvious what stacks and flows do.

### View

Views are effectively windows that can contain a Stack or a Flow. You can specify the position of a view, as well as its margins:

```lua
function love.load()
  yui.UI.registerEvents()
  yui.debug_draw = true

  view = yui.View(50, 50, 400, 300, {
    margin_top = 10,
    margin_left = 10,
    yui.Stack({
      yui.Button({text = 'Some button', hover = 'Button hover'}),
      yui.Button({text = 'Some button', hover = 'Button hover'}),
      yui.Button({text = 'Some button', hover = 'Button hover'}),
    })
  })
end

function love.update(dt)
  yui.update({view})
  view:update(dt)
end

function love.draw()
  view:draw()
end
```

And that will get you something like this (yui.debug_draw is set to true so you can see View and Stack area rectangles):

![ya1](http://i.imgur.com/VBBfpLi.gif)

---

### Stack

Stacks let you stack UI elements together on top of each other. You can set its margins as well as the spacing between each element. You can also make it so that elements are added from the bottom of the Stack instead of from the top.

Continuing from the previous example, this:

```lua
view = yui.View(50, 50, 400, 300, {
  margin_top = 10,
  margin_left = 10,
  yui.Stack({margin_left = 10, margin_top = 10, margin_bottom = 10, margin_right = 10, spacing = 5,
    yui.Button({text = 'Some button', hover = 'Button hover'}),
    yui.Button({text = 'Some button', hover = 'Button hover'}),
    yui.Button({text = 'Some button', hover = 'Button hover'}),

    bottom = {
      yui.Button({text = 'Other button', hover = 'Button hover'}),
      yui.Button({text = 'Other button', hover = 'Button hover'}),
      yui.Button({text = 'Other button', hover = 'Button hover'}),
    }
  })
})
```

Should get you this:

![ya2](http://i.imgur.com/mmQOZVq.gif)

---

### Flow

Flows let you stack UI elements together from left to right. Like with a Stack, you can set a flows margin as well as spacing between each element. You can also start stacking from the right if you want.

```lua
view = yui.View(50, 50, 600, 300, {
  margin_top = 10,
  margin_left = 10,
  yui.Flow({margin_left = 10, margin_top = 10, margin_bottom = 10, margin_right = 10, spacing = 5,
    yui.Button({text = 'Some button', hover = 'Button hover'}),
    yui.Button({text = 'Some button', hover = 'Button hover'}),

    right = {
      yui.Button({text = 'Other button', hover = 'Button hover'}),
      yui.Button({text = 'Other button', hover = 'Button hover'}),
    }
  })
})
```

![ya3](http://i.imgur.com/I4rMyyo.gif)

---

With these 3 main elements you get a good compromise between not having to do any manual placement but also being able to lay your elements out in a way that looks appealing. You can put Flows inside Stacks, Stacks inside Flows, Stacks inside Stacks, etc and have them be nested in whatever way you want. The only limitation is that a View should only have one element and that element should be either a Stack or a Flow (and then inside this Stack/Flow you can do whatever).

### Accessing elements

All elements in the View tree can be accessed from the view. In the examples above, for instance, if we wanted to access the right-most button on the Flow, we'd do:

```lua
view[1].right[2]
```

Here `[1]` refers to the Flow, `right` refers to elements that stack from the right, and `[2]` refers to the second button (right-most). To make thinks easier we can also define `name` attributes for each element, for instance:

```lua
view = yui.View(50, 50, 600, 300, {
  margin_top = 10,
  margin_left = 10,
  yui.Flow({
    name = 'MainFlow',
    margin_left = 10, margin_top = 10, margin_bottom = 10, margin_right = 10, spacing = 5,
    yui.Button({text = 'Some button', hover = 'Button hover'}),
    yui.Button({text = 'Some button', hover = 'Button hover'}),

    right = {
      yui.Button({text = 'Other button', hover = 'Button hover'}),
      yui.Button({name = 'RightMostButton', text = 'Other button', hover = 'Button hover'}),
    }
  })
})
```

And now to get the right-most button we can do:

```lua
view.MainFlow.right.RightMostButton
```

All UI elements created with yaoui can have a `name` attribute attached to them so that they can be accessed in this manner. If they don't have this `name` attribute they can still be accessed via their index position.

## Elements

Here follows a description of all UI elements. For elements where *icons* are available they refer to [Font Awesome Icons](http://fontawesome.io/icons/). All icons can be specified with `icon = fa-icon_name` where `icon_name` is the Font Awesome icon name.

### Button

```lua
yui.Button({text = 'Button text', onClick = function(self) print(1) end})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | button's name | no |
| text | button's text | no |
| icon | button's Font Awesome icon | no |
| icon_right | if the icon should be on the right of the button's text instead of on the left | no |
| size | button's size (affects font, icon, height) | no |
| hover | button's hover text | no |
| onClick | function called on button click, receives the button object as an argument | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| button | Thranduil button object |
| icon_str | icon string (fa-icon_name) |

#### Methods

**setLoading():** if the button has an icon, then this will set the icon to a loading animation. Useful when a button triggers some action that takes some time to perform.

**unsetLoading():** sets the button icon back to normal.

---

### Checkbox

```lua
yui.Checkbox({text = 'Checkbox text', onClick = function(self) print(1) end})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | checkbox's name | no |
| text | checkbox's text | yes |
| size | checkbox's size (affects font, icon, height) | no |
| onClick | function called on checkbox click, receives the checkbox object as an argument | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| checkbox | Thranduil checkbox object |
| checked | if the checkbox is checked or not |
| icon | checkbox checked icon, defaults to `yui.Theme.font_awesome['fa-check']` |

---

### Dropdown

```lua
yui.Dropdown({options = {'All', 'Option1', 'Option2'}, onSelect = function(self, option) print(option) end})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | dropdown's name | no |
| options (table of strings) | dropdown options | yes |
| title | dropdown title (text to the left of it) | no |
| drop_up (boolean) | if the dropdown should go up instead of down | no |
| size | dropdown's size (affects font, icon, height) | no |
| onSelect | function called on option select, receives the object and the option as arguments | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| main_button | Thranduil button object, main dropdown button |
| down_area | Thranduil frame object, visible and updates when the dropdown list is enabled |
| current_option | currently selected option |
| icon | dropdown main button's icon, defaults to `yui.Theme.font_awesome['fa-sort-desc']`

---

### FlatDropdown

Exactly the same as a Dropdown, just looks different.

### FlatTextinput

Exactly the same as a Textinput, just looks different.

### HorizontalSeparator

```lua
yui.HorizontalSeparator({w = 100})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | horizontal separator's name | no |
| w | the width of the line | yes |
| margin_left | left margin | no |
| margin_right | right margin | no |
| size | separator's size (affects height) | no |

---

### HorizontalSpacing

```lua
yui.HorizontalSpacing({w = 50})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | horizontal spacing's name | no |
| w | the width of the spacing | yes |
| size | spacing's size (affects height) | no |

---

### IconButton

```lua
yui.IconButton({icon = 'fa-close', onClick = function(self) print(1) end})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | icon button's name | no |
| icon | font awesome icon | yes |
| hover | icon button's hover text | no |
| size | icon button's size (affects font, icon, height) | yes |
| onClick | function called on icon button click, receives the icon button object as an argument | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| button | Thranduil button object |

---

### ImageButton

```lua
yui.ImageButton({image = some_image, onClick = function(self) print(1) end})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | image button's name | no |
| rounded_corners (boolean) | if the image button has rounded corners or not | no |
| image | image button's image (LÖVE image object) | yes |
| ix, iy | image button's image offset (from top-left) | no |
| overlayNew | function called on object creation, receives the image button object as an argument | no
| overlayUpdate | function called every update, receives the image button object and dt as an argument | no |
| overlay | function called every draw call, receives the image button object as an argument | no |
| onClick | function called on image button click, receives the image button object as an argument | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| button | Thranduil button object |
| img | image button image |
| alpha | overlay alpha (goes to 255 as the user hovers, back to 0 when not hovering)|

---

### Tabs

```lua
yui.Tabs({tabs = {
    {text = 'Tab1', hover = 'Tab1', onClick = function(self) print(1) end},
    {text = 'Tab2', hover = 'Tab2', onClick = function(self) print(2) end},
    {text = 'Tab3', hover = 'Tab3', onClick = function(self) print(3) end},
}})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | tabs' name | no |
| tabs (table of tabs) | tabs list | yes |
| size | tabs' size (affects font, icon, height) | no |

#### Tab construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| text | tab's text | yes |
| hover | tab's hover text | yes |
| onClick | function called on tab selection, receives the tab object as an argument | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| buttons | tabs Thranduil button objects |
| selected_tab | currently selected tab |

---

### Textinput

```lua
yui.Textinput({onEnter = function(self, text) print(text) end})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | textinput's name | no |
| size | textinput's size (affects font and height) | no |
| onEnter | function called on pressing enter, receives the textinput object and the text as arguments | no |

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| textarea | Thranduil textinput object |

#### Methods

**setText():** sets the textinput's text

**getText():** returns the textinput's text

---

### VerticalSeparator

```lua
yui.VerticalSeparator({h = 100})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | vertical separator's name | no |
| h | the height of the line | yes |
| margin_top | top margin | no |
| margin_bottom | bottom margin | no |
| size | separator's size (affects width) | no |

---

### VerticalSpacing

```lua
yui.VerticalSpacing({h = 50})
```

#### Construction options

| Option | Description | Mandatory |
| :----- | :---------- | :-------- |
| name | vertical spacing's name | no |
| h | the height of the spacing | yes |
| size | spacing's size (affects width) | no |

---

## Theme

The default theme file can be found in `yaoui/YaouiTheme.lua`. Internally yaoui uses [Thranduil](https://github.com/adonaac/thranduil) to make everything work, and so the theming system is the same here as it is there. Basically it's one big file with functions for all UI objects. The theme also has a few helpful variables (the theme itself can be accessed via `yui.Theme`):

| Variable | Description |
| :----- | :---------- |
| colors | a table containing all colors used by all elements |
| font_awesome | the Font Awesome icon table, `font_awesome[fa-icon_name]` returns you the icon character which can only be drawn with the Font Awesome font |
| font_awesome_path | path to the Font Awesome font |
| open_sans_regular | path to the Open Sans Regular font |
| open_sans_light | path to the Open Sans Light font |
| open_sans_bold | path to the Open Sans Bold font |
| open_sans_semibold | path to the Open Sans Semibold font |

### Changing the theme

I'm not going to list all theme colors here since you can easily check them yourself. But the easiest way to change the look of the theme is by changing the colors around. For instance, the following code swaps blue and red components for each color:

```lua
for color_name, color in pairs(yui.Theme.colors) do
  yui.Theme.colors[color_name] = {color[3], color[2], color[1]}
end
```

![red](http://i.imgur.com/O1nAnjo.jpg)

The second way of changing the theme is by specifying the draw functions of each element yourself. This is harder because it requires you to have an understanding of the attributes of each UI element and how they work, but it's very doable. 

You should start by removing all `new` and `update` functions, since those are only used if you need something like tweens or transitions. Then you should clear out the draw functions (remove all their content) and start defining, for each object you wanna use, how they will be drawn. Use Thranduil's TestTheme and yaoui's YaouiTheme as reference points and go from there. It's also important to keep all draw functions defined, even if they're empty, otherwise the program won't run.

## LICENSE

You can do whatever you want with this. See the [LICENSE](https://github.com/adonaac/yaoui/blob/master/LICENSE).
