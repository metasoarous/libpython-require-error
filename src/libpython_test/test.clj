(ns libpython-test.test
  (:require [libpython-clj2.python :as py]
            [libpython-clj2.require :refer [require-python import-python]]))

(println "Establishing python link")
(py/initialize!)
(import-python)
(println "Link established; requiring libs...")
(require-python '[sklearn.datasets :as sk-data])
(println "  requiring sk-data...")
(require-python '[sklearn.model_selection :as sk-model])
(println "  requiring sk-decomp...")
(require-python '[sklearn.decomposition :as sk-decomp])
(println "  requiring numpy...")
(require-python '[numpy :as numpy])
(println "  requiring numba...")
(require-python '[numba :as numba])
(println "  requiring pandas...")
(require-python '[pandas :as pandas])
(println "  requiring umap...")
(require-python '[umap :as umap])
(println "  requiring umap_metric...")
(require-python '[umap_metric :as umap_metric :reload])
(println "DONE with python requires")

(defn full-circle []
  (py/->jvm (py/->python (repeatedly 10 #(rand-int 100)))))

;(full-circle)


(println :OK)
