#pragma once

###
Layer.coffee Tom Merchant 2018

This file defines the base class for Layers
all concrete Layers must extend this or provide
the same methods
###

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
    @raster = global.ctx.createImageData dimensions...

  redraw: ->
    upToDate = yes
    return

  resize: (newDimensions) ->
    @canvas.width = newDimensions.width
    @canvas.height = newDimensions.height
    return

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

global.getLayer = (layerId) ->
  found = no
  for layer in global.layers
    if layer.id is layerId
      return layer
  return undefined
