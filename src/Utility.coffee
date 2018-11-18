#include "jdefs.h"

global.arraySum = (arr) ->
  sum = 0
  for v in arr
    sum += v
  return sum

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
  ###
  Coefficients from ITU BT.709
  ###
  return  0.2126 * arr[0] + 0.7152 * arr[1] + 0.0722 * arr[2]

global.copyToCanvas = (cnv, src=global.cnv, scale=1) ->
  ctx = cnv.getContext("2d")
  ctx.save()
  ctx.globalCompositeOperation = "copy"
  ctx.scale scale, scale
  ctx.drawImage src, 0, 0
  ctx.restore()

global.assert = (condition, message) ->
	unless condition
		throw new Error message
