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
