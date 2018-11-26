#pragma once

###
RainbowPen.coffee
Implements a brush tool for drawing thick rainbow lines
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawingTool.coffee"
#include "Icons.coffee"

rainbowPen = new global.tools.DrawingTool("Rainbow Pen",
    global.tools.Icons.RainbowPen.icon,
    "A brush tool for drawing thick rainbow lines",
    global.tools.Icons.RainbowPen.cursor,
    global.getLayer(global.selectedLayer), "raster",
    global.fgColour, drawBlob, drawThickLine,
    global.brushWidth)

rainbowPen.superUpdate = global.tools.Tool.prototype.update.bind(rainbowPen)

rainbowPen.update = ((newx, newy) ->
  @superUpdate newx, newy
  distance = Math.hypot @dx, @dy
  if isNaN distance
    distance = 2
  @colour = [@colour[0] + Math.round((Math.random() - 0.5) * 2 * distance), @colour[1]  + Math.round((Math.random() - 0.5) * 3 * distance), @colour[2] + Math.round((Math.random() - 0.5) * 4 * distance), 255]
  @colour[0] = global.clamp @colour[0], 0, 255
  @colour[1] = global.clamp @colour[1], 0, 255
  @colour[2] = global.clamp @colour[2], 0, 255
  unless @active or @dx+@dy is 0
    @initFunc(@x, @y, @colour, @layer, list=[], brushWidth=@brushWidth, draw=false)
    return
  @drawFunc(@x, @y, @dx, @dy, @colour, @layer, list=@history, brushWidth=@lineThickness)
  @x += @dx
  @y += @dy
  @dy = @dx = 0
  global.composite()
).bind rainbowPen

global.tools.tools.push rainbowPen