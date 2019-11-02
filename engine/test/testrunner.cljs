(ns testrunner
  (:require [doo.runner :refer-macros [doo-tests]]
            [engine.abilities-test]
            [engine.attack-test]
            [engine.core-test]
            [engine.transformations-test]
            [engine.utils-test]
            [client.api-test]))

(doo-tests 'engine.abilities-test
           'engine.attack-test
           'engine.core-test
           'engine.transformations-test
           'engine.utils-test
           'client.api-test)
