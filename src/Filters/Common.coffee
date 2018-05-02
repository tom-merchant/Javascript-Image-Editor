###
Common utilities for implementing image filters

Tom Merchant 2018
###

#include <jdefs.h>
#include "../Maths.coffee"
#include "../Utility.coffee"

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
global.filter.applyKernel = (kernel, src) ->
  newData = global.ctx.createImageData src.width, src.height

  global.filter.kernelCache[[kernel.width, kernel.height, kernel.type, kernel.radius]] ?= {}

  cache = global.filter.kernelCache[[kernel.width, kernel.height, kernel.type, kernel.radius]]

  for i in [0...src.width * src.height]
    x = i % src.width
    y = Math.floor (i / src.width)

    newKernel = global.filter.resizeKernel kernel, x, y, src, cache

    filteredPixel = global.filter.processPixel newKernel, x, y, src
    newData.data[i*4] = filteredPixel[0]
    newData.data[i*4+1] = filteredPixel[1]
    newData.data[i*4+2] = filteredPixel[2]
    newData.data[i*4+3] = filteredPixel[3]
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
      unless isNaN(weight)
        weightsum += weight
  for x in [0...kernel.width]
    for y in [0...kernel.height]
      unless isNaN(kernel.data[y * kernel.width + x])
        kernel.data[y * kernel.width + x] /= weightsum

global.filter.clearRow = (kernel, row) ->
  for x in [0...kernel.width]
    kernel.data[row * kernel.width + x] = NaN

global.filter.clearColumn = (kernel, col) ->
  for y in [0...kernel.height]
    kernel.data[y * kernel.width + col] = NaN

global.filter.processPixel = (kernel, i, j, img) ->
  sumr = 0
  sumg = 0
  sumb = 0
  suma = 0

  for x in [0...kernel.width]
    for y in [0...kernel.height]
      unless isNaN(kernel.data[y * kernel.width + x])
        len = (~~(j + y - kernel.height / 2) * img.width + ~~(i + x - kernel.width / 2)) * 4
        data = [img.data[len], img.data[len+1], img.data[len+2], img.data[len+3]]
        weight = kernel.data[y * kernel.width + x]
        sumr += global.ungamma(data[0]) * weight
        sumg += global.ungamma(data[1]) * weight
        sumb += global.ungamma(data[2]) * weight
        suma += global.ungamma(data[3]) * weight

  return [~~global.regamma(sumr), ~~global.regamma(sumg), ~~global.regamma(sumb), ~~global.regamma(suma)]

###
Builds the approppriate kernel to perform the required filtering operation

@param type [String] The type of kernel to build
@param radius [Number] the radius if using a blur or sharpen etc
@param width [Integer] Optional, the width of the kernel (some filters ignore this)
@pparam height [Integer] Optional, the height of the kernel (some filters ignore this)

@return [Object] The built kernel
###
global.filter.buildKernel = (type, radius) ->
  width = radius * 2
  height = radius * 2
  kernel =
    data: []
    width: width
    height: height
    type: type
    radius: radius
  switch type
    when "gaussian"
      size = ~~(radius) * 2 + 1
      kernel.width = size
      kernel.height = size
      centre = [size / 2, size / 2]
      sum = 0
      ###
      TODO: This is inefficient, the gaussian distribution is symmetrical
      ###
      for x in [0...kernel.width]
        for y in [0...kernel.height]
          dx = centre[0] - x
          dy = centre[1] - y
          weight = global.gauss(dx, radius/2) * global.gauss(dy, radius / 2)
          sum += weight
          kernel.data[y*width + x] = weight
      for x in [0...kernel.width]
        for y in [0...kernel.height]
          kernel.data[y*width + x] /= sum
      break
  return kernel
