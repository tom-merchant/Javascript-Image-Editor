#include <jdefs.h>

###
Hough transform
Derived from:
http://aishack.in/tutorials/hough-transform-normal/
http://homepages.inf.ed.ac.uk/rbf/HIPR2/hough.htm
###

global.filters.detectLines = (img) ->
  diagonal = Math.ceil Math.hypot img.width, img.height
  houghSpace = []
  ###
  We need to pick a value for the granularity of the line gradients
  Too fine and weak or imperfect lines wont be picked up and
  bright spots in the parameter space wont be sufficiently localised
  Too coarse and too many phantom lines will be picked up and
  the lines may have inaccurate gradients by a few degrees
  ###
  granularity = ~~((img.width + img.height) * 2/3)
  for i in [0...diagonal]
	  houghSpace[i] = []
  for i in img.width
	  for j in img.height
	    pos = j * width + i
	    unless img.data[pos] is 0
		    ###
		    TODO: Use angle data to narrow the search space
		    ###
		    for theta in [0...granularity]
		      rad = (theta / granularity) * Math.PI
		      r = i * Math.cos(rad) + j * Math.sin(rad)
		      unless houghSpace[r][theta]
		        houghSpace[r][theta] = 0
		      houghSpace[r][theta]++;
  return houghSpace
