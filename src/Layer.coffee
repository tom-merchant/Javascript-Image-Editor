
global.layerId = 0

class Layer
	constructor: (dimensions, type) ->
		@canvas = document.createElement 'canvas'
		[@canvas.width, @canvas.height] = dimensions
		@ctx = @canvas.getContext '2d'
		@type = type #Text, raster, shape, etc
		[@x, @y] = [0, 0]
		@id = global.layerId++

	redraw: ->


class ImgLayer extends Layer
	constructor: (image) ->
		super [image.width, image.height], "raster"

	redraw: ->
		super.redraw()
