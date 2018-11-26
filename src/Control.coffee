#pragma once
#include <jdefs.h>
#include "Maths.coffee"

global.rawScale = 0
global.scale = 1
global.panning = [0, 0]

global.minpan = [0, 0]
global.maxpan = [1, 1]

global.zoom = (dY) ->
  Xm = global.canvasMouse.x
  Xy = global.canvasMouse.y
  mouseImgCoords = global.transformCoordinates Xm, Xy

  global.rawScale -= Math.sign(dY) * global.zoomRate
  global.rawScale = global.clamp(global.rawScale, -2.1, 4.2)
  global.scale = Math.pow(3, global.rawScale)

  mouseImgCoordsNew = global.transformCoordinates Xm, Xy

  global.panning[0] -= mouseImgCoords[0] - mouseImgCoordsNew[0]
  global.panning[1] -= mouseImgCoords[1] - mouseImgCoordsNew[1]

global.pan = (dX, dY) ->
  global.recalcPan()
  ###
  I use the sign of dX and dY so that it will be
  consistent across devices and browsers
  ###
  global.panning[0] += Math.sign(dX) * global.panRate / global.scale
  global.panning[1] -= Math.sign(dY) * global.panRate / global.scale
  global.panning[0] = global.clamp global.panning[0], global.minpan[0], global.maxpan[0]
  global.panning[1] = global.clamp global.panning[1], global.minpan[1], global.maxpan[1]


global.recalcPan = ->
  global.minpan[0] = Math.min(-global.totalWidth + (global.cnv.width / global.scale), 0)
  global.minpan[1] = Math.min(-global.totalHeight + (global.cnv.height / global.scale), 0)
  global.maxpan[0] = 0
  global.maxpan[1] = 0

global.transformCoordinates = (x, y) ->
  return [x/global.scale - global.panning[0], y/global.scale - global.panning[1]]
