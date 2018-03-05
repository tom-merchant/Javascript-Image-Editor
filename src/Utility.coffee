#include "jdefs.h"

global.average = (arr) ->
	sum = 0
	for v in arr
		sum += v
	return sum / arr.length

global.ungamma = (x) ->
	return math.pow(x, global.gamma)

global.regamma = (x) ->
	return math.pow(x, 1/global.gamma)

global.luminosityAverage = (arr) ->
	return regamma global.average((ungamma x for x in arr))
