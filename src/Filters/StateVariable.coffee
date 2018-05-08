###
StateVariable.coffee Tom Merchant 2018
Coffeescript port of https://github.com/moddevices/caps-lv2/blob/master/dsp/SVF.h
###

###
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 3
    of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
    02111-1307, USA or point your web browser to http://www.gnu.org.
###

###
class SVF
  constructor: (freq, nyquist, resonance, @type) ->
    global.assert(resonance > 0)
    k = (1 - 0.99 * resonance)
    fc = freq / (2 * nyquist)
    @g = Math.tan(fc * Math.PI)

    @c1 = 2 * (@g + k)
    @c2 = @g/(1 + @g * (@g + k))

    @d0 = 0
    @d1 = 0
    @d2 = 0


  nextSample: (input) ->
    v1 = @d1 + @c2 * (input + @d0 - @c1 * @d1 - 2 * @v2)
    v2 = @d2 + @g * (v1 + @d1)

    @d0 = input
    @d1 = v1
    @d2 = v2

    lowpass = v2
    bandpass = v1
    highpass = input - @k * v1 - v2

    return [lowpass, highpass, bandpass]

  clear: ->
    @d0 = 0
    @d1 = 0
    @d2 = 0
###

class SVF
  constructor: (freq, nyquist, resonance, @type) ->
    global.assert(resonance > 0)
    
    fc = freq / (2 * nyquist)

    @f = Math.min(0.25, 2 * Math.sin(Math.PI * fc))
    q = 2 * Math.cos(Math.pow(resonance, 0.1) * Math.PI / 2)
    @q = Math.min(q, Math.min(2, 2 / @f - @f / 2))
    @qnorm = Math.sqrt(Math.abs(q) / 2 + 0.001)
    @highpass = 0
    @lowpass = 0
    @bandpass = 0


  nextSample: (input) ->
    v0 = @qnorm * input

    @highpass = v0 - @lowpass - @q * @bandpass
    @bandpass += @f * @highpass
    @lowpass += @f * @bandpass

    return [@lowpass, @highpass, @bandpass]

  clear: ->
    @highpass = 0
    @lowpass = 0
    @bandpass = 0