#include "jdefs.h"

###
Contains all DOM events
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

btnOpenUrl = document.getElementById "mnu-url-open"
openUrlModal = document.getElementById "open-url-modal"
urlOpen = document.getElementById "open-url-open"
urlClose = document.getElementById "open-url-close"
urlInput = document.getElementById "url-input"

###
File Menu
###

btnOpen.onclick = ->
	openModal.removeAttribute "hidden"

urlOpen.onclick = ->
	if urlInput.value.length > 0
		url = urlInput.value
		urlInput.value = null
		global.addUrlLayer url
		openUrlModal.setAttribute "hidden", true

urlClose.onclick = ->
	openUrlModal.setAttribute "hidden", true

btnOpenUrl.onclick = ->
	openUrlModal.removeAttribute "hidden"

openClose.onclick = ->
	openModal.setAttribute "hidden", true

openOpen.onclick = ->
	if fileInput.files.length > 0
		file = fileInput.files[0]
		reader = new FileReader()
		reader.onload = global.addFileLayer
		reader.readAsDataURL file
		fileInput.value = null
		openModal.setAttribute "hidden", true

window.onclick = (e) ->
	if e.target is openModal
		openModal.setAttribute "hidden", true
	else if e.target is openUrlModal
	  openUrlModal.setAttribute "hidden", true

global.addKeyDownHandler (k) ->
  if k is "Enter"
    if !openModal.getAttribute "hidden"
      openOpen.onclick()
    else if !openUrlModal.getAttribute "hidden"
      urlOpen.onclick()
