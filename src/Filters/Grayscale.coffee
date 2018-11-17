#include <jdefs.h>
#include "../Utility.coffee"

global.filter.makeGrayscale = (src, dst) ->
	n = src.width * src.height
	for i in [0...n]
		m = i * 4
		r = src.data[m]
		g = src.data[m+1]
		b = src.data[m+2]
		dst.data.push global.luminosityAverage [r, g, b]