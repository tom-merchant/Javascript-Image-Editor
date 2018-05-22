###
Tools.coffee
Base class for all tools
Tom Merchant 2018
###

#include <jdefs.h>

class global.tools.Tool
  constructor: (@name, @icon, @description, @cursor) ->
