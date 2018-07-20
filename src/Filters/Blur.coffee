#include <jdefs.h>
#include "Common.coffee"

global.filter.gaussian = (src, options={}) ->
  options ?= {}
  unless options.hasOwnProperty("radius")
  	options.radius = 3
  gfilter = global.filter.createIIR options.radius
  return global.filter.applyFilter gfilter, src
