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

sharpenModal = document.getElementById "filter-sharpen-modal"
sharpenCancel = document.getElementById "filter-sharpen-cancel"
sharpenApply = document.getElementById "filter-sharpen-apply"

gaussianRadius = document.getElementById "gaussian-blur-radius"
lowpassRadius = document.getElementById "lowpass-blur-radius"

unsharpRadius = document.getElementById "unsharp-sharpen-radius"
biquadRadius = document.getElementById "biquad-sharpen-radius"

blurCanvas = document.getElementById "blurCanvas"

sharpenCanvas = document.getElementById "sharpenCanvas"

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
  switch type
    when "blur"
      blurtype = document.querySelector("input[name=blur-type]:checked").value
      document.getElementById(blurtype + "-options").removeAttribute "hidden"
      global.applyFilter blurtype + "blur", global.rendered, global.tmp, options={radius: document.getElementById(blurtype + "-blur-radius").value}
      break
    when "sharpen"
      sharpentype = document.querySelector("input[name=sharpen-type]:checked").value
      document.getElementById(sharpentype + "-options").removeAttribute "hidden"
      global.applyFilter sharpentype + "sharpen", global.rendered, global.tmp, options={radius: document.getElementById(sharpentype + "-sharpen-radius").value}
      break
  global.copyToCanvas modalCanvas, src=global.tmp, scale=0.5

blurCancel.onclick = ->
  blurModal.setAttribute "hidden", true

sharpenCancel.onclick = ->
  sharpenModal.setAttribute "hidden", true

blurApply.onclick = ->
  applyTo = document.querySelector("input[name=blur-target]:checked").value
  if applyTo is "image"
    ###Add to global.filters###
  else
    ###Add to currentLayer.filters###
  ###push change to global.history###

sharpenApply.onclick = ->
  applyTo = document.querySelector("input[name=sharpen-target]:checked").value
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
    global.applyFilter @value + "blur", global.rendered, global.tmp, options={radius: document.getElementById(@value + "-blur-radius").value}
    global.copyToCanvas blurCanvas, src=global.tmp, scale=0.5
    ).bind element

for element in document.querySelectorAll "input[name=sharpen-type]"
  element.onclick = (->
    for elem in document.querySelectorAll ".sharpenoption"
      elem.setAttribute "hidden", true
    document.getElementById(@value + "-options").removeAttribute "hidden"
    ###Apply with default settings###
    global.applyFilter @value + "sharpen", global.rendered, global.tmp, options={radius: document.getElementById(@value + "-sharpen-radius").value}
    global.copyToCanvas sharpenCanvas, src=global.tmp, scale=0.5
    ).bind element

bindRadiusChange = (elem, modal, flt, canvas)->
  elem.onchange = ((e) ->
    unless @modal.getAttribute "hidden"
      val = @elem.value
      global.applyFilter @flt, global.rendered, global.tmp, options={radius: val}
      global.copyToCanvas @canvas, src=global.tmp, scale=0.5
  ).bind {elem: elem, modal: modal, flt: flt, canvas: canvas}

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

addMenu "file"
addMenu "edit"
addMenu "view"
addMenu "help"

bindRadiusChange gaussianRadius, blurModal, "gaussianblur", blurCanvas
bindRadiusChange lowpassRadius, blurModal, "lowpassblur", blurCanvas
bindRadiusChange unsharpRadius, sharpenModal, "unsharpsharpen", sharpenCanvas
bindRadiusChange biquadRadius, sharpenModal, "biquadsharpen", sharpenCanvas
