#pragma once
#include <jdefs.h>

global.history.historyFunctionTable =
  raster: (data, redo) ->
    unless redo
      unless data.id is "global"
        layer = global.getLayer data.id
        for i in [data.data.length-1..0]
          layer.commitPixel data.data[i].x, data.data[i].y, [data.data[i].r, data.data[i].g, data.data[i].b, data.data[i].a]
    else
      unless data.id is "global"
        layer = global.getLayer data.id
        for i in [data.data.length-1..0]
          layer.commitPixel data.data[i].x, data.data[i].y, [data.data[i].newr, data.data[i].newg, data.data[i].newb, data.data[i].newa]
    global.composite()
