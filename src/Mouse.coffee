#pragma once

###
Mouse.coffee Tom Merchant 2018

A useful file for handling mouse input
###

#include <jdefs.h>

class global.Mouse
  mouseleft = 1
  mouseright = 2
  mousemiddle = 4
  mousefour = 8
  mousefive = 16

  constructor: (@refElem) ->
    @pageX = @pageY = @x = @y = 0
    [@moveHandlers, @btnUpHandlers, @btnDownHandlers, @scrollHandlers] = [[], [], [], []]
    @oldElem = @refElem
    [@elemRect, @hasScrolled] = [null, no]
    @m1down = @m2down = no

    @refElem.addEventListener("mousemove", @onMouseMove)
    @refElem.addEventListener("mouseup", @onMouseUp)
    @refElem.addEventListener("mousedown", @onMouseDown)
    @refElem.addEventListener("wheel", @onMouseWheel)

  onMouseMove: (e) =>
    [@pageX, @pageY] = [e.pageX, e.pageY]
    @translateCoordinates()

    for i in @moveHandlers
      i()

  checkBtns: (e) =>
    @m1down = ((e.buttons & mouseleft) == mouseleft)
    @m2down = ((e.buttons & mouseright) == mouseright)

  onMouseDown: (e) =>
    @checkBtns e

    for i in @btnDownHandlers
      i e, e.button

  onMouseUp: (e) =>
    @checkBtns e

    for i in @btnUpHandlers
      i e, e.button

  onMouseWheel: (e) =>
    e.preventDefault()
    for i in @scrollHandlers
      i e
    return false

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

  addButtonPressHandler: (f) ->
    @btnDownHandlers.push f

  addScrollHandler: (f) ->
    @scrollHandlers.push f
