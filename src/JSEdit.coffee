#include <jdefs.h>

createNamespace(filter)
createNamespace(tools)

#include "Keyboard.coffee"
#include "History/History.coffee"
#include "Props.coffee"
#include "Control.coffee"
#include "Utility.coffee"
#include "Composition/Composite.coffee"
#include "Mouse.coffee"
#include "Composition/Layer.coffee"
#include "Composition/ImageLayer.coffee"
#include "Filters/Filters.coffee"
#include "Tools/Tool.coffee"
#include "Tools/Pointer.coffee"
#include "Tools/Pencil.coffee"
#include "Tools/Brush.coffee"
#include "Tools/Rubber.coffee"

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

global.filters = []

global.selectedLayer = 0

global.activeTool = null

global.mouse = new global.Mouse window.document.body

global.canvasMouse = new global.Mouse global.cnv

global.totalWidth = global.rendered.width
global.totalHeight = global.rendered.height

global.tmp = document.createElement "canvas"
[global.tmp.width, global.tmp.height] = [global.rendered.width, global.rendered.height]

###
Handle events pertaining to moving the viewport and zooming
###

global.mouse.addScrollHandler (e) ->
  if e.ctrlKey
    global.zoom(e.deltaY)
  else if e.altKey
    global.pan(e.deltaY, 0)
  else
    global.pan(e.deltaX, e.deltaY)
  global.reframe()
  if global.shouldDrawGrid and global.scale >= 9
    global.drawPixelGrid()

###
Handle mouse events pertaining to tool usage
###

global.canvasMouse.addButtonPressHandler (e, btn) ->
	if btn is 0 and global.activeTool?
		global.activeTool.begin(global.transformCoordinates(global.canvasMouse.x, global.canvasMouse.y)...)

global.canvasMouse.addMoveHandler ->
	if global.activeTool?
		global.activeTool.update(global.transformCoordinates(global.canvasMouse.x, global.canvasMouse.y)...)

global.canvasMouse.addButtonReleaseHandler (e, btn) ->
	if btn is 0 and global.activeTool?
		global.activeTool.end()

#include "DOM.coffee"
