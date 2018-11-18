#include <jdefs.h>

createNamespace(filter)

#include "../../Filters/Common.coffee"
#include "../../Filters/EdgeDetect.coffee"

cnv = document.getElementById("cnv")
global.ctx = cnv.getContext("2d")

global.gamma = 2.2
global.dpi = 96

img = document.createElement("img")
img.crossOrigin = "Anonymous";

img.onload = ->
  global.ctx.drawImage img, 0, 0
  data = global.ctx.getImageData(0, 0, 512, 512)
  filtered = (global.filter.edgeDetect data)[0]
  global.filter.expandSingleChannel filtered, data
  global.ctx.putImageData data, 0, 0


img.src = "lenna.png"
