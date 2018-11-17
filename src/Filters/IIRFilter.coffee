#pragma once

###
Implementation of Young and Van Vliet s recursive Gaussian filter
https://www.researchgate.net/publication/222453003_Recursive_implementation_of_the_Gaussian_filter, DOI: 10.1016/0165-1684(95)00020-E

Tom Merchant 2018
###

#include <jdefs.h>

class global.filter.IIR
  constructor: (sigma) ->
    global.assert sigma >= 0.5

    if sigma >= 2.5
      q = 0.98711 * sigma - 0.96330
    else
      q = 3.97156 - 4.14554 * Math.sqrt(1 - 0.26891 * sigma)

    q2 = q * q
    q3 = q2 * q

    @b0 = 1.57825 + 2.44413 * q + 1.4281 * q2 + 0.422205 * q3
    @b1 = 2.44413 * q + 2.85619 * q2 + 1.26661 * q3
    @b2 = -(1.4281 * q2 + 1.26661 * q3)
    @b3 = 0.422205 * q3
    @norm = 1 - ((@b1 + @b2 + @b3)/@b0)

    @d1 = 0
    @d2 = 0
    @d3 = 0

  clear: ->
    @d1 = 0
    @d2 = 0
    @d3 = 0

  nextSample: (input) ->
    v1 = @norm * input
    v2 = @b1 * @d1 + @b2 * @d2 + @b3 * @d3

    @d3 = @d2
    @d2 = @d1

    @d1 = v1 + v2 / @b0

    return @d1
