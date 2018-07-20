#include <jdefs.h>
#include "Filters/Filters.coffee"
#include "Tools/Tool.coffee"

###
Contains all DOM events
###
global.menuOpen = {}

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

blurRadius = document.getElementById "blur-radius"

sharpenRadius = document.getElementById "sharpen-radius"

blurCanvas = document.getElementById "blurCanvas"

sharpenCanvas = document.getElementById "sharpenCanvas"

toolTable = document.getElementById "tool-table"
toolTableCols = 2
toolTableRows = global.tools.tools.length / toolTableCols

bindRadiusChange = (elem, modal, flt, canvas)->
  elem.onchange = ((e) ->
    unless @modal.getAttribute "hidden"
      val = @elem.value
      global.applyFilter @flt, global.rendered, global.tmp, options={radius: val}
      global.copyToCanvas @canvas, src=global.tmp, scale=0.5
  ).bind {elem: elem, modal: modal, flt: flt, canvas: canvas}

createIconButton = (icon, name, tooltip) ->
  div = document.createElement "div"
  btn = document.createElement "button"
  tooltipDiv = document.createElement "div"
  img = document.createElement "img"
  ###Create button with icon###
  div.classList += "iconbtn"
  tooltipDiv.classList += "tooltip"
  btn.id = "tool" + name
  img.src = icon
  tooltipDiv.innerText = tooltip
  btn.appendChild img
  div.appendChild btn
  div.appendChild tooltipDiv
  return div

###
Sets up the menu buttons defined in the document
@param str [String] The name of the menu button
###
addMenu = (str) ->
  global.menuOpen[str] = no
  mnuBtn = document.getElementById "mnu-" + str
  mnuBtns = document.getElementById "mnu-" + str + "-btns"

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
    ).bind({mnuBtn: mnuBtn, mnuBtns: mnuBtns, str: str})

addFilterApply = (btn, type, modal) ->
  btn.onclick = (->
    applyTo = document.querySelector("input[name=" + @type + "-target]:checked").value
    radius = document.getElementById(@type + "-radius").value
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
    ).bind({type: type, modal: modal})


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
    reader.onerror = (-> global.assert false, "Failed to load " + @file).bind({src: file})
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
  document.getElementById("filter-" + type + "-modal").removeAttribute "hidden"
  modalCanvas = document.querySelector("#filter-" + type + "-modal canvas")
  modalCanvas.width = global.cnv.width / 2
  modalCanvas.height = global.cnv.height / 2
  switch type
    when "blur"
      global.applyFilter "blur", global.rendered, global.tmp, options={radius: document.getElementById("blur-radius").value}
      break
    when "sharpen"
      global.applyFilter "sharpen", global.rendered, global.tmp, options={radius: document.getElementById("sharpen-radius").value}
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
      newcol.appendChild createIconButton global.tools.tools[k].icon, global.tools.tools[k].name, global.tools.tools[k].description
      currentRow.append newCol
    k++
  toolTable.appendChild currentRow

for element in document.querySelectorAll "input[name=blur-type]"
  element.onclick = (->
    for elem in document.querySelectorAll ".bluroption"
      elem.setAttribute "hidden", yes
    document.getElementById(@value + "-options").removeAttribute "hidden"
    ###Apply with default settings###
    global.applyFilter @value + "blur", global.rendered, global.tmp, options={radius: document.getElementById(@value + "-blur-radius").value}
    global.copyToCanvas blurCanvas, src=global.tmp, scale=0.5
    ).bind element

for element in document.querySelectorAll "input[name=sharpen-type]"
  element.onclick = (->
    for elem in document.querySelectorAll ".sharpenoption"
      elem.setAttribute "hidden", yes
    document.getElementById(@value + "-options").removeAttribute "hidden"
    ###Apply with default settings###
    global.applyFilter @value + "sharpen", global.rendered, global.tmp, options={radius: document.getElementById(@value + "-sharpen-radius").value}
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

bindRadiusChange blurRadius, blurModal, "blur", blurCanvas
bindRadiusChange sharpenRadius, sharpenModal, "sharpen", sharpenCanvas

addFilterApply blurApply, "blur", blurModal
addFilterApply sharpenApply, "sharpen", sharpenModal
