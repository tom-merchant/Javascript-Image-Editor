#pragma once

###
Pencil.coffee
Implements a pencil tool for drawing
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawUtils.coffee"
#include "Icons.coffee"

class global.tools.Pencil extends global.tools.Tool
  constructor: ->
    super("Pencil", global.tools.Icons.Pencil.icon, "A pencil tool for drawing", global.tools.Icons.Pencil.cursor, global.getLayer(global.selectedLayer), "raster")
    @colour = [0, 0, 0, 255]

  begin: (startx, starty) ->
    super startx, starty
    @layer = global.getLayer(global.selectedLayer)
    @history.push @layer.setPixel(@x, @y, @colour)
    global.composite()

  update: (newx, newy) ->
    super(newx, newy)
    unless @active or @dx+@dy is 0
      return
    @history.push drawLine(@x, @y, @dx, @dy, @colour, @layer)...
    @x += @dx
    @y += @dy
    @dy = @dx = 0
    global.composite()

  end: ->
  	super()

  setColour: (@colour) ->
    return

global.tools.tools.push new global.tools.Pencil
