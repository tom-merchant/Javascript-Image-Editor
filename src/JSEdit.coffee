#include <jdefs.h>

createNamespace(filter)

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

global.history = []

global.filters = []

global.selectedLayer = 0

global.mouse = new global.Mouse(window.document.body)

global.totalwidth = global.cnv.width
global.totalHeight = global.cnv.height

global.tmp = document.createElement "canvas"
[global.tmp.width, global.tmp.height] = [global.cnv.width, global.cnv.height]

global.mouse.addScrollHandler (e) ->
  if e.ctrlKey
    global.zoom(e.deltaY)
  else if e.altKey
    global.pan(e.deltaY, 0)
  else
    global.pan(e.deltaX, e.deltaY)
  global.composite()
