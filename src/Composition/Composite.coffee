#pragma once

###
Composite.coffee Tom Merchant 2018

This file provides 2 methods which are used to combine the data contained in
this applications layers into one traversable canvas area
###

#include "jdefs.h"
#include "PixelGrid.coffee"

global.composite = ->
  global.rctx.clearRect(0, 0, global.rendered.width, global.rendered.height)
  global.rctx.save() # Save the untransformed state
  for l in global.layers
    global.rctx.globalCompositeOperation = l.blendMode
    unless l.upToDate
      l.redraw()
    unless l.hidden
      global.rctx.drawImage l.canvas, l.x, l.y
  global.rctx.restore() # Return to the untransformed state
  global.reframe()

global.reframe = ->
  global.ctx.clearRect(0, 0, global.cnv.width, global.cnv.height)
  global.ctx.save() # Save the untransformed state
  global.ctx.scale(global.scale, global.scale)
  global.ctx.drawImage global.rendered, global.panning[0], global.panning[1]
  global.ctx.restore()
  if global.shouldDrawGrid and global.scale >= 9
    global.drawPixelGrid()