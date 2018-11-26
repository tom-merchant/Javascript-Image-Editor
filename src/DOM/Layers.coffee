#pragma once

###
Layers.coffee Tom Merchant 2018

DOM glue for layer specific code
###

#include <jdefs.h>
#include "../History/History.coffee"

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
  linebreak2 = document.createElement "br"
  dropdown  = document.createElement "select"
  blendmodeValues = ["source-over", "source-atop", "source-in", "source-out", "destination-over", "destination-atop", "destination-in",
                     "destination-out", "lighter", "copy", "xor", "multiply", "screen", "overlay", "darken", "lighten", "color-dodge",
                     "color-burn", "hard-light", "soft-light", "difference", "exclusion", "hue", "saturation", "color", "luminosity"]
  moveUp = document.createElement "button"
  moveDown = document.createElement "button"
  moveUp.innerText = "^"
  moveDown.innerText = "v"
  moveUp.onclick = (->
    lastLayer = @elem.previousSibling
    unless lastLayer is null
      swapId = parseInt(lastLayer.id.replace "layer-", "")
      global.swapLayers swapId, @layerobj.id
    ).bind {elem: layerItem, layerobj: layer}

  moveDown.onclick = (->
    nextLayer = @elem.nextSibling
    unless nextLayer is null
      swapId = parseInt(nextLayer.id.replace "layer-", "")
      global.swapLayers @layerobj.id, swapId
    ).bind {elem: layerItem, layerobj: layer}

  for val in blendmodeValues
    optElem = document.createElement "option"
    optElem.value = val
    optElem.innerText = val
    dropdown.appendChild optElem

  dropdown.id = "layer-dropdown-" + layer.id

  hideBtn.type = "checkbox"

  closeBtn.id = "close-layer-" + layer.id
  layerItem.id = "layer-" + layer.id
  closeBtn.innerText += "x"
  layerItem.innerText += "Layer " + global.layers.length
  closeBtn.onclick = (->
    global.removeLayer @id
    ).bind layer
  dropdown.onchange = (->
    global.history.push {type: "layercompositechange", old: @layer.blendMode, new: @elem.value, layerId: @layer.id}
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
    global.history.push {type: "selectlayer", old: global.selectedLayer, new: @layer.id}
    global.selectedLayer = @layer.id
    setActiveLayerDOM @elem
    ).bind {layer: layer, elem: layerItem}
  layerItem.appendChild closeBtn
  layerItem.appendChild hideBtn
  layerItem.appendChild linebreak
  layerItem.appendChild dropdown
  layerItem.appendChild linebreak2
  layerItem.appendChild moveUp
  layerItem.appendChild moveDown
  layerList.insertBefore layerItem, layerList.firstChild
  layer.redraw()
  global.composite()

global.history.historyFunctionTable["layercompositechange"] = (data, redo) ->
  layerDropdownElem = document.getElementById "layer-dropdown-" + data.layerId
  layer = global.getLayer data.layerId
  if redo
    layer.setBlendMode data.new
    layerDropdownElem.value = data.new
  else
    layer.setBlendMode data.old
    layerDropdownElem.value = data.old
  global.composite()

global.history.historyFunctionTable["layerswap"] = (data, redo) ->
  global.swapLayers data.id1, data.id2, commitHistory=false

global.history.historyFunctionTable["selectlayer"] = (data, redo) ->
  if redo
    global.selectedLayer = data.new
    setActiveLayerDOM document.getElementById "layer-" + data.new
  else
    global.selectedLayer = data.old
    setActiveLayerDOM document.getElementById "layer-" + data.old
  global.composite()

global.swapLayers = (id1, id2, commitHistory=true) ->
  layerElem1 = document.getElementById "layer-" + id1
  layerElem2 = document.getElementById "layer-" + id2
  layerListElem = document.getElementById "layers"
  index1 = global.layers.indexOf global.getLayer id1
  index2 = global.layers.indexOf global.getLayer id2
  layer1 = global.layers[index1]
  layer2 = global.layers[index2]
  global.activeLayer = layer2
  global.setActiveLayerDOM = layerElem2
  layer1.id = id2
  layer2.id = id1
  global.layers[index1] = layer2
  global.layers[index2] = layer1
  layerElem2.parentNode.removeChild layerElem2
  layerListElem.insertBefore layerElem2, layerElem1
  layerElem1.id = layerElem1.id.replace id1.toString(), id2.toString()
  layerElem2.id = layerElem2.id.replace id2.toString(), id1.toString()
  closebtn1 = document.getElementById("close-layer-" + id1)
  closebtn2 = document.getElementById("close-layer-" + id2)
  closebtn1.id = closebtn1.id.replace id1.toString(), id2.toString()
  closebtn2.id = closebtn2.id.replace id2.toString(), id1.toString()
  if commitHistory
    global.history.push {type: "layerswap", id1: id1, id2: id2}
  global.composite()

