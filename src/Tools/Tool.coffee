###
Tools.coffee
Base class for all tools
Tom Merchant 2018
###

#include <jdefs.h>

class global.tools.Tool
  constructor: (@name, @icon, @description, @cursor) ->
    @x = global.canvasMouse.x
    @y = global.canvasMouse.y
  
  begin: ->
    @x = global.canvasMouse.x
    @y = global.canvasMouse.y
    return

  update: ->
    @dx = @x - global.canvasMouse.x
    @dy = @y - global.canvasMouse.y
    @x += @dx
    @y += @dy

  end: ->
    return
