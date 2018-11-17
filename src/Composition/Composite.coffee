#pragma once
#include "jdefs.h"
#include "../Tools/PixelGrid.coffee"

global.composite = ->
  global.rctx.clearRect(0, 0, global.rendered.width, global.rendered.height)
  global.rctx.save() # Save the untransformed state
  for l in global.layers
    global.rctx.globalCompositeOperation = l.blendMode
    if !l.upToDate
      l.redraw()
    global.rctx.drawImage l.canvas, l.x, l.y
  global.rctx.restore() # Return to the untransformed state
  global.reframe()
  if global.shouldDrawGrid and global.scale >= 12
    global.drawPixelGrid()
