#pragma once
#define global com.tmerchant.edit
#define namespace(x) window.x
#define createNamespace(x) createNamespace("window.com.tmerchant.edit." + #x)

if not window
	GLOBAL.window = GLOBAL
	GLOBAL.falseWindow = true
else
	window.falseWindow = false

window.createNamespace = (pkg) ->
	parent = window
	for s in pkg.split(".")
		unless s is "window"
			parent[s] ?= {}
			parent = parent[s]
			