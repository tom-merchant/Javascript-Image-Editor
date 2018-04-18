#include <jdefs.h>
#include "Maths.coffee"

global.scale = 1
global.panning = [0, 0]

global.zoom = (dY) ->
  global.scale += dY * global.zoomRate
  global.scale = global.clamp(global.scale, 0.1, 3)

global.pan = (dX, dY) ->
  global.panning[0] += dX * global.panRate
  global.panning[1] += dY * global.panRate
  global.panning[0] = global.clamp global.panning[0], 0, global.totalwidth
  global.panning[1] = global.clamp global.panning[1], 0, global.totalHeight
