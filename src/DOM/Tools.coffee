
toolTable = getElem "tool-table"
toolTableCols = 2
toolTableRows = Math.ceil(global.tools.tools.length / toolTableCols)

###
Mechanism for handling toolbar button presses
###
onToolSwap = ->
  if global.activeTool?
    ###
    Make sure we finish any action being performed
    ###
    global.activeTool.end()
  global.cnv.style.cursor = @.cursor
  global.activeTool = @

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
  btn.style.backgroundSize = "48px 48px"
  tooltipDiv.innerText = tooltip
  div.appendChild btn
  div.appendChild tooltipDiv
  return div

k = 0
for i from [0...toolTableRows]
  currentRow = document.createElement "tr"
  for j from [0...toolTableCols]
    if global.tools.tools[k]?
      newCol = document.createElement "td"
      toolButton = createIconButton global.tools.tools[k].icon, global.tools.tools[k].name, global.tools.tools[k].description
      toolButton.addEventListener "click", onToolSwap.bind global.tools.tools[k]
      newCol.appendChild toolButton
      currentRow.append newCol
    k++
  toolTable.appendChild currentRow