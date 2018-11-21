#pragma once

###
Rubber.coffee
Implements a rubber tool for erasing pixels
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawingTool.coffee"
#include "Icons.coffee"

eraserTool = new global.tools.DrawingTool("Rubber",
    global.tools.Icons.Rubber.icon,
    "A rubber tool for erasing pixels",
    global.tools.Icons.Rubber.cursor,
    global.getLayer(global.selectedLayer), "raster",
    [0, 0, 0, 0], drawBlob, drawThickLine,
    global.brushWidth)

eraserTool.superUpdate = global.tools.Tool.prototype.update.bind(eraserTool)

eraserTool.update = ((newx, newy) ->
  @superUpdate(newx, newy)

  unless @active or @dx+@dy is 0
    @initFunc(@x, @y, @colour, @layer, list=[], brushWidth=@brushWidth, draw=false)
    return

  @drawFunc(@x, @y, @dx, @dy, @colour, @layer, list=@history, brushWidth=@lineThickness)
  @x += @dx
  @y += @dy
  @dy = @dx = 0
  global.composite()
).bind eraserTool

global.tools.tools.push eraserTool