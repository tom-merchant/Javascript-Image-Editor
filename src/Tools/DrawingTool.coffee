#pragma once

###
DrawingTool.coffee
Base class for all tools doing raster drawing
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawUtils.coffee"
#include "Icons.coffee"

class global.tools.DrawingTool extends global.tools.Tool
  constructor: (name, icon, description, cursor, layer, editType, @colour, @initFunc, @drawFunc, @lineThickness) ->
    super name, icon, description, cursor, layer, editType

  begin: (startx, starty) ->
    super startx, starty
    @layer = global.getLayer(global.selectedLayer)
    @initFunc(@x, @y, @colour, @layer, list=@history, brushWidth=@lineThickness)
    global.composite()

  update: (newx, newy) ->
    super(newx, newy)

    unless global.isKeyDown("Control")
      @colour = global.fgColour
    else
      @colour = global.bgColour

    unless @active or @dx+@dy is 0
      @initFunc(@x, @y, @colour, @layer, list=[], brushWidth=@brushWidth, draw=false)
      return
    @drawFunc(@x, @y, @dx, @dy, @colour, @layer, list=@history, brushWidth=@lineThickness)
    @x += @dx
    @y += @dy
    @dy = @dx = 0
    global.composite()

  end: ->
  	super()

  setColour: (@colour) ->
    return
