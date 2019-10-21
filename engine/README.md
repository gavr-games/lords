# Game Engine

This is a web server for the game engine

## Running

To start a web server for the application, run:

    lein ring server

## Running from REPL

    (ns engine.handler)
    (use 'ring.adapter.jetty)
    (use 'ring.middleware.reload)
    (def srv (run-jetty (wrap-reload #'app) {:port 3000 :join? false}))

To stop:

    (.stop srv)


## Running tests

To run clojure (server) tests

    lein test


## Javascript engine library

To compile library and put it into resources/public/engine.js

    lein cljsbuild once compile

To run js engine library tests (same tests, just compiled to js)

    lein doo once

This will use nashorn js environment (included by default with jdk)

