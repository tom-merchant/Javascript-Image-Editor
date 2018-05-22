###
Pencil.coffee
Implements a pencil tool for drawing
Tom Merchant 2018
###

#include <jdefs.h>

class global.tools.Pencil extends global.tools.Tool
  
  constructor: ->
    super("Pencil", global.tools.getIcon "Pencil", "A pencil tool for drawing", global.tools.getCursor "Pencil")
  
  begin: ->
  	super

  update: ->
  	super
   
  end: ->
  	super
