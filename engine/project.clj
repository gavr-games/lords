(defproject engine "0.1.0-SNAPSHOT"
  :description "Game engine"
  :url "https://gavr.games"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [org.clojure/clojurescript "1.10.520"]
                 [compojure "1.6.1"]
                 [ring/ring-defaults "0.3.2"]
                 [ring/ring-json "0.5.0"]
                 [lein-doo "0.1.11"]]
  :plugins [[lein-ring "0.12.5"]
            [lein-cljsbuild "1.1.7"]
            [lein-doo "0.1.11"]]
  :ring {:handler server.core/app}

  :cljsbuild {
              :builds {:compile {:source-paths ["src"]
                                 :compiler {:output-to
                                            "resources/public/engine.js"
                                            :optimizations :advanced}}
                       :js-test {:source-paths ["src" "test"]
                                 :compiler {:output-to "out/tests.js"
                                            :main testrunner
                                            :optimizations :whitespace}}}}

  :doo {:build "js-test"
        :alias {:default [:nashorn]}}

  :profiles
  {:dev {:dependencies [[ring/ring-mock "0.3.2"]
                        [ring/ring-devel "1.7.1"]
                        [ring/ring-jetty-adapter "1.7.1"]]}})
