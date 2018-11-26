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

    textModal = document.getElementById "text-modal"
    textModal.removeAttribute "hidden"
    info = {x: startx, y: starty, textElem: document.getElementById("text-content"), fontElem: document.getElementById("text-font"), color: document.getElementById("text-colour"), size: document.getElementById("text-size"), newCnv: global.getLayer(global.selectedLayer).canvas, modal: textModal}
    createButton = document.getElementById "text-create"
    createButton.onclick = (->
      global.tmp.width = global.totalWidth
      global.tmp.height = global.totalHeight
      ctx = global.tmp.getContext "2d"
      ctx.fillColor = @color.value
      ctx.font = @size.value + "pt " + @fontElem.value + ", Calibri"
      ctx.fillText @textElem.value, 0, 0
      newCtx = @newCnv.getContext "2d"
      newCtx.drawImage global.tmp, @x, @y
      @modal.setAttribute "hidden", yes
      global.composite()
      ).bind info

  end: ->
  	super()

  setColour: (@colour) ->
    return

global.tools.tools.push new global.tools.TextTool