#pragma once
#include <jdefs.h>
#include "Maths.coffee"

global.scale = 1
global.panning = [0, 0]

global.minpan = [0, 0]
global.maxpan = [1, 1]

global.zoom = (dY) ->
  global.scale += dY * global.zoomRate
  global.scale = global.clamp(global.scale, 0.1, 100)

global.pan = (dX, dY) ->
  global.recalcPan()
  global.panning[0] += dX * global.panRate / global.scale
  global.panning[1] += dY * global.panRate / global.scale
  global.panning[0] = global.clamp global.panning[0], global.minpan[0], global.maxpan[0]
  global.panning[1] = global.clamp global.panning[1], global.minpan[1], global.maxpan[1]


global.recalcPan = ->
  global.minpan[0] = -global.totalWidth
  global.minpan[1] = -global.totalHeight
  global.maxpan[0] = 0
  global.maxpan[1] = 0

global.reframe = ->
  global.ctx.clearRect(0, 0, global.cnv.width, global.cnv.height)
  global.ctx.save() # Save the untransformed state
  global.ctx.scale(global.scale, global.scale)
  global.ctx.drawImage global.rendered, global.panning[0], global.panning[1]
  global.ctx.restore()

global.transformCoordinates = (x, y) ->
  return [~~(x * 1/global.scale - global.panning[0]), ~~(y * 1/global.scale - global.panning[1])]
