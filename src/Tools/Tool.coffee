#pragma once

###
Tools.coffee
Base class for all tools
Tom Merchant 2018
###

#include <jdefs.h>

class global.tools.Tool
  constructor: (@name, @icon, @description, @cursor, @layer, @editType) ->
    @x = 0
    @y = 0
    @history = []
    @active = no

  begin: (startx, starty) =>
    if @active
      @end()
    @active = yes
    @x = startx
    @y = starty
    return

  update: (newx, newy) =>
    unless @active
      return
    @dx = newx - @x
    @dy = newy - @y

  end: =>
    @active = no
    if @layer?
      global.history.push {type: @editType, id: @layer.id, data: JSON.parse JSON.stringify @history}
    @history = []
    return

global.tools.tools = []
