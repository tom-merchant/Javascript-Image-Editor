#pragma once

drawLine = (x, y, dx, dy, colour, layer, list=[]) ->
  gradient = @dy / @dx
  history = ""
  for x in [0..@dx]
    list.push layer.setPixel(@x + x, Math.round(@y + x * gradient), @colour)
  return list
