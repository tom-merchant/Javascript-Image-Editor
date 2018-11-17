#pragma once

###
Brush.coffee
Implements a brush tool for drawing thick lines
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawingTool.coffee"
#include "Icons.coffee"

global.tools.tools.push new global.tools.DrawingTool("Brush",
    global.tools.Icons.Brush.icon,
    "A brush tool for drawing thick lines",
    global.tools.Icons.Brush.cursor,
    global.getLayer(global.selectedLayer), "raster",
    global.fgColour, drawBlob, drawThickLine,
    global.brushWidth)
