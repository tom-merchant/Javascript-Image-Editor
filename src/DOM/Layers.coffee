
layerList = document.getElementById "layers"

###
Applies the selected attribute to the layer
so the css highlights it
###
setActiveLayerDOM = (elem) ->
  for l in global.layers
    document.getElementById("layer-" + l.id).removeAttribute "selected"
  elem.setAttribute "selected", true

###
Adds a layer to the layer stack

@param [Layer] the layer to add
###
global.addLayer = (layer) ->
  global.layers.push layer
  global.selectedLayer = layer.id

  layerItem = document.createElement "li"
  closeBtn  = document.createElement "button"
  hideBtn   = document.createElement "input"
  linebreak = document.createElement "br"
  dropdown  = document.createElement "select"
  blendmodeValues = ["source-over", "source-atop", "source-in", "source-out", "destination-over", "destination-atop", "destination-in",
                     "destination-out", "lighter", "copy", "xor", "multiply", "screen", "overlay", "darken", "lighten", "color-dodge",
                     "color-burn", "hard-light", "soft-light", "difference", "exclusion", "hue", "saturation", "color", "luminosity"]

  for val in blendmodeValues
    optElem = document.createElement "option"
    optElem.value = val
    optElem.innerText = val
    dropdown.appendChild optElem

  dropdown.id = "layer-" + layer.id + "-blendmode"

  hideBtn.id = "hide-layer-" + layer.id
  hideBtn.type = "checkbox"

  closeBtn.id = "close-layer-" + layer.id
  layerItem.id = "layer-" + layer.id
  closeBtn.innerText += "x"
  layerItem.innerText += "Layer " + global.layers.length
  closeBtn.onclick = (->
    global.removeLayer @id
    ).bind layer
  dropdown.onchange = (->
    @layer.setBlendMode(@elem.value)
    global.composite()
    global.reframe()
    ).bind {layer: layer, elem: dropdown}
  hideBtn.onchange = (->
    @toggleVisibility()
    global.composite()
    global.reframe()
    ).bind layer
  layerItem.onclick = (->
    global.selectedLayer = @layer.id
    setActiveLayerDOM @elem
    ).bind {layer: layer, elem: layerItem}
  layerItem.appendChild closeBtn
  layerItem.appendChild hideBtn
  layerItem.appendChild linebreak
  layerItem.appendChild dropdown
  layerList.insertBefore layerItem, layerList.firstChild
  layer.redraw()
  global.composite()