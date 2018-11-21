#pragma once
#include <jdefs.h>
#include "../DOM/Layers.coffee"

class TextLayer extends Layer
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

    resize: (newDimensions) ->
      super.resize newDimensions
