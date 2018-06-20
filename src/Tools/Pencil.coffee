###
Pencil.coffee
Implements a pencil tool for drawing
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawUtils.coffee"

class global.tools.Pencil extends global.tools.Tool

  constructor: () ->
    super("Pencil", global.tools.getIcon "Pencil", "A pencil tool for drawing", global.tools.getCursor "Pencil", global.layers[global.selectedLayer], "raster")

  begin: ->
    @history.push @layer.setPixel(@x, @y, @colour)
  	super

  update: ->
    super
    @history.push ...drawLine(@x, @y, @dx, @dy, @colour, @layer)
    @x += @dx
    @y += @dy
    @dy = @dx = 0

  end: ->
  	super

  setColour: (@colour) ->
    return
