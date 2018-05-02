#include "jdefs.h"

global.average = (arr) ->
  sum = 0
  for v in arr
    sum += v
  return sum / arr.length

global.ungamma = (x) ->
  return Math.pow(x, global.gamma)

global.regamma = (x) ->
  return Math.pow(x, 1/global.gamma)

###
Calculates the percieved luminosity for a set of RGB values, useful for grayscale effect
###
global.luminosityAverage = (arr) ->
  raw = (global.ungamma x for x in arr)
  ###
  Coefficients from ITU BT.709
  ###
  return ~~global.regamma 0.2126 * raw[0] + 0.7152 * raw[1] + 0.0722 * raw[2]


global.copyToCanvas = (cnv, src=global.cnv, scale=1) ->
  ctx = cnv.getContext("2d")
  ctx.save()
  ctx.scale scale, scale
  ctx.drawImage src, 0, 0
  ctx.restore()

global.assert = (condition, message) ->
	unless condition
		throw new Error message
