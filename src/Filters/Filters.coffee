#include <jdefs.h>
#include "Blur.coffee"
#include "Sharpen.coffee"
#include "Common.coffee"

###
Applies the specified filter to src canvas, places it in dest

@param [String] type The filter to apply, eg gaussianblur
@param [Image] src The source image to filter
@param [Canvas] dest The destination canvas to place the image into
@param [Object] filter options, the available options depend on the filter
###
global.applyFilter = (type, src, dest, options) ->
  global.assert(type in ["gaussianblur", "lowpassblur", "unsharpsharpen", "biquadsharpen"])

  data = src.getContext("2d").getImageData 0, 0, src.width, src.height
  result = null

  switch type
    when "gaussianblur"
      result = global.filter.gaussian data, options
      break
    when "lowpassblur"
      result = global.filter.lowpass data, options
      break
    when "unsharpsharpen"
      result = global.filter.gaussian data, options
      for ch in [0..3]
        for x in [0...data.width]
          for y in [0...data.height]
            len = (y * data.width + x) * 4 + ch
            ###
            TODO this is the wrong operation
            ###
            result.data[len] = data.data[len] + (data.data[len] - result.data[len])
      break
    when "sharpensharpen"
      break
    when "biquadsharpen"
      result = global.filter.highpass data, options
      for ch in [0..3]
        for x in [0...data.width]
          for y in [0...data.height]
            len = (y * data.width + x) * 4 + ch
            result.data[len] += data.data[len]
      break
  dest.getContext("2d").putImageData result, 0, 0
