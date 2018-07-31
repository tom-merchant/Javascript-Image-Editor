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

  constructor: () ->
    super("Pencil", global.tools.Icons.Pencil.icon, "A pencil tool for drawing", global.tools.Icons.Pencil.cursor, global.layers[global.selectedLayer], "raster")

  begin: ->
  	super
  	@history.push @layer.setPixel(@x, @y, @colour)

  update: ->
    super
    @history.push drawLine(@x, @y, @dx, @dy, @colour, @layer)...
    @x += @dx
    @y += @dy
    @dy = @dx = 0

  end: ->
  	super

  setColour: (@colour) ->
    return

global.tools.tools.push new global.tools.Pencil
