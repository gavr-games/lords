(defproject engine "0.1.0-SNAPSHOT"
  :description "Game engine"
  :url "https://gavr.games"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [compojure "1.6.1"]
                 [ring/ring-defaults "0.3.2"]
                 [ring/ring-json "0.5.0"]]
  :plugins [[lein-ring "0.12.5"]]
  :ring {:handler engine.server/app}
  :profiles
  {:dev {:dependencies [[ring/ring-mock "0.3.2"]
                        [ring/ring-devel "1.7.1"]
                        [ring/ring-jetty-adapter "1.7.1"]]}})
