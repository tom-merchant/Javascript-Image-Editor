###
Pointer.coffee
Tom Merchant 2018
###

#include <jdefs.h>
#include "Icons.coffee"

class global.tools.Pointer extends global.tools.Tool
  constructor: () ->
    super("Pointer", global.tools.Icons.Pointer.icon, "Default mouse behaviour, selecting and moving pixels", global.tools.Icons.Pointer.cursor, global.getLayer(global.selectedLayer), "")
    @selecting = no
    @moving = no
    @selection = [0, 0, 0, 0]
    @updates = 0

  begin: (startx, starty) =>
    super startx, starty
    @layer = global.getLayer(global.selectedLayer)
    if @selecting
      @selecting = no
      @moving = yes
    else
      @selecting = yes
    return

  update: (newx, newy) =>
    super newx, newy
    @updates += 1

  end: ->
    super()
    @selecting = no
    @moving = no
    if @updates is 0 and @selection.reduce((->
       return a + Math.abs b), 0) isnt 0
      return
      ###
      TODO: Finalise move and place pixels down onto layer
      ###
    @updates = 0

global.tools.tools.push new global.tools.Pointer
