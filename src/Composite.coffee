#include "jdefs.h"

global.composite = ->
	global.ctx.clearRect(0, 0, global.cnv.width, global.cnv.height)
	for l in global.layers
		global.ctx.globalCompositeOperation = l.blendMode
		if !l.upToDate
			l.redraw()
		global.ctx.drawImage(l.canvas, l.x, l.y)
