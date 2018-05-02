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

global.luminosityAverage = (arr) ->
  return regamma global.average((ungamma x for x in arr))

global.copyToCanvas = (cnv, src=global.cnv, scale=1) ->
  ctx = cnv.getContext("2d")
  ctx.save()
  ctx.scale scale, scale
  ctx.drawImage src, 0, 0
  ctx.restore()

global.assert = (condition, message) ->
	unless condition
		throw new Error message
