###
Rubber.coffee
Implements a rubber tool for erasing
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawUtils.coffee"

class global.tools.Rubber extends global.tools.Tool

  constructor: () ->
    super("Rubber", global.tools.getIcon "Rubber", "A Rubber tool for erasing", global.tools.getCursor "Rubber", global.layers[global.selectedLayer], "raster")

  begin: ->
    @history.push @layer.setPixel(@x, @y, [0, 0, 0, 0])
  	super

  update: ->
    super
    @history.push ...drawLine(@x, @y, @dx, @dy, [0, 0, 0, 0], @layer)
    @x += @dx
    @y += @dy
    @dy = @dx = 0

  end: ->
  	super

global.tools.tools.push new global.tools.Rubber
