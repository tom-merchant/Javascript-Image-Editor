#include "jdefs.h"

global.composite = ->
	global.ctx.clearRect(0, 0, global.cnv.width, global.cnv.height)
	global.ctx.save() # Save the untransformed state
	global.ctx.translate global.cnv.width / 2, global.cnv.height / 2
	global.ctx.scale(global.scale, global.scale)
	global.ctx.translate(global.panning[0], global.panning[1])
	global.ctx.translate -global.cnv.width / 2, -global.cnv.height / 2
	for l in global.layers
		global.ctx.globalCompositeOperation = l.blendMode
		if !l.upToDate
			l.redraw()
		global.ctx.drawImage(l.canvas, l.x, l.y)
	global.ctx.restore() # Return to the untransformed state
