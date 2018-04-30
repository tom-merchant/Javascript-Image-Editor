#include <jdefs.h>
#include "Common.coffee"

###
Applies the specified filter to src canvas, places it in dest

@param [String] type The filter to apply, eg gaussianblur
@param [Image] src The source image to filter
@param [Canvas] dest The destination canvas to place the image into
@param [Object] filter options, the available options depend on the filter
###
global.applyFilter = (type, src, dest, options) ->
  switch type
    when "gaussianblur"
      break
    when "boxblur"
      break
    when "lowpassblur"
      break
    when "biquadblur"
      break
