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

undoBtn = getElem "menu-edit-undo"
redoBtn = getElem "menu-edit-redo"
copyBtn = getElem "mnu-edit-copy"
cutBtn = getElem "mnu-edit-cut"
pasteBtn = getElem "mnu-edit-paste"
resizeBtn = getElem "mnu-edit-resize"
saveBtn = getElem "mnu-file-save"
saveCancel = getElem "save-cancel"
saveSave = getElem "save-save"
saveModal = getElem "save-modal"

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

edgedetectCanvas = getElem "edgedetectCanvas"
edgedetectApply = getElem "filter-edgedetect-apply"
edgedetectCancel = getElem "filter-edgedetect-cancel"

helpModal = getElem "help-modal"
aboutModal = getElem "about-modal"
btnAbout = getElem "btnhlp"
btnHelp = getElem "btnabt"

colour1 = getElem "colour1"
colour2 = getElem "colour2"

widthSlider = getElem "widthslider"

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

###
FIXME: This needs to be automated with a loop or something
its ridiculous
###
global.addKeyDownHandler (k) ->
	if k is "Enter"
		if !openModal.getAttribute "hidden"
			openOpen.onclick()
		else if !openUrlModal.getAttribute "hidden"
			urlOpen.onclick()
		else if !saveModal.getAttribute "hidden"
			saveSave.onclick()
		else if !newModal.getAttribute "hidden"
			newCreate.onclick()
		else if !sharpenModal.getAttribute "hidden"
			sharpenApply.onclick()
		else if !blurModal.getAttribute "hidden"
			blurApply.onclick()
		else if !filterModal.getAttribute "hidden"
			fltSelect.onclick()
		else if !edgedetectModal.getAttribute "hidden"
			edgedetectApply.onclick()
		else if !helpModal.getAttribute "hidden"
			helpModal.setAttribute "hidden", yes
		else if !aboutModal.getAttribute "hidden"
			aboutModal.setAttribute "hidden", yes
	else if k is "Escape"
		if !openModal.getAttribute "hidden"
			openClose.onclick()
		else if !openUrlModal.getAttribute "hidden"
			urlClose.onclick()
		else if !saveModal.getAttribute "hidden"
			saveCancel.onclick()
		else if !newModal.getAttribute "hidden"
			newCancel.onclick()
		else if !sharpenModal.getAttribute "hidden"
			sharpenCancel.onclick()
		else if !blurModal.getAttribute "hidden"
			blurCancel.onclick()
		else if !filterModal.getAttribute "hidden"
			fltClose.onclick()
		else if !edgedetectModal.getAttribute "hidden"
			edgedetectCancel.onclick()
		else if !helpModal.getAttribute "hidden"
			helpModal.setAttribute "hidden", yes
		else if !aboutModal.getAttribute "hidden"
			aboutModal.setAttribute "hidden", yes

window.addEventListener "click", (e) ->
	if e.target is openModal
		openModal.setAttribute "hidden", yes
	else if e.target is openUrlModal
		openUrlModal.setAttribute "hidden", yes
	else if e.target is filterModal
		filterModal.setAttribute "hidden", yes
	else if e.target is newModal
		newModal.setAttribute "hidden", yes
	else if e.target is helpModal
		helpModal.setAttribute "hidden", yes
	else if e.target is aboutModal
		aboutModal.setAttribute "hidden", yes

addMenu "file"
addMenu "edit"
addMenu "view"
addMenu "help"

addFilterApply blurApply, "blur", blurModal, blurRadius
addFilterApply sharpenApply, "sharpen", sharpenModal, sharpenRadius

bindRadiusChange blurRadius, blurModal, "blur", blurCanvas, blurRadiusText
bindRadiusChange sharpenRadius, sharpenModal, "sharpen", sharpenCanvas, sharpenRadiusText

bindModalOpen btnNew,     newModal
bindModalOpen btnOpen,    openModal
bindModalOpen btnOpenUrl, openUrlModal
bindModalOpen btnFilter,  filterModal
bindModalOpen saveBtn,    saveModal
bindModalOpen btnAbout, aboutModal
bindModalOpen btnHelp, helpModal

bindModalClose fltClose,      filterModal
bindModalClose blurCancel,    blurModal
bindModalClose sharpenCancel, sharpenModal
bindModalClose newCancel,     newModal
bindModalClose urlClose,      openUrlModal
bindModalClose openClose,     openModal
bindModalClose saveCancel,    saveModal

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
		when "edgedetect"
			global.applyFilter "edgedetect", global.rendered, global.tmp, options={}
			break
	global.copyToCanvas modalCanvas, src=global.tmp, scale=0.5


newImgCnv = document.createElement "canvas"
newImgCtx = newImgCnv.getContext("2d")

newCreate.onclick = ->
	newImgCnv.width = getElem("new-layer-width").value
	newImgCnv.height = getElem("new-layer-height").value
	newImgCtx.fillStyle = getElem("new-layer-colour").value
	newImgCtx.fillRect 0, 0, newImgCnv.width, newImgCnv.height
	global.addUrlLayer newImgCnv.toDataURL()
	newModal.setAttribute "hidden", yes

saveSave.onclick = (->
	format = getElem("save-format").value
	dataUrl = global.rendered.toDataURL(format)
	anchor = document.createElement "a"
	anchor.href = dataUrl
	anchor.download = getElem("save-name").value + format.replace("image/", ".")
	anchor.innerText = anchor.download
	anchor.click()
	@parentNode.appendChild anchor
	anchor.onclick = (->
		saveModal.setAttribute "hidden", yes
		@parentNode.removeChild @
		).bind anchor
	anchor.click()
	).bind saveSave


colour1.onchange = (->
	global.fgColour = global.parseColour(@value)
	).bind colour1

colour2.onchange = (->
	global.bgColour = global.parseColour(@value)
	).bind colour2

widthSlider.onchange = (->
	global.brushwidth = @value
	if global.activeTool
		global.activeTool.lineThickness = @value
).bind widthSlider

###
If the browser saves the page state across refreshes
then we need to load the selected colours, and brush width
###
global.fgColour = global.parseColour(colour1.value)
global.bgColour = global.parseColour(colour2.value)
global.brushwidth = widthSlider.value