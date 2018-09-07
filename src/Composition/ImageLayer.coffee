#pragma once
#include <jdefs.h>

class ImgLayer extends Layer
  constructor: (image) ->
    super [image.width, image.height], "raster"
    @img = image

  redraw: ->
    super()
    ###
    unless ((array) ->
      for n in array
        if isNaN(n)
          return true
      return false)(@outdatedBounds)
      console.log @outdatedBounds...
      [x, y, width, height] = [@outdatedBounds[0], @outdatedBounds[1], @outdatedBounds[2], @outdatedBounds[3]]
      @ctx.clearRect @outdatedBounds...
      @ctx.drawImage @img, x, y, width, height, x, y, width, height
      @ctx2.putImageData @raster, x, y, x, y, width, height
      @ctx.drawImage @canvas2, x, y, width, height, x, y, width, height
      @outdatedBounds = [NaN, NaN, NaN, NaN]
      return true
    else
      return false
    ###
    @ctx.clearRect 0, 0, @canvas.width, @canvas.height
    @ctx.drawImage @img, 0, 0, @canvas.width, @canvas.height
    @ctx2.putImageData @raster, 0, 0
    @ctx.drawImage @canvas2, 0, 0, @canvas.width, @canvas.height

  resize: (newDimensions) ->
    super.resize newDimensions

global.addUrlLayer = (url) ->
  img = new Image()
  img.src = url

  img.onload = ->
    global.addLayer new ImgLayer img

  img.onerr = ->
    alert "could not load that image"


global.addFileLayer = (e) ->
  global.addUrlLayer e.target.result
