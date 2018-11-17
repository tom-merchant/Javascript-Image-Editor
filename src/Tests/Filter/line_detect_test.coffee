#include <jdefs.h>
#include "../../Filters/EdgeDetect.coffee"
#include "../../Filters/LineDetect.coffee"

line_detect_test =
  setup: ->
    createNamespace("filters")
  run: (input) ->
    return true
  teardown: ->
    return
