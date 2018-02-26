#include "jdefs.h"

global.layers = []

global.layerId = 0

class Layer
	constructor: (dimensions, type) ->
		@canvas = document.createElement 'canvas'
		[@canvas.width, @canvas.height] = dimensions
		@ctx = @canvas.getContext '2d'
		@type = type #Text, raster, shape, etc
		###
		X, Y and rotation are used when compositing the image, not when rendering the layer (ease of implementation)
		###
		[@x, @y, @rotation] = [0, 0, 0]
		@id = global.layerId++

	redraw: ->
		return

	resize: (newDimensions) ->
		@canvas.width = newDimensions.width
		@canvas.height = newDimensions.height
		return

	###
	Serializes this layer to a string

	@return [String] the serialized representation of this layer
	###
	serialize: () ->
		return @canvas.toDataURL()

	move: (deltas) ->
		@x += deltas.x
		@y += deltas.y

class ImgLayer extends Layer
	constructor: (image) ->
		super [image.width, image.height], "raster"
		@img = image

	redraw: ->
		super.redraw()
		@ctx.drawImage @img, 0, 0, @canvas.width, @canvas.height

	resize: (newDimensions) ->
		super.resize(newDimensions)

global.removeLayer = (id) ->
	i = 0
	found = false
	for layer in global.layers
		if layer.id = id
			found = true
			break
		i++
	if found
		global.layers.splice i, 1
		global.history.push {type: "layer", id: layer.id, position: i, data: layer.serialize()}
		if global.history.length >= 50
			global.history.pop()
	###
	TODO: Force redraw
	###
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
		global.removeLayer layer.id
	layerItem.appendChild closeBtn
	layerList.insertBefore layerItem, layerList.firstChild

global.addUrlLayer = (url) ->
	img = new Image()
	img.src = url
	global.addLayer new ImgLayer img

global.addFileLayer = (e) ->
	global.addUrlLayer e.target.result

global.redrawAll  = ->
	for l in global.Layers
		l.redraw()
	###
	TODO: composite down on to main canvas (including blending and effects)
	###
