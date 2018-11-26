#pragma once
#include <jdefs.h>
#include "Common.coffee"
#include "Grayscale.coffee"

###
Canny filter derived from these sources
http://homepages.inf.ed.ac.uk/rbf/HIPR2/canny.htm
http://www.intelligence.tuc.gr/~petrakis/courses/computervision/canny.pdf
http://www.math.tau.ac.il/~turkel/notes/otsu.pdf

I suppose I could have used a Library instead, this is quite some work for a smallish feature.
###

xDifferentiator = {width: 3, height: 1, data: [1, 0, -1], radius: 2}
yDifferentiator = {width: 1, height: 3, data: [1, 0, -1], radius: 2}

calculatePiecewiseImg = (src1, src2, func) ->
  newData = {width: src1.width, height: src1.height, data: []}
  width = src1.width
  for i in [0...width]
    for j in [0...src1.height]
      pos = j * width + i
      newData.data[pos] = func(src1.data[pos], src2.data[pos])
  return newData


###--------------------------------------
Functions for calculating Otsus threshold
--------------------------------------###

createIntensityHistogram = (img) ->
  histogram = [0..255]

  for px in img.data
    histogram[px] += 1

  ###
  Zero the zero bin otherwise our t1
  will always be 0 due to the huge
  concentration of 0s
  ###
  histogram[0] = 0

  ###
  Normalize the histogram so
  all the probabilities add up to 1
  ###
  sum = 0

  for bin in [0..255]
    sum += histogram[bin]

  for bin in [0..255]
    histogram[bin] /= sum

  return histogram

classProbability = (histogram, lowerBound, upperBound) ->
  p = 0
  for i in [lowerBound..upperBound]
    p += histogram[i]
  return p

classMean = (histogram, classProbability, lowerBound, upperBound) ->
  mean = 0
  for i in [lowerBound..upperBound]
    mean += i * histogram[i]
  mean /= classProbability
  return mean

classVariance = (histogram, classProbability, classMean, lowerBound, upperBound) ->
  variance = 0
  for i in [lowerBound..upperBound]
      ###
      the mean squared-distance for each bin in the class
      ###
    variance += Math.pow(i - classMean, 2) * histogram[i]
  variance /= classProbability
  return variance

withinClassVariance = (histogram, lowerBound, threshold, upperBound) ->
    lowerClassProbability = classProbability histogram, lowerBound, threshold
    higherClassProbability = classProbability histogram, threshold, upperBound

    lowerClassMean = classMean histogram, lowerClassProbability, lowerBound, threshold
    higherClassMean = classMean histogram, higherClassProbability, threshold, upperBound

    lowerClassVariance = classVariance histogram, lowerClassProbability, lowerClassMean, lowerBound, threshold
    higherClassVariance = classVariance histogram, higherClassProbability, higherClassMean, threshold, upperBound

    return lowerClassProbability * lowerClassVariance + higherClassProbability * higherClassVariance

findOtsuThreshold = (hst, lowerBound, upperBound) ->
  threshold  = 0
  minWcv = Infinity
  for t in [lowerBound+1...upperBound]
    wcv = withinClassVariance hst, lowerBound, t, upperBound
    minWcv = Math.min wcv, minWcv
    if wcv is minWcv
      threshold = t
  return threshold

findOptimalThreshold = (img) ->
  hst = createIntensityHistogram img
  ###First we find the otsu threshold for the image###
  t = findOtsuThreshold hst, 0, hst.length - 1
  return t

###------------------
End of Otsu functions
------------------###

global.filter.edgeDetect = (src, options={smoothing: 1.8}) ->
  ###
  Smooth the image to reduce noise
  ###
  smoothedImg = src
  unless options.smoothing is 0
    gfilter = global.filter.createIIR options.smoothing
    smoothedImg = global.filter.applyFilter gfilter, src

    ###
    FIXME: wouldnt it make sense to do the blur after
          grayscaling?
    ###

  grayscaleImg = {width: src.width, height: src.height, data: []}

  global.filter.makeGrayscale smoothedImg, grayscaleImg

  ###
  Compute partial derivatives for the x and y axis
  ###
  xGradients = global.filter.applyKernel xDifferentiator, grayscaleImg, grayscale=yes
  yGradients = global.filter.applyKernel yDifferentiator, grayscaleImg, grayscale=yes

  ###
  Calculate the magnitudes and angles for each point
  ###
  magnitudes = calculatePiecewiseImg(xGradients, yGradients, Math.hypot)
  angles = calculatePiecewiseImg(yGradients, xGradients, Math.atan2)

  for i in [0..magnitudes.width * magnitudes.height]
    magnitudes.data[i] = Math.min(~~magnitudes.data[i], 255)

  threshold = findOptimalThreshold magnitudes

  global.filter.applyThreshold magnitudes.data, magnitudes.width, magnitudes.height, threshold

  return [magnitudes, angles]
