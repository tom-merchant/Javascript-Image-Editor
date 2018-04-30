###
Common utilities for implementing image filters

Tom Merchant 2017
###

#include <jdefs.h>

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

  for i in [0...src.width * src.height]
  	x = i % src.width
    y = Math.floor (i / src.width)

    newKernel = global.filter.resizeKernel kernel, x, y

    newData.data[i] = global.filter.processPixel newKernel, x, y, src

  return newData

global.filter.resizeKernel  = (kernel, x, y, image) ->
  border_y_top = 0
  border_y_bottom = 0
  border_x_left = 0
  border_x_right = 0

  newKernel = JSON.parse (JSON.stringify kernel)

  if y < kernel.height / 2
    border_y_top = kernel.height / 2 - y
  if y > image.height - kernel.height / 2
    border_y_bottom = kernel.height / 2 - (image.height - y)
  if x < kernel.width / 2
    border_x_left = kernel.width / 2 - x
  if x > image.width - kernel.width / 2
    border_x_right = kernel.height / 2 - (image.width - x)

  global.filter.resize newKernel, border_y_top, border_y_bottom, border_x_left, border_x_right

  return newKernel

global.filter.resize = (kernel, border_y_top, border_y_bottom, border_x_left, border_x_right) ->
  for n in [0...top_excess]
    global.filter.clearRow newKernel, n
  for in [0...bottom_excess]
    global.filter.clearRow newKernel, kernel.height - n
  for i in [0...left_excess]
    global.filter.clearColumn newKernel, n
  for i in [0...right_excess]
    global.filter.clearColumn newKernel, kernel.width - n

global.filter.clearRow = (kernel, row)
  for x in [0...kernel.width]
    kernel.data[row * kernel.width + x] = NaN

global.filter.clearColumn = (kernel, col)
  for y in [0...kernel.height]
    kernel.data[y * kernel.width + col] = NaN

global.filter.processPixel = (kernel, i, j, image) ->
  sum = 0
  n = 0

  for x in [0...kernel.width]
    for y in [0...kernel.height]
      if not kernel.data[y * kernel.width + x] is NaN
        n += 1
        sum += global.ungamma(image.data[(j + y - kernel.height / 2) * kernel.width + (i + x - kernel.width / 2)]) * kernel.data[y * kernel.width + x]

  return global.regamma sum / n


###
Builds the approppriate kernel to perform the required filtering operation

@param type [String] The type of kernel to build
@param radius [Number] the radius if using a blur or sharpen etc
@param width [Integer] Optional, the width of the kernel (some filters ignore this)
@pparam height [Integer] Optional, the height of the kernel (some filters ignore this)

@return [Object] The built kernel
###
global.filter.buildKernel = (type, radius, width, height) ->
  width ?= radius * 2
  height ?= radius * 2
  kernel =
    data: []
    width: width
    height: height
  switch type
    when "gaussian"
      size = ~~(radius * 2) + 1
      kernel.width = size
      height = size
      centre = [size / 2, size / 2]
      ###
      TODO: This is inefficient, the gaussian distribution is symmetrical
      ###
      for x in [0...kernel.width]
        for y in [0...kernel.height]
          dx = centre[0] - x
          dy = centre[1] - y
          kernel.data[y*width + x] = global.gauss(dx, radius/2) * global.gauss(dy, radius / 2)
      break
  return kernel
