#pragma once

drawLine = (x, y, dx, dy, colour, layer, list=[]) ->
  gradient = dy / dx
  if isNaN gradient
  	return list
  if isFinite gradient
  	samplingFactor = Math.ceil(Math.abs(gradient))
  	###If we move in the Y by more than 1 for each X we
  	   need to interpolate the missing pixels by
  	   oversampling###
  	if samplingFactor > 0
  	  for x1 in [0..samplingFactor*dx]
  	    dx1 = x1/samplingFactor
  	    list.push layer.setPixel(Math.round(x + dx1), Math.round(y + dx1*gradient), colour)
  	else
  	  for x1 in [0..dx]
  	    list.push layer.setPixel(x + x1, y, colour)
  else
    for y1 in [0..dy]
      list.push layer.setPixel(x, y + y1, colour)
  return list
