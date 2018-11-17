#pragma once

###
Rubber.coffee
Implements a rubber tool for erasing pixels
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawingTool.coffee"
#include "Icons.coffee"

global.tools.tools.push new global.tools.DrawingTool("Rubber",
    global.tools.Icons.Rubber.icon,
    "A rubber tool for erasing pixels",
    global.tools.Icons.Rubber.cursor,
    global.getLayer(global.selectedLayer), "raster",
    [0, 0, 0, 0], drawBlob, drawThickLine,
    global.brushWidth)

