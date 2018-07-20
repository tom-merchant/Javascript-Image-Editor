#include <jdefs.h>

createNamespace(filter)

#include "../../Filters/Common.coffee"

cnv = document.getElementById("cnv")
global.ctx = cnv.getContext("2d")

global.gamma = 2.2
global.dpi = 96

img = document.createElement("img")

img.onload = ->
    global.ctx.drawImage img, 0, 0
    filter = global.filter.createIIR 20
    data = global.ctx.getImageData(0, 0, 1000, 1000)
    filtered = global.filter.applyFilter filter, data
    console.log filtered
    global.ctx.putImageData filtered, 0, 0

img.src = "slowloris.jpg"
