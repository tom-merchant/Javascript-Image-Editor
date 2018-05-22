#include <jdefs.h>

createNamespace(filter)
createNamespace(tools)

#include "Props.coffee"
#include "Control.coffee"
#include "Utility.coffee"
#include "Composite.coffee"
#include "Mouse.coffee"
#include "Keyboard.coffee"
#include "Layer.coffee"
#include "DOM.coffee"

global.cnv = document.getElementById "cnv"
global.ctx = global.cnv.getContext "2d"
global.ctx.imageSmoothingEnabled = no

###
TODO: global offscreen canvas to render the entire image to when compositing,
then grab the image to display from that, that should be the data used when
previewing blurs etc
###

global.rendered = document.createElement "canvas"
global.rctx = global.rendered.getContext "2d"
global.rctx.imageSmoothingEnabled = no
global.rendered.width = 1
global.rendered.height = 1

unless global.ctx?
  alert("Browser not supported!")

global.history = []

global.filters = []

global.selectedLayer = 0

global.mouse = new global.Mouse window.document.body

global.canvasMouse = new global.Mouse global.cnv

global.totalWidth = global.rendered.width
global.totalHeight = global.rendered.height

global.tmp = document.createElement "canvas"
[global.tmp.width, global.tmp.height] = [global.rendered.width, global.rendered.height]

global.mouse.addScrollHandler (e) ->
  if e.ctrlKey
    global.zoom(e.deltaY)
  else if e.altKey
    global.pan(e.deltaY, 0)
  else
    global.pan(e.deltaX, e.deltaY)
  global.reframe()
