#include <jdefs.h>

createNamespace(_)

#include "Mouse.coffee"
#include "Keyboard.coffee"
#include "Layer.coffee"
#include "DOM.coffee"

cnv = document.getElementById "cnv"
ctx = cnv.getContext "2d"

global.history = []

global.selectedLayer = 0

global.mouse = new global.Mouse(window.document.body)
