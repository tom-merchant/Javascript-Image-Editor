#include <jdefs.h>

createNamespace(_)

#include "Props.coffee"
#include "Utility.coffee"
#include "Composite.coffee"
#include "Mouse.coffee"
#include "Keyboard.coffee"
#include "Layer.coffee"
#include "DOM.coffee"

global.cnv = document.getElementById "cnv"
global.ctx = global.cnv.getContext "2d"

global.history = []

global.selectedLayer = 0

global.mouse = new global.Mouse(window.document.body)
