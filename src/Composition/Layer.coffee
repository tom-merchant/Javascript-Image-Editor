#pragma once
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
    @x = @y = @rotation = 0
    @id = global.layerId++
    @blendMode = "source-over"
    @filters = []
    @hidden = false
    @upToDate = no
    @outdatedBounds = [0, 0, @canvas.width, @canvas.height]
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
  Like setPixel but for undoing so the change isnt recorded in history
  and processing power is not wasted
  ###
  commitPixel: (x, y, color) ->
    pos = (y * @canvas.width + x) * 4

    if x > @raster.width or x < 0 or y > @raster.height or y < 0
      ###
      Prevents edge wrapping which is the default behaviour
      for ImageData arrays.
      FIXME: Do this check in @setPixel and return a value such that it doesnt get comitted to history
      ###
      return

    @raster.data[pos] = color[0]
    @raster.data[pos + 1] = color[1]
    @raster.data[pos + 2] = color[2]
    @raster.data[pos + 3] = color[3]
    @upToDate = no

  ###
  Sets a given pixel to a given colour in this layers overlay raster

  @return [Object] The old pixel in object form {x, y, r, g, b, a, newr, newg, newb, newa}
  ###
  setPixel: (x, y, color) ->
    pos = ((y-@y) * @canvas.width + (x-@x)) * 4
    oldData =
      x: x-@x
      y: y-@y
      r: @raster.data[pos]
      g: @raster.data[pos + 1]
      b: @raster.data[pos + 2]
      a: @raster.data[pos + 3]
      newr: color[0]
      newg: color[1]
      newb: color[2]
      newa: color[3]
    if oldData.r is oldData.newr and oldData.g is oldData.newg and oldData.b = oldData.newb and oldData.a is oldData.newa
      return null
    @commitPixel x-@x, y-@y, color
    ###
    oldx = 0
    oldy = 0
    if isNaN @outdatedBounds[0]
      @outdatedBounds[0] = x
    else
      oldx = @outdatedBounds[0]
      @outdatedBounds[0] = Math.min x, @outdatedBounds[0]
    if isNaN @outdatedBounds[1]
      @outdatedBounds[1] = y
    else
      oldy = @outdatedBounds[1]
      @outdatedBounds[1] = Math.min y, @outdatedBounds[1]
    if isNaN @outdatedBounds[2]
      @outdatedBounds[2] = 1
    else if x <= oldx
      @outdatedBounds[2] += oldx - x
    else if x >= (oldx + @outdatedBounds[2])
      @outdatedBounds[2] += x - (oldx + @outdatedBounds[2])
    if isNaN @outdatedBounds[3]
      @outdatedBounds[3] = 1
    else if y <= oldy
      @outdatedBounds[3] += oldy - y
    else if y >= (oldy + @outdatedBounds[3])
      @outdatedBounds[3] += y - (oldy + @outdatedBounds[3])
    ###
    return oldData

  move: (deltas) ->
    @x += deltas.x
    @y += deltas.y
    @upToDate = no

  setAlpha: (newAlpha) ->
    @ctx.globalAlpha = newAlpha

  rotate: (dTheta) ->
    @rotation += dTheta
    @ctx.rotate(dTheta)

  setBlendMode: (@blendMode) ->
    @upToDate = no
    return

  toggleVisibility: ->
    @hidden = not @hidden
    @upToDate = no
    return

global.removeLayer = (id) ->
  i = 0
  found = no
  ###
  TODO: determine if layers are always in order already and
  if so possibly use a binary search
  ###
  for layer in global.layers
    if layer.id == id
      found = yes
      break
    i++
  if found
    layer = global.layers.splice i, 1
    global.history.push {type: "delete layer", id: layer.id, position: i, data: JSON.stringify(layer)}
  global.composite()
  layerItem = document.getElementById "layer-" + id
  if layerItem?
    layerItem.parentElement.removeChild layerItem

global.getLayer = (layerId) ->
  found = no
  for layer in global.layers
    if layer.id is layerId
      return layer
  return undefined
