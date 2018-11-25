#pragma once

###
DOM.coffee

Glues the HTML UI and JS state together through DOM events
and DOM manipulation enabling this application to work.

Tom Merchant 2018
###

#include <jdefs.h>

###
TODO: Implement new layer functionality
###

global.menuOpen = {}

getElem = document.getElementById.bind document

btnNew = getElem "mnu-file-new"
newModal = getElem "new-layer-modal"
newCreate = getElem "new-layer-create"
newCancel = getElem "new-layer-cancel"

btnOpen = getElem "mnu-file-open"
openModal = getElem "open-file-modal"
openClose = getElem "open-close"
openOpen = getElem "open-open"
fileInput = getElem "file-input"

btnOpenUrl = getElem "mnu-url-open"
openUrlModal = getElem "open-url-modal"
urlOpen = getElem "open-url-open"
urlClose = getElem "open-url-close"
urlInput = getElem "url-input"

btnFilter = getElem "select-filter"
filterModal = getElem "filter-modal"
fltSelect = getElem "filter-select-apply"
fltClose = getElem "filter-select-cancel"
fltType = getElem "filter-type"

blurModal = getElem "filter-blur-modal"
blurCancel = getElem "filter-blur-cancel"
blurApply = getElem "filter-blur-apply"

sharpenModal = getElem "filter-sharpen-modal"
sharpenCancel = getElem "filter-sharpen-cancel"
sharpenApply = getElem "filter-sharpen-apply"

blurRadius = getElem "blur-radius"
blurRadiusText = getElem "blur-radius-display"

sharpenRadius = getElem "sharpen-radius"
sharpenRadiusText = getElem "sharpen-radius-display"

blurCanvas = getElem "blurCanvas"

sharpenCanvas = getElem "sharpenCanvas"

colour1 = getElem "colour1"
colour2 = getElem "colour2"

###
Updates the output of the filter being configured when the radius changes
###
bindRadiusChange = (elem, modal, flt, canvas, disp)->
  elem.onchange = ((e) ->
    unless @modal.getAttribute "hidden"
      val = @elem.value
      @disp.innerText = val
      global.applyFilter @flt, global.rendered, global.tmp, options={radius: val}
      global.copyToCanvas @canvas, src=global.tmp, scale=0.5
  ).bind {elem: elem, modal: modal, flt: flt, canvas: canvas, disp: disp}

###
Sets up the menu buttons defined in the document
@param str [String] The name of the menu button
###
addMenu = (str) ->
  global.menuOpen[str] = no
  mnuBtn = getElem "mnu-" + str
  mnuBtns = getElem "mnu-" + str + "-btns"

  mnuBtn.onclick = ((mnuBtns) ->
    unless global.menuOpen[@str]
      @mnuBtns.style.left = global.mouse.x + "px"
      @mnuBtns.style.top = global.mouse.y + "px"
      @mnuBtns.removeAttribute "hidden"
      global.menuOpen[@str] = yes
    else
      @mnuBtns.setAttribute "hidden", yes
      global.menuOpen[@str] = no
  ).bind({mnuBtns: mnuBtns, str: str})

  window.addEventListener "click", ((e) ->
    if e.target isnt @mnuBtn and global.menuOpen[@str]
      global.menuOpen[@str] = no
      @mnuBtns.setAttribute "hidden", yes
    ).bind {mnuBtn: mnuBtn, mnuBtns: mnuBtns, str: str}

###
Mechanism for applying filter configurations
###
addFilterApply = (btn, type, modal, slider) ->
  btn.onclick = (->
    radius = @slider.value
    filter =
      type: @type
      options:
        radius: radius

    global.selectedLayer.filters.push filter
    global.selectedLayer.upToDate = no
    global.composite()

    global.history.push
      type: "addfilter"
      layer: global.selectedLayer.id
      type: filter.type
      radius: filter.options.radius
    @modal.setAttribute "hidden", yes
    ).bind {type: type, modal: modal, slider: slider}

bindModalOpen = (button, modal) ->
  button.onclick = (->
    @.removeAttribute "hidden").bind(modal)

bindModalClose = (button, modal) ->
  button.onclick = (->
    @.setAttribute "hidden", yes).bind(modal)


global.addKeyDownHandler (k) ->
  if k is "Enter"
    if !openModal.getAttribute "hidden"
      openOpen.onclick()
    else if !openUrlModal.getAttribute "hidden"
      urlOpen.onclick()
  else if k is "Escape"
    if !openModal.getAttribute "hidden"
      openClose.onclick()
    else if !openUrlModal.getAttribute "hidden"
      urlClose.onclick()

window.addEventListener "click", (e) ->
  if e.target is openModal
    openModal.setAttribute "hidden", yes
  else if e.target is openUrlModal
    openUrlModal.setAttribute "hidden", yes
  else if e.target is filterModal
    filterModal.setAttribute "hidden", yes
  else if e.target is newModal
    newModal.setAttribute "hidden", yes

addMenu "file"
addMenu "edit"
addMenu "view"
addMenu "help"

addFilterApply blurApply, "blur", blurModal, blurRadius
addFilterApply sharpenApply, "sharpen", sharpenModal, sharpenRadius

bindRadiusChange blurRadius, blurModal, "blur", blurCanvas, blurRadiusText
bindRadiusChange sharpenRadius, sharpenModal, "sharpen", sharpenCanvas, sharpenRadiusText

bindModalOpen btnNew, newModal
bindModalOpen btnOpen, openModal
bindModalOpen btnOpenUrl, openUrlModal
bindModalOpen btnFilter, filterModal

bindModalClose fltClose, filterModal
bindModalClose blurCancel, blurModal
bindModalClose sharpenCancel, sharpenModal
bindModalClose newCancel, newModal
bindModalClose urlClose, openUrlModal
bindModalClose openClose, openModal

urlOpen.onclick = ->
  if urlInput.value.length > 0
    url = urlInput.value
    urlInput.value = null
    global.addUrlLayer url
    openUrlModal.setAttribute "hidden", yes

openOpen.onclick = ->
  if fileInput.files.length > 0
    file = fileInput.files[0]
    reader = new FileReader()
    reader.onload = global.addFileLayer
    reader.onerror = (-> global.assert false, "Failed to load " + @src).bind({src: file})
    reader.readAsDataURL file
    fileInput.value = null
    openModal.setAttribute "hidden", yes

fltSelect.onclick = ->
  type = document.querySelector("input[name=filter-type]:checked").value
  filterModal.setAttribute "hidden", yes
  getElem("filter-" + type + "-modal").removeAttribute "hidden"
  modalCanvas = document.querySelector("#filter-" + type + "-modal canvas")
  modalCanvas.width = global.cnv.width / 2
  modalCanvas.height = global.cnv.height / 2
  switch type
    when "blur"
      global.applyFilter "blur", global.rendered, global.tmp, options={radius: getElem("blur-radius").value}
      break
    when "sharpen"
      global.applyFilter "sharpen", global.rendered, global.tmp, options={radius: getElem("sharpen-radius").value}
      break
  global.copyToCanvas modalCanvas, src=global.tmp, scale=0.5

colour1.onchange = (->
  global.fgColour = global.parseColour(@value)
  ).bind colour1

colour2.onchange = (->
  global.bgColour = global.parseColour(@value)
  ).bind colour2

for element in document.querySelectorAll "input[name=blur-type]"
  element.onclick = (->
    for elem in document.querySelectorAll ".bluroption"
      elem.setAttribute "hidden", yes
    getElem(@value + "-options").removeAttribute "hidden"
    ###Apply with default settings###
    global.applyFilter @value + "blur", global.rendered, global.tmp, options={radius: getElem(@value + "-blur-radius").value}
    global.copyToCanvas blurCanvas, src=global.tmp, scale=0.5
    ).bind element

for element in document.querySelectorAll "input[name=sharpen-type]"
  element.onclick = (->
    for elem in document.querySelectorAll ".sharpenoption"
      elem.setAttribute "hidden", yes
    getElem(@value + "-options").removeAttribute "hidden"
    ###Apply with default settings###
    global.applyFilter @value + "sharpen", global.rendered, global.tmp, options={radius: getElem(@value + "-sharpen-radius").value}
    global.copyToCanvas sharpenCanvas, src=global.tmp, scale=0.5
    ).bind element

###
If the browser saves the page state across refreshes
then we need to load the selected colours, brush widths
and brush hardnesses
###
global.fgColour = global.parseColour(colour1.value)
global.bgColour = global.parseColour(colour2.value)
###
TODO: load brush width and hardness
###