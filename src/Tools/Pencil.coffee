#pragma once

###
Pencil.coffee
Implements a pencil tool for drawing
Tom Merchant 2018
###

#include <jdefs.h>
#include "DrawingTool.coffee"
#include "Icons.coffee"

###
All this instantiation is insane
DrawingTool should be a closure
infact maybe tool itself should be a closure
pencil should just be an object defining the methods
and data that defines a pencil and there should be a
set_tool function somewhere that mutates the state of the
tool or drawingtool closure in order to  change the behaviour
We dont need all these instances

for instance

pencil =
    name: "Pencil"
    icon: "data:png/...."
    desc: "A pencil tool for drawing"
    cursor: "data:png/..."
    type: "raster"
    color: "foreground"
    startFunc: drawPixel
    drawFunc: drawLine
    size: 1
###

global.tools.tools.push new global.tools.DrawingTool("Pencil",
    global.tools.Icons.Pencil.icon,
    "A pencil tool for drawing",
    global.tools.Icons.Pencil.cursor,
    global.getLayer(global.selectedLayer),
    "raster", global.fgColour, drawPixel,
    drawLine, 1)
    