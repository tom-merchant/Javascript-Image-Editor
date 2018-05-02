#include <jdefs.h>

createNamespace(filter)

#include "../Filters/Common.coffee"

cnv = document.getElementById("cnv")
global.ctx = cnv.getContext("2d")

global.gamma = 1.8

img = document.createElement("img")

img.onload = ->
    global.ctx.drawImage img, 0, 0
    gkernel = global.filter.buildKernel "gaussian", 4
    data = global.ctx.getImageData(0, 0, 1000, 1000)
    filtered = global.filter.applyKernel gkernel, data
    console.log filtered
    global.ctx.putImageData filtered, 0, 0

img.src = "slowloris.jpg"
