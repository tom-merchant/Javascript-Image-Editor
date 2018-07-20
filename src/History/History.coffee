#include <jdefs.h>

createNamespace(history)

###
History stack
###
global.historyStack = []

global.history.push = (x...) ->
  global.historyStack.push x...

global.history.undo = ->
  action = global.historyStack.pop()

global.history.redo = ->
