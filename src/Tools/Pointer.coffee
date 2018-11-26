#pragma once

###
Pointer.coffee
Tom Merchant 2018
###

#include <jdefs.h>
#include "Icons.coffee"
#include "Tool.coffee"

class global.tools.Pointer extends global.tools.Tool
  constructor: () ->
    super("Pointer", global.tools.Icons.Pointer.icon, "Default mouse behaviour, selecting and moving pixels", global.tools.Icons.Pointer.cursor, global.getLayer(global.selectedLayer), "")
    @selecting = no
    @moving = no
    @selection = [0, 0, 0, 0]
    @updates = 0
    @layerOffset = [0, 0]
    @moved = [0, 0]
    @layerOrigin = [0, 0]

  begin: (startx, starty) =>
    super startx, starty
    @layer = global.getLayer(global.selectedLayer)
    if @selecting
      @selecting = no
      @moving = yes
      @layerOffset = [startx - @layer.x, starty - @layer.y]
      @layerOrigin = [@layer.x, @layer.y]
    else if global.isKeyDown "Control"
      @selecting = yes
    else
      @moving = yes
      @layerOffset = [startx - @layer.x, starty - @layer.y]
      @layerOrigin = [@layer.x, @layer.y]
    return

  update: (newx, newy) =>
    super newx, newy
    if @moving
      oldx = @layer.x
      oldy = @layer.y
      @layer.x = newx - @layerOffset[0]
      @layer.y = newy - @layerOffset[1]
      @moved = [@layer.x - @layerOrigin[0], @layer.y - @layerOrigin[1]]
    @updates += 1
    global.composite()

  end: ->
    @active = no
    @selecting = no
    @moving = no
    if @moved[0] or @moved[1]
      global.history.push {type: "move", layerId: @layer.id, oldPos: @layerOrigin, newPos: [@layer.x, @layer.y]}
    if @updates is 0 and @selection.reduce((->
       return a + Math.abs b), 0) isnt 0
      return
      ###
      TODO: Finalise move and place pixels down onto layer
      ###
    @updates = 0

global.history.historyFunctionTable["move"] = (data, redo) ->
  layer = global.getLayer data.layerId
  unless redo
    layer.x = data.oldPos[0]
    layer.y = data.oldPos[1]
    global.composite()
  else
    layer.x = data.newPos[0]
    layer.y = data.newPos[1]
    global.composite()

thepointer = new global.tools.Pointer

global.tools.tools.push thepointer

global.activeTool= thepointer
