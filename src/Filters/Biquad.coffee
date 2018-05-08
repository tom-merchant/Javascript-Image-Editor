###
Tom Merchant 2018
Biquadratic IIR filter implementation, implementing lowpass and highpass
###

#include <jdefs.h>

class global.filter.Biquad
  constructor: (freq, nyquist, resonance, @type) ->
    @fc = freq / (2 * nyquist)
    k = Math.tan(Math.PI * @fc)

    global.assert @type in ["blur", "sharpen"]

    switch @type
      when "blur"
        norm = 1 / (1 + k / resonance + k * k)
        @a0 = k * k * norm
        @a1 = 2 * @a0
        @a2 = @a0
        @b1 = 2 * (k * k - 1) * norm
        @b2 = (1 - k / resonance + k * k) * norm
        break
      when "sharpen"
        norm = 1 / (1 + k / resonance + k * k)
        @a0 = norm
        @a1 = -2 * @a0
        @a2 = @a0
        @b1 = 2 * (k * k - 1) * norm
        @b2 = (1 - k / resonance + k * k) * norm
        break
    @d0 = 0
    @d1 = 0

  nextSample: (input) ->
    v1 = input - @d0 * @b1 - @d1 * @b2
    v2 = @a0 * v1 + @d0 * @a1 + @d1 * @a2

    @d1 = @d0
    @d0 = v1

    return v2
  
  clear: ->
  	@d0 = 0
  	@d1 = 0
    