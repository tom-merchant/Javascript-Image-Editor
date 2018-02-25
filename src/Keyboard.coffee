#include <jdefs.h>

keyStates =
	A: false

keyDownHandlers = []
keyUpHandlers = []

global.onKeyDown = (e) ->
	keyStates[e.key] = true
	for h in keyDownHandlers
		h(e.key)

global.onKeyUp = (e) ->
	keyStates[e.key] = false
	for h in keyUpHandlers
		h(e.key)

global.addKeyDownHandler = (f) ->
	keyDownHandlers.push f

global.addKeyUpListener = (f) ->
	keyUpHandlers.push f

window.addEventListener("keydown", global.onKeyDown)
window.addEventListener("keyup", global.onKeyUp)
