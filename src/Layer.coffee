#include "jdefs.h"

global.layers = []

global.layerId = 0

class Layer
  constructor: (dimensions, type) ->
    @canvas = document.createElement 'canvas'

    if dimensions[0] > global.totalWidth
      global.totalWidth = dimensions[0]
    if dimensions[1] > global.totalHeight
      global.totalHeight = dimensions[1]

    global.rendered.width = global.totalWidth
    global.rendered.height = global.totalHeight
    global.tmp.width = global.totalWidth
    global.tmp.height = global.totalHeight

    [@canvas.width, @canvas.height] = dimensions
    @ctx = @canvas.getContext '2d'
    @type = type #Text, raster, shape, etc
    ###
    X and Y are used when compositing the image, not when rendering the layer (ease of implementation)
    ###
    [@x, @y, @rotation] = [0, 0, 0]
    @id = global.layerId++
    @blendMode = "source-over"
    @filters = []
    @upToDate = no
    @raster = global.ctx.createImageData dimensions...

  redraw: ->
    upToDate = yes
    return

  resize: (newDimensions) ->
    @canvas.width = newDimensions.width
    @canvas.height = newDimensions.height
    return

  addFilter: (type, options) ->
    @filters.push
      type: type
      options: options

  ###
  Sets a given pixel to a given colour in this layers overlay raster

  @return [String] The old pixel in string form {x, y, r, g, b, a, newr, newg, newb, newa}
  ###
  setpixel: (x, y, color) ->
    pos = (y * width + x) * 4
    oldData =
      x: x
      y: y
      r: @raster.data[pos]
      g: @raster.data[pos + 1]
      b: @raster.data[pos + 2]
      a: @raster.data[pos + 3]
      newr: color[0]
      newg: color[1]
      newb: color[2]
      newa: color[3]
    @raster.data[pos] = color[0]
    @raster.data[pos + 1] = color[1]
    @raster.data[pos + 2] = color[2]
    @raster.data[pos + 3] = color[3]
    return oldData

  move: (deltas) ->
    @x += deltas.x
    @y += deltas.y

  setAlpha: (newAlpha) ->
    @ctx.globalAlpha = newAlpha

  rotate: (dTheta) ->
    @rotation += dTheta
    @ctx.rotate(dTheta)

  setBlendMode: (@blendMode) ->
    return

class ImgLayer extends Layer
  constructor: (image) ->
    super [image.width, image.height], "raster"
    @img = image

  redraw: ->
    super()
    @ctx.drawImage @img, 0, 0, @canvas.width, @canvas.height

  resize: (newDimensions) ->
    super.resize newDimensions

global.removeLayer = (id) ->
  i = 0
  found = no
  ###
  TODO: determine if layers are always in order already and
  if so possibly use a binary search
  ###
  for layer in global.layers
    if layer.id = id
      found = yes
      break
    i++
  if found
    global.layers.splice i, 1
    global.history.push {type: "delete layer", id: layer.id, position: i, data: JSON.stringify(layer)}
    if global.history.length >= 50
      global.history.shift()
  global.composite()
  layerItem = document.getElementById "layer-" + id
  if layerItem?
    layerItem.parentElement.removeChild layerItem

###
Adds a layer to the layer stack

@param [Layer] the layer to add
###
global.addLayer = (layer) ->
  global.layers.push layer
  global.selectedLayer = 0

  layerList = document.getElementById "layers"
  layerItem = document.createElement "li"
  closeBtn = document.createElement "button"

  closeBtn.id = "close-layer-" + layer.id
  layerItem.id = "layer-" + layer.id
  closeBtn.innerText += "x"
  layerItem.innerText += "Layer " + global.layers.length
  closeBtn.onclick = ->
    global.removeLayer closeBtn.id.replace("close-layer-", "") #For some reason I can''t just use layer.id or wierd issues occur (thanks javascript)
  layerItem.appendChild closeBtn
  layerList.insertBefore layerItem, layerList.firstChild
  layer.redraw()
  global.composite()

global.getLayer = (layerId) ->
  i = 0
  found = no
  ###
  TODO: determine if layers are always in order already and
  if so use a binary search
  ###
  for layer in global.layers
    if layer.id = id
      found = yes
      break
    i++
  return global.layers[i]

global.addUrlLayer = (url) ->
  img = new Image()
  img.src = url

  img.onload = ->
    global.addLayer new ImgLayer img

  img.onerr = ->
    alert "could not load that image"


global.addFileLayer = (e) ->
  global.addUrlLayer e.target.result

global.redrawAll  = ->
  for l in global.Layers
    l.redraw()
  ###
  TODO: composite down on to main canvas (including blending and effects)
  ###
