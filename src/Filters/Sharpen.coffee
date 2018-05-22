#include <jdefs.h>
#include "Common.coffee"

global.filter.highpass = (src, options={}) ->
  options ?= {}
  unless options.hasOwnProperty("radius")
    options.radius = 3
  lfilter = global.filter.createBiquad "sharpen", options.radius
  return global.filter.applyFilter lfilter, src
