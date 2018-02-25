#include <jdefs.h>

createNamespace(_)

#include "Mouse.coffee"
#include "Keyboard.coffee"
#include "Layer.coffee"

cnv = document.getElementById "cnv"
ctx = cnv.getContext "2d"

global.layers = []
global.selectedLayer = 0

global.mouse = new global.Mouse(window.document.body)

global.addLayer = (layer) ->
	global.layers.unshift layer
	global.selectedLayer = 0

	layerList = document.getElementById "layers"
	layerItem = document.createElement "li"
	closeBtn = document.createElement "button"

	closeBtn.id = "" + layer.id
	closeBtn.innerText += "x"
	layerItem.innerText += "Layer " + global.layers.length
	layerItem.appendChild closeBtn
	layerList.insertBefore layerItem, layerList.firstChild

global.addFileLayer = (e) ->
	img = new Image()
	img.src = e.target.result
	global.addLayer new ImgLayer img



###
 DOM events
###

global.fileMenuOpen = false

btnOpen = document.getElementById "mnu-file-open"
openModal = document.getElementById "open-file-modal"
openClose = document.getElementById "open-close"
openOpen = document.getElementById "open-open"
fileInput = document.getElementById "file-input"

btnOpen.onclick = ->
	if global.fileMenuOpen
		global.fileMenuOpen = false
		fileMenuButtons.setAttribute "hidden", true
	openModal.removeAttribute "hidden"

openClose.onclick = ->
	openModal.setAttribute "hidden", true

fileMenu = document.getElementById "mnu-file"
fileMenuOpen = document.getElementById "mnu-file-open"
fileMenuButtons = document.getElementById "mnu-file-btns"

fileMenu.onclick = ->
	if not global.fileMenuOpen
		fileMenuButtons.style.left = global.mouse.x + "px"
		fileMenuButtons.style.top = global.mouse.y + "px"
		fileMenuButtons.removeAttribute "hidden"
		global.fileMenuOpen = true
	else
		fileMenuButtons.setAttribute "hidden", true
		global.fileMenuOpen = false

openOpen.onclick = ->
	if fileInput.files.length > 0
		file = fileInput.files[0]
		reader = new FileReader()
		reader.onload = global.addFileLayer
		reader.readAsDataURL file
		fileInput.value = null
		openModal.setAttribute("hidden", true)

window.onclick = (e) ->
	if e.target is openModal
		openModal.setAttribute "hidden", true
	if e.target isnt fileMenu and global.fileMenuOpen
		global.fileMenuOpen = false
		fileMenuButtons.setAttribute "hidden", true
