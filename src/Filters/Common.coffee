#pragma once
###
Common utilities for implementing image filters

Tom Merchant 2018
###

#include <jdefs.h>
#include "../Maths.coffee"
#include "../Utility.coffee"
#include "IIRFilter.coffee"

global.filter.kernelCache = {}

###
Performs a kernel convolution with the given kernel on the src image data

@param kernel [Object] The kernel to apply
@param src [ImageData] The image data to apply the kernel to

@options kernel [Array] data 1D array of the kernel data
@options kernel [Integer] width The width of the kernel
@options kernel [Integer] height The height of the kernel

@return [ImageData] The filtered image data
###
global.filter.applyKernel = (kernel, src, grayscale=no) ->
  newData = null
  channels = 4

  unless grayscale
    newData = global.ctx.createImageData src.width, src.height
  else
    newData = []
    channels = 1

  global.filter.kernelCache[[kernel.width, kernel.height, kernel.type, kernel.radius]] ?= {}

  cache = global.filter.kernelCache[[kernel.width, kernel.height, kernel.type, kernel.radius]]

  for i in [0...src.width * src.height]
    x = i % (src.width)
    y = Math.floor (i / (src.width))

    newKernel = global.filter.resizeKernel kernel, x, y, src, cache
    filteredPixel = global.filter.processPixel newKernel, x, y, src, grayscale=grayscale
    pos = (x + y * src.width) * channels

    for i in [0...channels]
      newData.data[pos + i] = filteredPixel[i]
  return newData

global.filter.resizeKernel  = (kernel, x, y, img, cache) ->
  border_y_top = 0
  border_y_bottom = 0
  border_x_left = 0
  border_x_right = 0

  if y < kernel.height / 2
    border_y_top = kernel.height / 2 - y
  if y > img.height - kernel.height / 2
    border_y_bottom = kernel.height / 2 - (img.height - y)
  if x < kernel.width / 2
    border_x_left = kernel.width / 2 - x
  if x > img.width - kernel.width / 2
    border_x_right = kernel.height / 2 - (img.width - x)

  if border_y_top + border_y_bottom + border_x_left + border_x_right > 0
    cachedKernel = cache[[border_y_top, border_y_bottom, border_x_left, border_x_right]]
    if cachedKernel?
      return cachedKernel
    newKernel = JSON.parse (JSON.stringify kernel)
    global.filter.resize newKernel, border_y_top, border_y_bottom, border_x_left, border_x_right
    cache[[border_y_top, border_y_bottom, border_x_left, border_x_right]] = newKernel
    return newKernel
  return kernel

global.filter.resize = (kernel, top_excess, bottom_excess, left_excess, right_excess) ->
  for n in [0...top_excess]
    global.filter.clearRow kernel, n
  for n in [0...bottom_excess]
    global.filter.clearRow kernel, kernel.height - n
  for n in [0...left_excess]
    global.filter.clearColumn kernel, n
  for n in [0...right_excess]
    global.filter.clearColumn kernel, kernel.width - n
  ###
  The kernel no longer sums to zero, so will not compute a weighted average,
  this means we need to renormalize
  ###
  weightsum = 0
  for x in [0...kernel.width]
    for y in [0...kernel.height]
      weight = kernel.data[y * kernel.width + x]
      unless isNaN(weight) or weightsum is 0
        weightsum += weight
  for x in [0...kernel.width]
    for y in [0...kernel.height]
      unless isNaN(kernel.data[y * kernel.width + x]) or weightsum is 0
        kernel.data[y * kernel.width + x] /= weightsum

global.filter.clearRow = (kernel, row) ->
  for x in [0...kernel.width]
    kernel.data[row * kernel.width + x] = NaN

global.filter.clearColumn = (kernel, col) ->
  for y in [0...kernel.height]
    kernel.data[y * kernel.width + col] = NaN

global.filter.processPixel = (kernel, i, j, img, grayscale=no) ->
  sums = [0, 0, 0, 0]
  channels = 4

  if grayscale
    channels = 1

  for x in [0...kernel.width]
    for y in [0...kernel.height]
      unless isNaN(kernel.data[y * kernel.width + x])
        iy = ~~(j + y - kernel.height / 2)
        ix =  ~~(i + x - kernel.width / 2)
        pos = (iy*img.width+ix) * channels
        data = []
        weight = kernel.data[y * kernel.width + x]
        for i in [0...channels]
          data.push img.data[pos+i]
          sums[i] += global.ungamma(data[i]) * weight

  for i in [0...channels]
    sums[i] = ~~(global.regamma sums[i])

  return sums

###
Filter is run forwards and backwards over both axes
###
global.filter.applyFilter = (filter, data) ->
  newData = global.ctx.createImageData data.width, data.height
  newDataArr = new Array(data.width * data.height * 4)
  halfmax = global.ungamma(255) / 2
  for ch in [0...4]
    for y in [0...data.height]
      for x in [0...data.width]
        len = (y * data.width + x) * 4
        px = global.ungamma(data.data[len + ch]) / halfmax - 1
        newDataArr[len + ch] = filter.nextSample(px)
      filter.clear()
    for y in [0...data.height]
      for x in [(data.width - 1)..0]
        len = (y * data.width + x) * 4
        px = newDataArr[len + ch]
        newDataArr[len + ch] = filter.nextSample(px)
      filter.clear()
    for x in [0...data.width]
      for y in [0...data.height]
        len = (y * data.width + x) * 4
        px = newDataArr[len + ch]
        newDataArr[len + ch] = filter.nextSample(px)
      filter.clear()
    for x in [0...data.width]
      for y in [(data.height - 1)..0]
        len = (y * data.width + x) * 4
        px = newDataArr[len + ch]
        newDataArr[len + ch] = filter.nextSample(px)
        newDataArr[len + ch] = global.regamma((newDataArr[len + ch] + 1)  * halfmax)
      filter.clear()
  for y in [0...data.height]
    for x in [0...data.width]
      len = (y * data.width + x) * 4
      newData.data[len] = newDataArr[len]
      newData.data[len + 1] = newDataArr[len + 1]
      newData.data[len + 2] = newDataArr[len + 2]
      newData.data[len + 3] = newDataArr[len + 3]
  return newData

###
Only works on grayscale images
###

global.filter.applyThreshold = (data, width, height, threshold) ->
  for i in [0...width]
    for j in [0...height]
      pos = j * width + i
      if data[pos] < threshold
        data[pos] = 0
      else
        data[pos] = 255


global.filter.createIIR = (radius) ->
  return new global.filter.IIR(radius / 3)
