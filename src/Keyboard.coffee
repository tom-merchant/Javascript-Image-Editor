#pragma once
#include <jdefs.h>

keyStates =
	A: off

keyDownHandlers = []
keyUpHandlers = []

global.onKeyDown = (e) ->
	keyStates[e.key] = on
	for h in keyDownHandlers
		h(e.key)

global.onKeyUp = (e) ->
	keyStates[e.key] = off
	for h in keyUpHandlers
		h(e.key)

global.addKeyDownHandler = (f) ->
	keyDownHandlers.push f

global.addKeyUpListener = (f) ->
	keyUpHandlers.push f

window.addEventListener("keydown", global.onKeyDown)
window.addEventListener("keyup", global.onKeyUp)
