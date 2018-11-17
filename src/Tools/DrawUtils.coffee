#pragma once

drawPixel = (x, y, colour, layer, list=[], draw=true) ->
	if draw
		list.push layer.setPixel(x, y, colour)
	else
		global.highlightPixel x, y, colour

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

drawBlob = (x, y, colour, layer, list=[], brushWidth=1, draw=true) ->
	###Exit condition###
	if brushWidth <= 0
		return
	r = brushWidth / 2
  ###Draw the circle parametrically###
	if draw
  	for n in [0..~~(Math.PI * brushWidth)+1]
    	t = n / ~~(Math.PI * brushWidth+1)
    	list.push layer.setPixel(x + Math.round(r * Math.cos(2 * Math.PI * t)), y + Math.round(r * Math.sin(2 * Math.PI * t)), colour)
	else
		for n in [0..~~(Math.PI * brushWidth)+1]
			t = n / ~~(Math.PI * brushWidth+1)
			global.highlightPixel x + Math.round(r * Math.cos(2 * Math.PI * t)), y + Math.round(r * Math.sin(2 * Math.PI * t)), colour
	###Draw the next inner layer to fill in the circle###
	drawBlob x, y, colour, layer, list=list, brushWidth=brushWidth - 1, draw=draw
	return list

drawThickLine = (x, y, dx, dy, colour, layer, list=[], brushWidth=1) ->
  gradient = dy / dx
  if isNaN gradient
  	return list
  if isFinite gradient
  	samplingFactor = Math.ceil(Math.abs(2*gradient) / brushWidth)
  	###If we move in the Y by more than half the brudh width for each X we
  	   need to interpolate the missing pixels by
  	   oversampling###
  	if samplingFactor > 0
  	  for x1 in [0..samplingFactor*dx]
  	    dx1 = x1/samplingFactor
  	    drawBlob(Math.round(x + dx1), Math.round(y + dx1*gradient), colour, layer, list=list, brushWidth=brushWidth)
  	else
  	  for x1 in [0..dx]
  	    drawBlob(x + x1, y, colour, layer, list=list, brushWidth=brushWidth)
  else
    for y1 in [0..dy]
      drawBlob(x, y + y1, colour, layer, list=list, brushWidth=brushWidth)
  return list
