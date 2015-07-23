# Popo

A character based programmable text module for LÖVE. Simplifies text operations by providing a way for manipulating
how each character in a string behaves and is drawn.

## Usage

The [module](https://github.com/adonaac/popo/blob/master/Text.lua) and the [utf8-l](https://github.com/adonaac/popo/blob/master/utf8-l.lua) files should be dropped on your project and required like so:

```lua
Text = require 'Text'
```

An object is returned and from that you can create multiple text objects.

## Table of Contents

* [Examples](#examples)
  * [Creating a text object](#creating-a-text-object)
  * [Fonts](#fonts)
  * [Functions](#functions)
  * [Multiple functions](#multiple-functions)
  * [Init functions](#init-functions)
  * [Passing values to functions](#passing-parameters-to-functions)
* [Syntax](#syntax)
* [Text](#text)
* [Character](#character)

## Examples

## Creating a text object

Creates a text object and then updates and draws it:

```lua
function love.load()
  text = Text(10, 10, 'Test text')
end

function love.update(dt)
  text:update(dt)
end

function love.draw()
  text:draw()
end
```

## Fonts

When creating a text object, a table can be passed as the second argument (after the text string) to specify settings for this text. One of those settings allows to change the text's font:

```lua
text = Text(10, 10, 'Popo popO', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),
})
```
![popo popo 1](http://i.imgur.com/8viUw9k.png)

You can use multiple fonts by adding a new font to the configuration table like this:

```lua
text = Text(10, 10, '[Popo](bold) [popO](italic)', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),
  bold = love.graphics.newFont('DJB Almost Perfect Bold.ttf', 72),
  italic = love.graphics.newFont('DJB Almost Perfect Italic.ttf', 72),
})
```

## Functions

You can also create functions that will change the text in some way:

```lua
text = Text(10, 10, '[Popo popO](randomColor)', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),
  
  randomColor = function(dt, c)
    love.graphics.setColor(math.random(32, 222), math.random(32, 222), math.random(32, 222))
  end
})
```

And that should do this:

![popo popo 2](http://puu.sh/eIn3T/48ec75ce71.gif)

All functions defined in this way receive two arguments: `dt` and `c`. The first is just the normal `dt` you see in update functions, the second is the [character](#character) table, which contains general information about the current character. For instance, if we want to make the character move randomly based on how big its position is in the text string (meaning characters more to the right will move more):

```lua
text = Text(10, 10, '[Popo popO](move)', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),
  
  move = function(dt, c)
    c.x = c.x + c.position*math.random(-1, 1)/5
    c.y = c.y + c.position*math.random(-1, 1)/5
  end
})
```

![popo popo 3](http://puu.sh/eInMV/32ca7d305a.gif)

## Multiple functions

Multiple functions can operate on a single piece of text and multiple pieces of text be created:

```lua
text = Text(10, 10, '[Popo](move) [popO](move; rotateScale)', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),

  move = function(dt, c)
    c.x = c.x + c.position*math.random(-1, 1)/5
    c.y = c.y + c.position*math.random(-1, 1)/5
  end,

  rotateScale = function(dt, c)
    c.r = math.random(-1, 1)/10
    c.sx = math.random(10, 20)/10
    c.sy = math.random(10, 20)/10
  end
})
```

![popo popo 4](http://puu.sh/eIo1v/a46552b2ad.gif)

## Init functions

Functions act every update and the character table holds information about each character. If you want to set some state that can be updated or used on the update functions you'll need to use `Init` functions. They're just like normal functions except they have `Init` after their name and they only receive the [character](#character) table as an argument. So, for instance:

```lua
text = Text(10, 10, '[Popo popO](shake)', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),
  
  shakeInit = function(c)
    c.anchor_x = c.x
    c.anchor_y = c.y
  end,
  
  shake = function(dt, c)
    c.x = c.anchor_x + c.position*math.random(-1, 1)/2
    c.y = c.anchor_y + c.position*math.random(-1, 1)/2
  end
})
```

![popo popo 5](http://puu.sh/eIqh7/dec38f3150.gif)

In this example the `shakeInit` function gets called as the text object gets created, which means that for every character in the string, the `anchor_x, anchor_y` attributes are set to the character's initial positions. Then, the `shake` function gets called every update and uses those values to shake the characters. In the next example, the `Init` function is used to set some state that will then be changed in the update function:

```lua
text = Text(10, 10, '[Popo popO](textbox)', {
  font = love.graphics.newFont('DJB Almost Perfect.ttf', 72),
  
  textboxInit = function(c)
    c.t = 0
  end,
  
  textbox = function(dt, c)
    c.t = c.t + dt
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, 0)
    if c.t > c.position*0.2 then
      love.graphics.setColor(r, g, b, 255)
    end
  end
})
```

![popo popo 6](http://puu.sh/eIsGD/44c9745d15.gif)

So in this case a textbox effect can be created by setting a time variable for each character and then only drawing that character `(alpha = 255)` if this time is over a certain value based on its string position.

## Passing values to functions

Values can also be passed to functions that are defined to receive them:

```lua
text = Text(10, 10, '[Popo popO](color: 222, 222, 222)', {
  font = love.graphics.setFont('DJB Almost Perfect.ttf', 72),
  
  color = function(dt, c, r, g, b)
    local n_characters = #c.str_text
    local i = n_characters - c.position
    love.graphics.setColor(32 + i*16*r/255, 32 + i*16*g/255, 32 + i*16*b/255)
  end
})
```

![popo popo 7](http://i.imgur.com/rUDEcRa.png)

And changing the parameters to `color: 222, 111, 222`:

![popo popo 8](http://i.imgur.com/zNb0ST2.png)

Currently values that can be passed are `numbers`, `strings` and `booleans`. I haven't gotten around to implementing tables yet.

## Syntax

`[]:` brackets are used to envelop a piece of text so that functions can be applied to it

`():` parenthesis envelop the functions which specify how the text behaves, they must come right after the brackets

`(function):` functions with no arguments simply need their name specified

`(function1; function2):` multiple functions applied to the same brackets are separated by `;`

`(function: arg1, arg2, ..., argn):` multiple arguments are separated by `,` and start after a `:`

`(function1: arg1, arg2; function2: arg1):` multiple functions with arguments just follow the previous definitions

`@:` the `@` character is used to escape special characters in text, for instance:

```lua
text = Text('@[Popo popO@]')
```

Will produce `[Popo popO]`. To escape `@` itself use `@@`. It's also used to break into a new line via `@n`.

## Text

The text object has a few variables that can be specified on its configuration table that might be useful:

`font:` sets the font to be used

`line_height:` the actual line height drawn in pixels is the multiplication of this number by the font height 

`wrap_width:` maximum width in pixels that this text can go, after that it will wrap to the next line

`config:` reference to the configuration table passed on this text object's creation

`str_text:` the text string as it will be printed on the screen

`align_right:` if `wrap_width` is set, will align text to the right if set to `true`

`align_center:` if `wrap_width` is set, will align text to the center if set to `true`

`justify:` if `wrap_width` is set, will align text to be perfectly aligned to both left and right if set to `true`

## Character

Similarly, the character table has a few variables that might be useful:

`x, y:` the x, y position of the character

`r:` this character's rotation, isn't set to anything initially

`sx, sy:` this character's x and y scales, aren't set to anything initially

`character:` the character string

`position:` this character's position in relation to the entire string, starts at `1`

`text:` reference to the text object

`str_text:` the text this character belongs to (a string)

`line:` the line number this character belongs to if the text has more than one line

## LICENSE

You can do whatever you want with this. See the [LICENSE](https://github.com/adonaac/popo/blob/master/LICENSE).
