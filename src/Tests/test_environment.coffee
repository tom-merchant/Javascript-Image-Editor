#include <jdefs.h>

tests = []

runTests: ->
  for test in tests
  	test.setup()
  	result = test.run()
  	test.teardown()