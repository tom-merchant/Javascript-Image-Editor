#include <jdefs.h>

createNamespace(filter)

#include "../../Filters/Common.coffee"
#include "../../Filters/EdgeDetect.coffee"
#include "../../Filters/LineDetect.coffee"

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
  lines = global.filter.detectLines filtered

  lmax = 0
  for l in lines.data
    lmax = Math.max(lmax, l)

  k = 255 / lmax
  for i in [0...lines.length]
    lines.data[i] *= k
    lines.data[i] = Math.round(lines.data[i])

  threshold = findOptimalThreshold lines
  ###Otsu is imperfect for this, I have found 100 works pretty well###
  global.filter.applyThreshold lines.data, lines.width, lines.height, threshold

  global.ctx.beginPath()
  for l in [0...lines.data.length]
    if lines.data[l] > 0
      r = (l % lines.width)
      theta = ~~(l / lines.width) * Math.PI / lines.height

      y1 = (r - 0 * Math.cos(theta)) / Math.sin(theta)
      global.ctx.moveTo 0, y1
      y2 = (r - 512 * Math.cos(theta)) / Math.sin(theta)
      global.ctx.lineTo 512, y2
  global.ctx.stroke()



img.src = "lenna.png"
