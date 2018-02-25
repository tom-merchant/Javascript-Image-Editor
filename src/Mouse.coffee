
class global.Mouse
	mouseleft = 1
	mouseright = 2
	mousemiddle = 4
	mousefour = 8
	mousefive = 16

	constructor: (@refElem) ->
		[@pageX, @pageY, @x, @y] = [0, 0, 0, 0]
		[@moveHandlers, @btnUpHandlers, @btnDownHandlers] = [[], [], []]
		@oldElem = @refElem
		[@elemRect, @hasScrolled] = [null, false]
		[@m1down, @m2down] = [false, false]

		@refElem.addEventListener("mousemove", @onMouseMove)
		@refElem.addEventListener("mouseup", @onMouseUp)
		@refElem.addEventListener("mousedown", @onMouseDown)

	onMouseMove: (e) =>
		[@pageX, @pageY] = [e.pageX, e.pageY]
		@translateCoordinates()

		for i in @moveHandlers
			i()

	checkBtns: (e) =>
		@m1down = ((e.buttons & mouseleft) == mouseleft)
		@m2down = ((e.buttons & mouseright) == mouseright)

	onMouseDown: (e) =>
		@checkBtns(e)

		for i in @onMouseDown
			i(e)

	onMouseUp: (e) =>
		@checkBtns(e)

		for i in @onMouseUp
			i(e)

	translateCoordinates: ->
		if @refElem isnt @oldElem or !@elemRect?
			@elemRect = @refElem.getBoundingClientRect()
			@oldElem = @refElem

		@x = @pageX - @elemRect.left - window.scrollX
		@y = @pageY - @elemRect.top - window.scrollY

	addMoveHandler: (f) ->
		@moveHandlers.push f

	addButtonReleaseHandler: (f) ->
		@btnUpHandlers.push f

	addButtonPresshandler: (f) ->
		@btnDownHandlers.push f
	