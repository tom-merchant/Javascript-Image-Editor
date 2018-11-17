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

xDifferentiator = {width: 3, height: 3, data: [1, 0, -1, 2, 0, -2, 1, 0, -1]}
yDifferentiator = {width: 3, height: 3, data: [1, 2, 1, 0, 0, 0, -1, -2, -1]}

coordsToPosition = (i, j, width) ->
  return (j * width + i)

calculatePiecewiseImg = (src1, src2, func) ->
  newData = global.ctx.createImageData src1.width, src1.height
  width = src1.width
  for i in [0...width]
    for j in [0...src2.width]
      pos = j * width + i
      newData.data[pos] = func(src1.data[pos], src2.data[pos])
  return newData

testMaxima = (mags, pos, i2, j2, i3, j3, k) ->
  if mags.data[coordsToPosition i2, j2, mags.width] > mags.data[pos] or mags.data[coordsToPosition i3, j3, mags.width] > mags.data[pos]
    mags.data[pos] = 0

###
Non maxima suppression thins edges by
testing each pixel, looking at the direction of the line
the pixel is a constituent of then zeroing the
pixel if either of its orthogonal neighbours are bigger
###
applyNonMaximaSuppression = (mags, angles) ->
  for i in [0...mags.width]
    for j in [0...mags.height]
      pos = coordsToPosition i, j, mags.width
      if Math.abs(angles.data[pos]) < Math.PI / 8
        testMaxima mags, pos, i - 1, j, i + 1, j
      else if Math.abs(angles.data[pos]) < 3 * Math.PI / 8
        testMaxima mags, pos, i - 1, j + 1, i + 1, j - 1
      else if Math.abs(angles.data[pos]) <  5 * Math.PI / 8
        testMaxima mags, pos, i, j + 1, i, j - 1
      else
        testMaxima mags, pos, i + 1, j + 1, i - 1, j - 1


###--------------------------------------
Functions for calculating Otsus threshold
--------------------------------------###

createIntensityHistogram = (img) ->
  histogram = [0...255]

  for px in img.data
    histogram[px] += 1

  for bin in [0...255]
    histogram[px] /= img.data.length

  return histogram

classProbability = (histogram, lowerBound, upperBound) ->
  p = 0
  for i in [lowerBound...upperBound]
    p += histogram[i]
  return p

classMean = (histogram, classProbability, lowerBound, upperBound) ->
  mean = 0
  for i in [lowerBound...upperBound]
    mean += i * histogram[i]
  mean /= classProbability
  return mean

classVariance = (histogram, classProbability, classMean, lowerBound, higherBound) ->
  variance = 0
  for i in [lowerBound...upperBound]
      ###
      the mean squared-distance for each bin in the class
      ###
    variance += Math.pow(i - classMean, 2) * histogram[i]
    variance /= classProbability

withinClassVariance = (histogram, threshold, upperBound) ->
    lowerClassProbability = classProbability histogram, 0, threshold
    higherClassProbability = classProbability histogram, threshold, upperBound
    lowerClassMean = classMean histogram, lowerClassProbability, 0, threshold
    higherClassMean = classMean histogram, higherClassProbability, threshold, upperBound
    lowerClassVariance = classVariance histogram, lowerClassProbability, lowerClassMean, 0, threshold
    higherClassVariance = classVariance histogram, higherClassProbability, higherClassMean, threshold, upperBound

    return lowerClassProbability * lowerClassVariance + higherClassProbability * higherClassVariance

findOtsuThreshold = (hst, upperBound) ->
  threshold  = 0
  withinClassVariance = 99999999999
  for t in [1...hst.width - 1]
    wcv = withinClassVariance hst, threshold, upperBound
    minWcv = Math.min wcv, withinClassVariance
    if wcv is minWcv
      threshold = t
  return threshold

findOptimalThresholds = (img) ->
  hst = createIntensityHistogram img
  ###First we find the otsu threshold for the image###
  t2 = findOtsuThreshold hst, hst.length
  ###Then we repeat for the lower class to find a suitable hysteresis threhsold###
  t1 = findOtsuThreshold hst, t2
  return [t1, t2]

###------------------
End of Otsu functions
------------------###


findAdjacentPx = (src, i, j, exemptions=[]) ->
  positions = []

  candidates = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]

  ###
  Remove impossible candidates if we are on a boundary
  ###
  if i is 0
    candidates.splice 0, 1
    candidates.splice 3, 1
    candidates.splice 5, 1
  else if i is src.width
    candidates.splice 2, 1
    candidates.splice 4, 1
    candidates.splice 7, 1
  if j is 0
    candidates.splice 0, 1
    candidates.splice 1, 1
    candidates.splice 2, 1
  else if j is src.height
    candidates.splice 5, 1
    candidates.splice 6, 1
    candidates.splice 7, 1

  for e in exemptions
    index = (candidates.findIndex (element, index, array) ->
      if element[0] is nextCandidate[0] and element[1] is nextCandidate[1]
        return true)
    if index > -1
      candidates.splice index, 1

  for candidate in candidates
    if src.data[coordsToPosition i + candidate[0], j + candidate[1]] > 0
      positions.push candidate

  return positions

followEdge = (t1, t2, i, j, lastPoint) ->
  ###Commit this pixel###
  pos = coordsToPosition i, j, t1.width
  t2.data[pos] = t1.data[pos]

  nextCandidate = [lastPoint[0] * -1, lastPoint[1] * -1]

  exemptions = []
  exemptions.push nextCandidate
  exemptions.push lastPoint

  if t2.data[coordsToPosition i + nextCandidate[0], j + nextCandidate[1], t2.width] > 0
    ###We have linked back up with the line so this is an exit case###
    return

  if t1.data[coordsToPosition i + nextCandidate[0], j + nextCandidate[1], t1.width] > 0
      followEdge t1, t2, i + nextCandidate[0], j + nextCandidate[1], [nextCandidate[0] * -1, nextCandidate[1] * -1]
  else
    adjPx = findAdjacentPx t1, i, j, exemptions

    if adjPx.length > 0
      ajdPos = adjPx.pop()
      unless t2.data[coordsToPosition i + ajdPos[0], j + adjPos[1], t2.width] > 0
        followEdge t1, t2, i + ajdPos[0], j + ajdPos[1], [ajdPos[0] * -1, ajdPos[1] * -1]
      else
          return
    else
      ###If there were no more uncertain pixels in the candidate list we have come to the end of the edge or have linked back up with the definite line
         this is our final exit case###
      return

linkEdges = (t1, t2, angles) ->
  for i in [0...t1.width]
    for j in [0...t1.height]
      pos = coordsToPosition i, j, t1.width,
      if t1.data[pos] > 0 and t2.data[pos] == 0
        ####This pixel is either edge or noise###
        adjPos = findAdjacentPx t2, i, j
        if adjPos.length == 0
          ###This pixel is not attached to any strong edges, ignore for now###
        else
          ###Continue to follow this edge until we get to the end or rejoin the strong edge###
          followEdge t1, t2, angles, i, j, adjPos.pop()



global.filter.edgeDetect = (src, options={smoothing: 1.8}) ->
  ###
  Smooth the image to reduce noise
  ###
  smoothedImg = src
  unless options.smoothing is 0
    gfilter = global.filter.createIIR options.smoothing
    smoothedImg = global.filter.applyFilter gfilter, src

  grayscaleImg = {width: src.width, height: src.height, data: []}

  global.filter.makeGrayscale src, grayscaleImg

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

  ###
  Thin edges
  ###
  applyNonMaximaSuppression magnitudes, angles

  ###
  Double threshold to ensure continuous edges
  ###
  threshold2 = {width: src.width, height: src.height, data: []}

  for i in [0...src.width]
    for j in [0...src.height]
      pos = coordsToPosition i, j, magnitudes.width
      threshold2.data.push magnitudes.data[pos]

  thresholds = findOptimalThresholds magnitudes

  global.filter.applyThreshold magnitudes, src.width, src.height, thresholds[0]
  global.filter.applyThreshold threshold2, src.width, src.height, thresholds[1]

  linkEdges magnitudes, threshold2, angles

  return [threshold2, angles]
