#include <jdefs.h>

global.testing.tests = []

global.testing.runTests: ->
  results = new Array(global.testing.tests.length)
  for i in [0...global.testing.tests.length]
  	tests[i].setup()

    totaltime = 0
    passes = 0
    fails = 0

    for input in [0...global.testing.tests[i].inputs.length]
      var start = performance.now()
  	  result = global.testing.tests[i].run(global.testing.tests[i].inputs[input])
      var end = performance.now()

      testtime = end-start
      totaltime += testtime

      success = test.check(testtime, result)
      passes += success
      fails += !success

    results[i] = {time: totaltime, failures: fails, passes: passes}

  	tests[i].teardown()