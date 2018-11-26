#pragma once
#include <jdefs.h>
createNamespace(history)
#include "HistoryFunctionTable.coffee"

###
History stack
###
global.historyStack = []
global.undoneStack = []

global.history.push = (x...) ->
  global.undoneStack.splice(0)
  global.historyStack.push x...
  while global.historyStack.length > 100
    global.historyStack.shift()

global.history.undo = ->
  action = global.historyStack.pop()
  if action?
    ###
    Each type of history element has a "type" field which
    is the same as the name of a function in the historyFunctionTable
    I use late binding in order to find the correct undo function at
    compile time
    ###
  	global.history.historyFunctionTable[action.type](action, false)
  	global.undoneStack.push action

global.history.redo = ->
  action = global.undoneStack.pop()
  if action?
    global.history.historyFunctionTable[action.type](action, true)
    global.historyStack.push action

global.addKeyDownHandler((key) ->
  if global.isKeyDown 'Control'
    if key is 'z'
      global.history.undo()
    else if key is 'y'
      global.history.redo()
)
