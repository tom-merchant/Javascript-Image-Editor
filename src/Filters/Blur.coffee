#include <jdefs.h>
#include "Common.coffee"

global.filter.gaussian = (src, options={}) ->
  unless options.radius?
  	options.radius = 3
  gfilter = global.filter.createIIR options.radius
  return global.filter.applyFilter gfilter, src

global.filter.lowpass = (src, options={}) ->
  unless options.radius?
    options.radius = 3
  lfilter = global.filter.createBiquad "blur", options.radius
  return global.filter.applyFilter lfilter, src