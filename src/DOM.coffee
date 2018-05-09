#include <jdefs.h>
#include "Filters/Filters.coffee"

###
Contains all DOM events
###
global.menuOpen = {}

###
Sets up the menu buttons defined in the document
@param str [String] The name of the menu button
###
addMenu = (str) ->
  global.menuOpen[str] = false
  mnuBtn = document.getElementById "mnu-" + str
  mnuBtns = document.getElementById "mnu-" + str + "-btns"

  mnuBtn.onclick = ->
    unless global.menuOpen[str]
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

btnFilter = document.getElementById "select-filter"
filterModal = document.getElementById "filter-modal"
fltSelect = document.getElementById "filter-select-apply"
fltClose = document.getElementById "filter-select-cancel"
fltType = document.getElementById "filter-type"

blurModal = document.getElementById "filter-blur-modal"
blurCancel = document.getElementById "filter-blur-cancel"
blurApply = document.getElementById "filter-blur-apply"

blurCanvas = document.getElementById "blurCanvas"

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

###
Edit Menu
###

btnFilter.onclick = ->
  filterModal.removeAttribute "hidden"

fltClose.onclick = ->
  filterModal.setAttribute "hidden", true

fltSelect.onclick = ->
  type = document.querySelector("input[name=filter-type]:checked").value
  filterModal.setAttribute "hidden", true
  document.getElementById("filter-" + type + "-modal").removeAttribute "hidden"
  modalCanvas = document.querySelector("#filter-" + type + "-modal canvas")
  modalCanvas.width = global.cnv.width / 2
  modalCanvas.height = global.cnv.height / 2
  global.copyToCanvas blurCanvas, src=global.rendered, scale=0.5

blurCancel.onclick = ->
  blurModal.setAttribute "hidden", true

blurApply.onclick = ->
  applyTo = document.querySelector("input[name=blur-target]:checked").value
  if applyTo is "image"
    ###Add to global.filters###
  else
    ###Add to currentLayer.filters###
  ###push change to global.history###

for element in document.querySelectorAll "input[name=blur-type]"
  element.onclick = (->
    for elem in document.querySelectorAll ".bluroption"
      elem.setAttribute "hidden", true
    document.getElementById(@value + "-options").removeAttribute "hidden"
    ###Apply with default settings###
    global.applyFilter @value + "blur", global.rendered, global.tmp, options=null
    global.copyToCanvas blurCanvas, src=global.tmp, scale=0.5
    ).bind element

window.onclick = (e) ->
  if e.target is openModal
    openModal.setAttribute "hidden", true
  else if e.target is openUrlModal
    openUrlModal.setAttribute "hidden", true
  else if e.target is filterModal
    filterModal.setAttribute "hidden", true

global.addKeyDownHandler (k) ->
  if k is "Enter"
    if !openModal.getAttribute "hidden"
      openOpen.onclick()
    else if !openUrlModal.getAttribute "hidden"
      urlOpen.onclick()
