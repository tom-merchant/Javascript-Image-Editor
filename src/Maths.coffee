#pragma once

###
Maths.coffee Tom Merchant 2018

Some useful Maths methods
###

#include <jdefs.h>

global.clamp = (val, min, max) ->
  if val > max
    return max
  else if val < min
    return min
  else return val

###
Returns the value of the gaussian distribution at a particular point

@param point [Number] The position on the gaussian distribution
@param sigma [Number] The value of one standard deviation
###
global.gauss = (point, sigma) ->
  global.assert(sigma > 0, "Standard deviation cannot be negative")
  return 1/(sigma*Math.sqrt(2*Math.PI)) * Math.exp -Math.pow(point, 2)/(2*sigma)

global.avg = (...x) ->
  sum = 0
  for i in [0...x.length]
    sum += x[i]
  return sum / x.length
