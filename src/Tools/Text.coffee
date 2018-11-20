#pragma once

###
TextTool.coffee
Class for the tool which edits text
Tom Merchant 2018
###

#include <jdefs.h>
#include "Icons.coffee"

class global.tools.TextTool extends global.tools.Tool
  constructor: () ->
    super "Text", global.tools.Icons.Text.icon, "Allows for selecting and editing of text", global.tools.Icons.Text.cursor, global.getLayer(global.selectedLayer), "text"

  begin: (startx, starty) ->
    super(startx, starty)
    ###
    TODO: Begin editing text under cursor
    ###
    global.composite()

  update: (newx, newy) ->
    super(newx, newy)
    ###
    TODO: Selecting text, implement keyboard handler
    ###
    global.composite()

  end: ->
  	super()

  setColour: (@colour) ->
    return

global.tools.tools.push new global.tools.TextTool