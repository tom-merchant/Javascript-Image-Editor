#include <jdefs.h>
#include "Blur.coffee"
#include "Common.coffee"

###
Applies the specified filter to src canvas, places it in dest

@param [String] type The filter to apply, eg gaussianblur
@param [Image] src The source image to filter
@param [Canvas] dest The destination canvas to place the image into
@param [Object] filter options, the available options depend on the filter
###
global.applyFilter = (type, src, dest, options) ->
  global.assert(type in ["gaussianblur", "lowpassblur"])

  data = src.getContext("2d").getImageData 0, 0, src.width, src.height
  result = null

  switch type
    when "gaussianblur"
      result = global.filter.gaussian data, options
      break
    when "lowpassblur"
      result = global.filter.lowpass data, options
      break
  dest.getContext("2d").putImageData result, 0, 0

