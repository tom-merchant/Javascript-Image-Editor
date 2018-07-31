#include <jdefs.h>
#include "Filters/Filters.coffee"
#include "Tools/Tool.coffee"
#include "Tools/Pencil.coffee"

###
Contains all DOM events
###
global.menuOpen = {}

getElem = document.getElementById.bind document

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

toolTable = getElem "tool-table"
toolTableCols = 2
toolTableRows = Math.ceil(global.tools.tools.length / toolTableCols)

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
Creates a HTML element which represents a button with a tooltip and an icon
###
createIconButton = (icon, name, tooltip) ->
  div = document.createElement "div"
  btn = document.createElement "button"
  tooltipDiv = document.createElement "div"
  ###Create button with icon###
  div.classList += "iconbtn"
  tooltipDiv.classList += "tooltip"
  btn.id = "tool" + name
  btn.style.backgroundImage = "url('" + icon + "')"
  btn.style.width = "50px"
  btn.style.height = "50px"
  tooltipDiv.innerText = tooltip
  div.appendChild btn
  div.appendChild tooltipDiv
  return div

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
    applyTo = document.querySelector("input[name=" + @type + "-target]:checked").value
    radius = @slider.value
    filter =
      type: @type
      options:
        radius: radius
    isGlobal = no
    if applyTo is "image"
      isGlobal = yes
      global.filters.push filter
      global.copyToCanvas global.rendered, src=global.tmp
      global.reframe()
    else
      global.selectedLayer.filters.push filter
      global.selectedLayer.upToDate = no
      global.composite()
    global.history.push
      type: "add filter"
      isGlobal: isGlobal
      layer: global.selectedLayer.id
      type: filter.type
      radius: filter.options.radius
    @modal.setAttribute "hidden", yes
    ).bind {type: type, modal: modal, slider: slider}


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
    openUrlModal.setAttribute "hidden", yes

urlClose.onclick = ->
  openUrlModal.setAttribute "hidden", yes

btnOpenUrl.onclick = ->
  openUrlModal.removeAttribute "hidden"

openClose.onclick = ->
  openModal.setAttribute "hidden", yes

openOpen.onclick = ->
  if fileInput.files.length > 0
    file = fileInput.files[0]
    reader = new FileReader()
    reader.onload = global.addFileLayer
    reader.onerror = (-> global.assert false, "Failed to load " + @src).bind({src: file})
    reader.readAsDataURL file
    fileInput.value = null
    openModal.setAttribute "hidden", yes

###
Edit Menu
###

btnFilter.onclick = ->
  filterModal.removeAttribute "hidden"

fltClose.onclick = ->
  filterModal.setAttribute "hidden", yes

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

blurCancel.onclick = ->
  blurModal.setAttribute "hidden", yes

sharpenCancel.onclick = ->
  sharpenModal.setAttribute "hidden", yes

k = 0
for i from [0..toolTableRows]
  currentRow = document.createElement "tr"
  for j from [0..toolTableCols]
    if global.tools.tools[k]?
      newCol = document.createElement "td"
      newCol.appendChild createIconButton global.tools.tools[k].icon, global.tools.tools[k].name, global.tools.tools[k].description
      currentRow.append newCol
    k++
  toolTable.appendChild currentRow

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

global.addKeyDownHandler (k) ->
  if k is "Enter"
    if !openModal.getAttribute "hidden"
      openOpen.onclick()
    else if !openUrlModal.getAttribute "hidden"
      urlOpen.onclick()

window.addEventListener "click", (e) ->
  if e.target is openModal
    openModal.setAttribute "hidden", yes
  else if e.target is openUrlModal
    openUrlModal.setAttribute "hidden", yes
  else if e.target is filterModal
    filterModal.setAttribute "hidden", yes


addMenu "file"
addMenu "edit"
addMenu "view"
addMenu "help"

bindRadiusChange blurRadius, blurModal, "blur", blurCanvas, blurRadiusText
bindRadiusChange sharpenRadius, sharpenModal, "sharpen", sharpenCanvas, sharpenRadiusText

addFilterApply blurApply, "blur", blurModal, blurRadius
addFilterApply sharpenApply, "sharpen", sharpenModal, sharpenRadius
