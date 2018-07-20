###
Tools.coffee
Base class for all tools
Tom Merchant 2018
###

#include <jdefs.h>

class global.tools.Tool
  constructor: (@name, @icon, @description, @cursor, @layer, @editType) ->
    @x = global.canvasMouse.x
    @y = global.canvasMouse.y
    @history = []

  begin: ->
    @x = global.canvasMouse.x
    @y = global.canvasMouse.y
    return

  update: ->
    @dx = @x - global.canvasMouse.x
    @dy = @y - global.canvasMouse.y

  end: ->
    global.history.push {type: @editType, id: @layer.id, data: @history}
    @history = []
    return

global.tools.tools = []
