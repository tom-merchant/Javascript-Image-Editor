#pragma once
#include <jdefs.h>

global.drawPixelGrid = ->
  width = global.cnv.width / global.scale
  height = global.cnv.height / global.scale
  offset = [global.panning[0], global.panning[1]]
  ###
  offset[0]-~~offset[0] gives the bit after the decimal point, ~~ is a quick way of rounding
  1 - x because it's offset by x, if x is 0.7 we want to add 0.3 to make 1, we don't want to add 0.7 to make 1.4
  * global.scale to work out how many pixels that is in real pixels rather than the zoomed in pixels
  ###
  offset[0] = (1 - (offset[0] - ~~offset[0])) * global.scale
  offset[1] = (1 - (offset[1] - ~~offset[1])) * global.scale
  global.ctx.setLineDash [2, 5]
  global.ctx.beginPath()
  for i in [0...width+~~offset[0]]
    global.ctx.moveTo -offset[0] + i*global.scale, 0
    global.ctx.lineTo -offset[0] + i*global.scale, global.cnv.height
  for i in [0...height+~~offset[1]]
    global.ctx.moveTo 0, i*global.scale - offset[1]
    global.ctx.lineTo global.cnv.width, i*global.scale - offset[1]
  global.ctx.stroke()

global.highlightPixel = (x, y, colour) ->
  global.ctx.fillStyle = "rgba(" + colour[0] + "," +colour[1] + "," + colour[2] + "," + colour[3] + ")"
  global.ctx.fillRect (x + global.panning[0]) * global.scale  , (y + global.panning[1]) * global.scale, global.scale, global.scale
