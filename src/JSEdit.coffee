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

global.menuOpen = {}

addMenu = (str) ->
	global.menuOpen[str] = false
	mnuBtn = document.getElementById "mnu-" + str
	mnuBtns = document.getElementById "mnu-" + str + "-btns"

	mnuBtn.onclick = ->
		if not global.menuOpen[str]
			mnuBtns.style.left = global.mouse.x + "px"
			mnuBtns.style.top = global.mouse.y + "px"
			mnuBtns.removeAttribute "hidden"
			global.menuOpen[str] = true
		else
			mnuBtns.setAttribute "hidden", true
			global.menuOpen[str] = false

	window.addEventListener "click", (e) ->
		if e.target isnt mnuBtn and global.menuOpen[str]
			global.menuOpen[str] = false
			mnuBtns.setAttribute "hidden", true

addMenu "file"
addMenu "edit"
addMenu "view"
addMenu "help"

btnOpen = document.getElementById "mnu-file-open"
openModal = document.getElementById "open-file-modal"
openClose = document.getElementById "open-close"
openOpen = document.getElementById "open-open"
fileInput = document.getElementById "file-input"

###
File Menu
###

btnOpen.onclick = ->
	if global.fileMenuOpen
		global.fileMenuOpen = false
		fileMenuButtons.setAttribute "hidden", true
	openModal.removeAttribute "hidden"

openClose.onclick = ->
	openModal.setAttribute "hidden", true

fileMenuOpen = document.getElementById "mnu-file-open"

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

