#pragma once

###
Blur.coffee Tom Merchant 2018

Provides a method that enables the gaussian blurring of images
###

#include <jdefs.h>
#include "Common.coffee"

global.filter.gaussian = (src, options={}) ->
  options ?= {}
  unless options.hasOwnProperty("radius")
  	options.radius = 3
  gfilter = global.filter.createIIR options.radius
  return global.filter.applyFilter gfilter, src
