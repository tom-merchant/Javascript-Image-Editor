#pragma once

###
TextTool.coffee
Class for the tool which edits text
Tom Merchant 2018
###

#include <jdefs.h>
#include "Icons.coffee"
#include "../Composition/Layer.coffee"
#include "../Composition/ImageLayer.coffee"
#include "../DOM/Layers.coffee"

class global.tools.TextTool extends global.tools.Tool
	constructor: () ->
		super "Text", global.tools.Icons.Text.icon, "Allows for selecting and editing of text", global.tools.Icons.Text.cursor, global.getLayer(global.selectedLayer), "text"

	begin: (startx, starty) ->
		super(startx, starty)
		textModal = document.getElementById "text-modal"
		textModal.removeAttribute "hidden"
		info = {x: startx, y: starty, textElem: document.getElementById("text-content"), fontElem: document.getElementById("text-font"), colour: document.getElementById("text-colour"), size: document.getElementById("text-size"), layer: global.getLayer(global.selectedLayer), modal: textModal}
		createButton = document.getElementById "text-create"
		createButton.onclick = (->
			###
			TODO: Calculate the dimensions the text will need to be because this will be too big
			###
			txtLayer = new Layer([global.totalWidth, global.totalHeight], "raster")
			txtLayer.move {x: @x, y: @y}

			txtLayer.ctx.textBaseline = "top"
			txtLayer.ctx.fillStyle = @colour.value
			txtLayer.ctx.font = @size.value + "pt " + @fontElem.value + ", sans-serif"
			txtLayer.ctx.fillText @textElem.value, 0, 0

			txtLayer.raster = txtLayer.ctx.getImageData 0, 0, global.totalWidth, global.totalHeight

			txtLayer.redraw = ImgLayer.prototype.redraw.bind(txtLayer)
			txtLayer.dataCopied = yes

			global.addLayer txtLayer

			@modal.setAttribute "hidden", yes
			global.composite()
			).bind info

global.tools.tools.push new global.tools.TextTool