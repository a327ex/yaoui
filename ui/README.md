# Thranduil

A UI module for LÖVE. Facilitates the creation of game specific UI through UI elements that have all their logic abstracted away. Each element is simple enough and exposes as much of its state as possible, meaning you can use this state to draw the element in whatever way you want or to build new UI elements with it (say you wanna make a menu, you can do it with a bunch of Buttons and a Frame). Elements can also be expanded easily via the injection of custom attributes and methods, providing **!¡ENDLESS CUSTOMIZABILITY¡!**

## Usage

Require the [module](https://github.com/adonaac/thranduil/blob/master/ui/UI.lua):

```lua
UI = require 'UI'
```

And register it to most of LÖVE's callbacks:

```lua
function love.load()
  UI.registerEvents()
end
```

## Table of Contents

* [Introduction](#introduction)
  * [Themes](#themes)
  * [Extensions](#extensions)
* [Mixins](#mixins)
  * [Base](#base)
    * [Attributes](#attributes)
    * [Methods](#methods)
    * [Extensions](#extensions-1)
  * [Closeable](#closeable)
    * [Attributes](#attributes-1)
  * [Container](#container)
    * [Attributes](#attributes-2)
    * [Methods](#methods-1)
  * [Draggable](#draggable)
    * [Attributes](#attributes-3)
    * [Methods](#methods-2)
  * [Resizable](#resizable)
    * [Attributes](#attributes-4)
* [Elements](#elements)
  * [Button](#button)
    * [Methods](#methods-3)
  * [Checkbox](#checkbox)
    * [Attributes](#attributes-5)
    * [Methods](#methods-4)
  * [Frame](#frame)
    * [Methods](#methods-5)
  * [Scrollarea](#scrollarea)
    * [Attributes](#attributes-6)
    * [Methods](#methods-6)
  * [Slider](#slider)
    * [Attributes](#attributes-7)
    * [Methods](#methods-7)
  * [Textarea](#textarea)
    * [Attributes](#attributes-8)
    * [Methods](#methods-8)
    * [Textarea Tags](#textarea-tags)
* [Walkthroughs](#walkthroughs)

## Introduction

For this example we'll create a button object at position `(10, 10)` with width/height `(90, 90)`:

```lua
button = UI.Button(10, 10, 90, 90)
```

This object can then be updated via `button:update(dt)` and it will automatically have its attributes changed as the user hovers, selects or presses it. Drawing however is handled by you, which means that the button's draw function has to be defined.

### Themes

The way draw functions are defined for each UI element takes the form of themes. A theme is nothing more than a file that returns a table containing a bunch of functions. These functions are then injected into an element and are used to draw it. Here's an example of a theme:

```lua
-- in Theme.lua
local Theme = {}

Theme.Button = {}
Theme.Button.draw = function(self)
  love.graphics.setColor(64, 64, 64)
  if self.down then love.graphics.setColor(32, 32, 32) end
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  love.graphics.setColor(255, 255, 255)
end

return Theme
```

This simple theme defines a `draw` function under `Theme.Button`. What we can now do is require the theme:

```lua
Theme = require 'Theme'
```

And then we can use the function defined by this theme in the creation of our UI elements. So, for instance, the button we created up there would look like this:

```lua
button = UI.Button(10, 10, 90, 90, {extensions = {Theme.Button}})
```

This module comes with a predefined default theme that you can use to learn how to draw each element. It can be found [here](https://github.com/adonaac/thranduil/blob/master/TestTheme.lua).

### Extensions

Extensions can be used to EXTEND an UI element. This is the primary way in which you can add draw functions to an object so that it can be drawn. The `extensions` setting takes care of this when creating an UI element takes care of binding `new`, `update` and `draw` functions based on the table received. So if in the theme above we defined `new` and `update` functions along with the `draw` one we defined, the UI element created would run those functions at the end of its constructor and at the end of its update function, respectively. This is one way in which you can customize the way your elements look and behave.

You can add multiple extensions to a single object:

```lua
button = UI.Button(10, 10, 90, 90, {extensions = {Theme.Button, OtherTheme.Button}})
```

After this section the documentation goes over all the features in each UI element in detail. One important thing to note is that most elements and mixins have an `Attributes` section. A lot of those attributes should be set on object creation if you want that behavior in your object. For instance, say you want to create a Frame that is Draggable and Closeable. The Draggable and Closeable mixins have descriptions of the attributes they contain, such as `draggable`, `closeable`, `close_margin_top`, and so on. These attributes can be set on object creation like so:

```lua
button = UI.Button(10, 10, 90, 90, {extensions = {Theme.Button}, draggable = true, closeable = true, close_margin_top = 10})
```

This is the primary way in which you can activate and change the main funcionalities of your UI elements. You can also add custom attributes via this method. Say you want to make a Button have a text label:

```lua
button = UI.Button(10, 10, 90, 90, {extensions = {Theme.Button}, text = 'Label'})
```

Now if you say `print(button.text)`, `'Label'` will be printed. Even though the Button object nor any of its mixins have this attribute by default this will work. Just make sure to not name collide with attributes that the object you're creating already uses (such as adding a `enter` attribute for instance, since the Base mixin (which all entities have) already uses it). You can also access the custom attributes on your theme since you have access to the object via `self`:

```lua
-- in Theme.lua
Theme.Button.draw = function(self)
  love.graphics.print(self.text, self.x, self.y) -- will print 'Label' at self.x, self.y
end
```

## Mixins

Internally each UI element is composed of multiple mixins (reusable code that's common between some elements) as well as specific code that makes that element work. For the purposes of saving documentation space by not repeating the same attributes and methods over multiple objects, I've listed those mixins here, but when using the UI library you probably won't need to care about them. On the [Elements](#elements) section, when an UI element implements Base, Draggable and Resizable for instance, it means that it contains all the attributes and methods of those 3 mixins.

### Base

Base mixin that gives core functionality to all UI elements.

---

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| x, y | the element's top-left position |
| w, h | the element's width and height |
| hot | true if the mouse is over this element (inside its x, y, w, h rectangle) |
| selected | true if the element is currently selected (if its being interacted with or selected with TAB) |
| pressed | true on the frame the element is pressed |
| down | true when the element is being held down after being pressed |
| released | true on the frame the element is released |
| enter | true on the frame the mouse enters this element's area |
| exit | true on the frame the mouse exits this element's area |
| selected_enter | true on the frame the element enters selection |
| selected_exit | true on the frame the element exists selection |

---

#### Methods

**`bind(key, action):`** binds a key to a button action. Current actions are:

| Action | Default Key | Description |
| :----- | :---------- | :---------- |
| left-click | mouse1 | mouse's left click |
| right-click | mouse2 | mouse's right click |
| key-enter | return | activation key, enter |

---

#### Extensions

**`getMousePosition():`** internal function that is used to get the current mouse position. By default uses `love.mouse.getPosition()` but can be changed to use anything. For instance, if we're using a camera system and scaling everything up/down, for the mouse to report correct positions according to the scale used we could do something like this:

```lua
element.getMousePosition = function() return camera:mousepos() end
```

This assumes you have a camera object with a `mousepos` function (like [hump's camera system](http://vrld.github.io/hump/#hump.cameracamera:mousepos), for instance). Using that function we can change `getMousePosition` to report the mouse position according to the camera's coordinate system and it will all work out. :-)

---

### Closeable

Makes it so that a UI element has a close button and that it can be closed.

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| closeable | if this element can be closed or not | false |
| closed | if the element is closed or not | false |
| close_margin_top | top margin for close button | 5 |
| close_margin_right | right margin for close button | 5 |
| close_button_width | width of the close button | 10 |
| close_button_height | height of the close button | 10 |
| close_button_extensions | the extensions to be used for the close button | |
| close_button | a reference to the close button | |

```lua
frame = UI.Frame(0, 0, 100, 100, {extensions = {Theme.Frame}, closeable = true, close_margin_top = 10, close_margin_right = 10, close_button_extensions = {Theme.Button}})
```

##### Warnings

* If the `closeable` attribute is not set to true, then the close button logic for this element won't happen.
* If `closed` is set to true then the frame won't update nor be drawn.
* `close_button_extensions` has to be set otherwise the close button won't be drawn.
* Default values are set if the attribute is omitted on the settings table on this element's creation.

---

### Container

Adds the ability for an UI element to contain other UI elements.

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| elements | a table holding all children inside this element | {} |
| currently_focused_element | index of the child that is currently focused | |
| any_selected | if any child is selected or not | false |
| auto_align | if added elements are auto aligned to a grid or not | false |
| auto_spacing | if `auto_align` is true, the spacing between each added element | 5 |
| auto_margin | if `auto_align` is true, the margin between elements and the border of the container | 5 |
| disable_tab_selection | disables selecting next child with the TAB key | |
| disable_directional_selection | disables selecting neighbor children with the arrow keys | |

```lua
frame = UI.Frame(0, 0, 100, 100, {extensions = {Theme.Frame}, auto_align = true, auto_spacing = 10})
```

---

#### Methods

**`bind(key, action):`** binds a key to a button action. Current actions are:

| Action | Default Key | Description |
| :----- | :---------- | :---------- |
| focus-next | tab | selects the next child to focus on (sets its `.selected` attribute to true) |
| previous-modifier | lshift | modifier key to be pressed with `focus-next` to focus on the previous child |
| unselect | escape | unselects the currently selected child |
| focus-left | left | selects the child to the left of the current one |
| focus-right | right | selects the child to the right of the current one |
| focus-up | up | selects the child above the current one |
| focus-down | down | selects the child below the current one |

---

**`destroy():`** removes all children from the container and from the UI module. Sometimes setting the element to `nil` doesn't cut it (when you're holding references to each element added to the container) and this function forcefully removes all children from memory.

**`focusElement(n):`** focuses the N-th child in the container

**`focusDirection(direction):`** mimicks a `focus-direction` action and focuses on the appropriate child. Valid directions are: `'left'`, `'right'`, `'up'`, `'down'`

**`focusNext():`** mimicks a `focus-next` action and focuses on the next child

**`focusPrevious():`** mimicks a `focus-previous` action and focuses on the previous child

**`forceUnselect():`** unselects all children

**`unselect():`** mimicks a `unselect` action and unselects the currently focused child

---

### Draggable

Adds the ability for an UI element to be dragged.

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| draggable | if this element can be dragged or not | false |
| drag_margin | top margin for drag bar | self.h/4 |
| drag_hot | true if the mouse is over this element's drag area (inside its x, y, w, h rectangle) | |
| drag_enter | true on the frame the mouse enters this element's drag area | |
| drag_exit | true on the frame the mouse exits this element's exit area | |
| drag_start | true on the frame dragging starts | |
| drag_end | true on the frame draggine ends | |
| drag_min_limit_x, y | minimum x, y limit this element can be dragged to | |
| drag_max_limit_x, y | maximum x, y limit this element can be dragged to | |
| only_drag_horizontally | only drags the element horizontally | |
| only_drag_vertically | only drags the element vertically | |

```lua
frame = UI.Frame(0, 0, 100, 100, {extensions = {Theme.Frame}, draggable = true, drag_min_limit_x = 50, drag_max_limit_x = 150, only_drag_horizontally = true})
```

#### Warnings

* If the `draggable` attribute is not set to true, then the dragging logic for this element won't happen.
* Default values are set if the attribute is omitted on the settings table on this element's creation.

---

#### Methods

**`setDragLimits(x_min, y_min, x_max, y_max):`** sets this element's drag limits

```lua
-- Makes it so that the element can't be dragged below x = 100 and above x = 400
element:setDragLimits(100, nil, 400, nil)
```

---

### Resizable

Makes it so that this UI element can be resized with the mouse (by dragging its borders).

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| resizable | if this element can be resized or not | false |
| resize_margin_top | top resize margin | 0 |
| resize_margin_bottom | bottom resize margin | 0 |
| resize_margin_left | left resize margin | 0 |
| resize_margin_right | right resize margin | 0 |
| resize_corner | if set to any of the possible values then disables resizing by margin and enables resizing by corner only, possible values are `'top-left'`, `'top-right'`, `'bottom-left'`, `'bottom-right'` | |
| resize_corner_width | the width of the corner rectangle that can be dragged to resize the element | 0 |
| resize_corner_height | the height of the corner rectangle that can be dragged to resize the element | 0 |
| resize_hot | true if the mouse is over this element's resize area | |
| resize_enter | true on the frame the mouse enters this element's resize area | |
| resize_exit | true on the frame the mouse exits this element's resize area | |
| resize_start | true on the frame resizing starts | |
| resize_end | true on the frame resizing ends | |
| min_width | minimum element width | |
| min_height | minimum element height | |
| max_width | maximum element width | |
| max_height | maximum element height | |

```lua
frame = UI.Frame(0, 0, 100, 100, {extensions = {Theme.Frame}, resizable = true, resize_corner = 'bottom-right', resize_corner_width = 10, resize_corner_height = 10})
```

#### Warnings

* If the `resizable` attribute is not set to true, then the resizing logic for this element won't happen.
* Setting `resize_corner` to true disables resizing via margins.
* If the element is draggable, resizing always takes precedence over dragging when both areas collide.
* Default values are set if the attribute is omitted on the settings table on this element's creation.

---

## Elements

### Button

A button is a rectangle that can be pressed. Implements:

* [Base](#base)
* [Draggable](#draggable)
* [Resizable](#resizable)

---

#### Methods

**`new(x, y, w, h, settings):`** creates a new button. The settings table is optional and default values will be used in case some attributes are omitted.

```lua
button = UI.Button(0, 0, 100, 100, {extensions = {Theme.Button}, draggable = true})
```

---

**`press():`** mimicks a button press, setting `pressed` and `released` to true for one frame and also setting `selected` to true.

```lua
function update(dt)
  button:update(dt)
  -- Automatically presses the button whenever the mouse hovers over it
  if button.enter then button:press() end
end
```

---

### Checkbox

A checkbox is like a button that can be checked or not. Implements:

* [Base](#base)
* [Draggable](#draggable)
* [Resizable](#resizable)

---

#### Attributes

| Attribute | Description |
| :-------- | :---------- |
| checked | if the checkbox is checked or not |

---

#### Methods

**`toggle():`** mimicks a checkbox press, changing the checkbox's `checked` state

```lua
function update(dt)
  checkbox:update(dt)
  -- Automatically changes the checkbox's state on hover enter
  if checkbox.enter then checkbox:toggle() end
end
```

---

### Frame

A frame is a container/panel/window that can contain other UI elements. Implements:

* [Base](#base)
* [Closeable](#closeable)
* [Container](#container)
* [Draggable](#draggable)
* [Resizable](#resizable)

---

#### Methods

**`new(x, y, w, h, settings):`** creates a new frame. The settings table is optional and default values will be used in case some attributes are omitted.

```lua
frame = UI.Frame(0, 0, 100, 100, {extensions = {Theme.Frame}, draggable = true, drag_margin = 10, resizable = true, resize_margin = 5})
```

---

**`addElement(element):`** adds an element to the frame. Elements added must be specified with their positions in relation to the frame's top-left position. The added element is returned.

```lua
-- the button is drawn at position (5, 5) from the frame's top-left corner
local button = frame:addElement(UI.Button(5, 5, 100, 100, {extensions = {Theme.Button}}))
```

---

**`getElement(id):`** returns the element with the given id

**`removeElement(id):`** removes an element from the frame. The id to be passed can be accessed via the `id` attribute of an element.

```lua
local button = frame:addElement(UI.Button(5, 5, 100, 100, {extensions = {Theme.Button}}))
frame:removeElement(button.id)
```

---

### Scrollarea

A scrollarea is an area that can contain other UI elements and that also can be scrolled. Implements:

* [Base](#base)
* [Container](#container)

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| area_width | visible scrollarea's width | self.w |
| area_height | visible scrollarea's height | self.h |
| scroll_button_width | width of all scroll buttons | 15 |
| scroll_button_height | height of all scroll buttons | 15 |
| show_scrollbars | if scrollbars are visible or not, can still scroll even without them visible | |
| dynamic_scroll_set | if scroll enabling should be activated automatically or not when elements go over the scrollarea's area | |
| horizontal_scrollbar_button | reference to the horizontal scrollbar slider button | |
| horizontal_scrollbar_left_button | reference to the horizontal scrollbar left button | |
| horizontal_scrollbar_right_button | reference to the horizontal scrollbar right button | |
| horizontal_step | horizontal scrolling step in pixels | 5 |
| horizontal_scrolling | if horizontal scrolling is activated | true if area_width < self.w |
| vertical_scrollbar_button | reference to the vertical scrollbar slider button | |
| vertical_scrollbar_top_button | reference to the vertical scrollbar top button | |
| vertical_scrollbar_bottom_button | reference to the vertical scrollbar bottom button | |
| vertical_step | vertical scrolling step in pixels | 5 |
| vertical_scrolling | if vertical scrolling is activated | true if area_height < self.h |

---

#### Methods

**`new(x, y, w, h, settings):`** creates a new scrollarea. The settings table is optional and default values will be used in case some attributes are omitted.

```lua
scrollarea = UI.Scrollarea(0, 0, 200, 200, {area_width = 100, area_height = 100, show_scrollbars = true})
```

---

**`bind(key, action):`** binds a key to a button action. Current actions are:

| Action | Default Key | Description |
| :----- | :---------- | :---------- |
| scroll-left | left | scrolls left by `horizontal_step` pixels |
| scroll-right | right | scrolls right by `horizontal_step` pixels |
| scroll-up | up | scrolls up by `vertical_step` pixels |
| scroll-down | down | scrolls down by `vertical_step` pixels |

---

**`addElement(element):`** adds an element to the scrollarea. Elements added must be specified with their positions in relation to the scrollarea's top-left position. The added element is returned.

```lua
-- the button is drawn at position (5, 5) from the scrollarea's top-left corner
local button = scrollarea:addElement(UI.Button(5, 5, 100, 100, {extensions = {Theme.Button}}))
```

---

**`getElement(id):`** returns the element with the given id

**`removeElement(id):`** removes an element from the scrollarea. The id to be passed can be accessed via the `id` attribute of an element.

```lua
local button = scrollarea:addElement(UI.Button(5, 5, 100, 100, {extensions = {Theme.Button}}))
scrollarea:removeElement(button.id)
```

---

**`scrollLeft(step):`** mimicks a `scroll-left` action and scrolls by `step` pixels

**`scrollRight(step):`** mimicks a `scroll-right` action and scrolls by `step` pixels

**`scrollUp(step):`** mimicks a `scroll-up` action and scrolls by `step` pixels

**`scrollDown(step):`** mimicks a `scroll-down` action and scrolls by `step` pixels

---

### Slider

A slider is a... slider. Like, you can press on it and depending on where you pressed it corresponds to some value within a min/max limit. Implements:

* [Base](#base)
* [Draggable](#draggable)
* [Resizable](#resizable)

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| vertical | if the slider should be vertical or not | |
| value | the current slider value (from 0 to self.w (or self.h if `vertical` is true)) | 0 |
| min_value | the minimum slider value | 0 |
| max_value | the maximum slider value | self.w or self.h |
| value_interval | minimum value between each slider value jump (if it's 5 then the slider can only have values 5, 10, 15, ...) | 1 |
| slider_x, y | slider value's x, y position in pixels | self.x or self.y |
| slide_start | true on the frame sliding starts | |
| slide_end | true on the frame sliding ends | |

---

#### Methods

**`new(x, y, w, h, settings):`** creates a new slider. The settings table is optional and default values will be used in case some attributes are omitted.

```lua
slider = UI.Slider(0, 0, 20, 200, {extensions = {Theme.Slider}, vertical = true, value_interval = 10})
```

---

**`bind(key, action):`** binds a key to a button action. Current actions are:

| Action | Default Key | Description |
| :----- | :---------- | :---------- |
| move-left | left | decreases the slider's value once |
| move-right | right | increases the slider's value once |
| move-up | right | increases the slider's value once |
| move-down | right | decreases the slider's value once |

---

**`moveLeft():`** mimicks a `move-left` action and decreases the slider's value once

**`moveRight():`** mimicks a `move-right` action and increases the slider's value once

**`moveUp():`** mimicks a `move-up` action and increases the slider's value once

**`moveDown():`** mimicks a `move-down` action and decreases the slider's value once

---

### Textarea

A textarea is an area that can contain text and be editted. It uses [Popo](https://github.com/adonaac/popo) internally for text operations, displaying and so on. Implements:

* [Base](#base)

---

#### Attributes

| Attribute | Description | Default Value |
| :-------- | :---------- | :------------ |
| text | reference to the Popo text object | |
| text_margin | top-left-right-bottom margin | 5 |
| text_x, y | text's x, y positions | self.x + self.text_margin, self.y + self.text_margin |
| font | the font to be used | default LÖVE font |
| single_line | if the text area allows only one line of input | false |
| editing_locked | if the textarea can be edited or not | |
| index | the index of the cursor (a number that goes from 1 to the length of the text) | |
| selection_index | if text isn't being selected (cursor is only in one place) then this is nil, otherwise it points to the index of the end of the current selection | |
| selection_positions.x, y | cursor top-left selection positions | |
| selection_sizes.w, h | cursor width/height selection sizes | |
| tab_width | number of spaces that compose a single TAB | 4 |
| wrap_width | if the text has multiple lines, the maximum size in pixels before it wraps to the next | self.w - 4*self.text_margin |
| wrap_text_in | a table containing all tags that will envelop text added | {} |
| undo_stack_size | the maximum number of undo states that are saved in the undo stack | 50 |
| disable_undo_redo_keys | disables undoing/redoing via key presses | |
| undo_pushed | set to the id of the textarea element on the frame an undo action is pushed to the undo stack | |
| cursor_visible | if the cursor is visible or not (it sets itself automatically to true or false at a certain interval (cursor blinking)) | |
| cursor_blink_interval | the rate in seconds at which the cursor blinks | 0.5 |

---

#### Methods

**`new(x, y, w, h, settings):`** creates a new textarea. The settings table is optional and default values will be used in case some attributes are omitted.

```lua
textarea = UI.Textarea(0, 0, 200, 200, {text_margin = 3})
```

---

**`bind(key, action):`** binds a key to a button action. Current actions are:

| Action | Default Key | Description |
| :----- | :---------- | :---------- |
| move-left | left | moves the cursor to the left |
| move-right | right | moves the cursor to the right |
| move-up | up | moves the cursor up |
| move-down | down | moves the cursor down |
| lshift | lshift | shift modifier |
| backspace | backspace | deletes the character before the cursor |
| delete | delete | deletes the character after the cursor |
| lctrl | lctrl | control modifier |
| first | home | moves to the beginning of the text |
| last | end | moves to the end of the text |
| return | enter | inserts a new line to the text |
| tab | tab | inserts a tab to the text |
| cut | x | cuts the selected text with `lctrl + cut` |
| copy | c | copies the selected text with `lctrl + copy` |
| paste | p | pastes the selected text with `lctrl + paste` |
| all | a | selected all text with `lctrl + all` |
| undo | z | when used with `lctrl`, undos the last action |
| redo | r | when used with `lctrl`, redos the last undone action |
| unselect | escape | unselects the textarea |

---

**`textinput(text):`** inserts a single character `text` into the text object

**`moveLeft():`** mimicks a `move-left` action and moves the cursor to the left once

**`moveRight():`** mimicks a `move-right` action and moves the cursor to the right once

**`moveUp():`** mimicks a `move-up` action and moves the cursor up once

**`moveDown():`** mimicks a `move-down` action and moves the cursor down once

**`selectLeft():`** mimicks a `lshift + move-left` action and selects to the left of the cursor once

**`selectRight():`** mimicks a `lshift + move-right` action and selects to the right of the cursor once

**`selectUp():`** mimicks a `lshift + move-up` action and selects up once

**`selectDown():`** mimicks a `lshift + move-down` action and selects down once

**`selectAll():`** mimicks a `lctrl + all` action and selects all characters

**`first():`** mimicks a `first` action and moves the cursor to the beginning of the text

**`last():`** mimicks a `last` action and moves the cursor to the end of the text

**`backspace():`** mimicks a `backspace` action and deletes the character before the cursor

**`delete():`** mimicks a `delete` action and deletes the character after the cursor

**`deleteSelected():`** deletes all selected text

**`cut():`** mimicks a `lctrl + cut` action and cuts all selected text

**`copy():`** mimicks a `lctrl + copy` action and copies all selected text

**`paste():`** mimicks a `lctrl + paste` action and pastes all previous cut or copied text

---

**`addText(text):`** adds a string to the textarea

**`setText(text):`** sets textarea's text

**`getText():`** returns textarea's text as a string

**`getIndexLine(index):`** returns the line of an index (i.e. `self.index` for the line of the cursor)

**`getMaxLines():`** returns the number of lines this text has

---

**`saveState():`** returns the current state of the textarea as a table

**`applyState(state):`** applies the state to the textarea

**`undo()`**: undoes the last action

**`redo()`**: redoes the last undone action

---

#### Textarea Tags

The following functions use the idea of tags a lot. So it makes sense to explain this here. This library uses Popo under the hood to draw text. And Popo is a library that gives you the ability to wrap text in tags so that that text can be printed in a certain way. For instance:

```lua
text = Text(10, 10, '[bold text](bold) [italic text](italic)', {
  font = love.graphics.newFont('somefont.ttf')
  bold = love.graphics.newFont('somefont_bold.ttf')
  italic = love.graphics.newFont('somefont_italic.ttf')
})
```

This would create a text object that can be printed and the text wrapped in the `(bold)` tag would use the bold font, the same for italic. The idea is that you can define any function, wrap it around some text and that text will be drawn in the way you defined. Read more about it [here](https://github.com/adonaac/popo). The textarea object uses this internally (the Popo text object is under the `text` attribute).

To add tags to your textarea text, two things have to be done: the Popo settings table has to be defined with the `setTextSettings` function and the `wrap_text_in` attribute has to have the tags to be used in it. So, for instance, if you want all text inputted to be bold, you'd do something like this:

```lua
textarea:setTextSettings({
    font = love.graphics.newFont('somefont.ttf')
    bold = love.graphics.newFont('somefont_bold.ttf')
})

textarea.wrap_text_in = {'bold'}
```

And then, all text added to the textarea will be wrapped in a `bold` tag. The text settings table is used by Popo to refer to what the `bold` tag means (in this case use the bold font) and would draw it accordingly. If you want to stop text being inputted from being bold just set `wrap_text_in` to be empty:

```lua
textarea.wrap_text_in = {}
```

It's worth noting that the `bold`, `italic` and `bold_italic` tags have some special logic going on inside, so if you want to make your text use any of those (or any combination of those), please use those names.

**`getIndexTag(index):`** returns the tag name being applied to the character under index

**`getIndexTagWord(index):`** returns the interval of text, starting from index and expanding to its left and right, that has the same tag as the character under index

**`applyTagToSelectedText(tag):`** applies a tag to the selected text

**`setTextSettings(settings):`** sets the new text settings to be used with Popo

---

## Walkthroughs

The walkthroughs go over the creation of some UI object or behavior using this module. You can read them [here](https://github.com/adonaac/thranduil/blob/master/WALKTHROUGHS.md).

## LICENSE

You can do whatever you want with this. See the [LICENSE](https://github.com/adonaac/thranduil/blob/master/LICENSE).
