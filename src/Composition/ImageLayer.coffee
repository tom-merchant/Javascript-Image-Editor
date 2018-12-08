#pragma once

###
ImageLayer.coffee Tom Merchant 2018

The layer implementation that is capable of handling images
###

#include <jdefs.h>
#include "../DOM/Layers.coffee"

class ImgLayer extends Layer
  constructor: (image) ->
    super [image.width, image.height], "raster"
    @img = image
    @dataCopied = no

  redraw: ->
    super()
    if @dataCopied
      @ctx.putImageData @raster, 0, 0
    else
      @ctx.clearRect 0, 0, @canvas.width, @canvas.height
      @ctx.drawImage @img, 0, 0, @canvas.width, @canvas.height
      @raster = @ctx.getImageData 0, 0, @canvas.width, @canvas.height
      @dataCopied = yes

global.addUrlLayer = (url) ->
  img = new Image()
  img.src = url

  img.onload = ->
    global.addLayer new ImgLayer img

  img.onerror = ->
    alert "could not load that image"


global.addFileLayer = (e) ->
  global.addUrlLayer e.target.result
