(ns libpython-test.core
  "Core Polis data analysis API, implemented with tech.v3.dataset and libpython-clj2 for python interop."
  (:require [tech.v3.dataset :as ds]
            [tech.v3.dataset.math :as dmath]
            [tech.v3.dataset.join :as djoin]
            [tech.v3.dataset.column :as dcol]
            [tech.v3.dataset.tensor :as dtensor]
            [tech.v3.datatype :as dt]
            [tech.v3.tensor :as tens]
            [tech.v3.datatype.functional :as dfn]
            [libpython-clj2.python.np-array] ;; this is for side effects plugging numpy into tech.v3
            [libpython-clj2.python :as py :refer [py. py.. py.-]]
            [libpython-clj2.require :refer [require-python import-python]]))


(println "Establishing python link")
(py/initialize!)
(import-python)
(println "Link established; requiring libs")
(require-python '[sklearn.datasets :as sk-data]
                '[sklearn.model_selection :as sk-model]
                '[sklearn.decomposition :as sk-decomp]
                '[numpy :as numpy]
                '[numba :as numba]
                '[pandas :as pandas]
                '[umap :as umap]
                '[umap_metric :as umap_metric :reload])
(println "Python connected")

;(py/as-list (py/->python [1 2 3]))

(defn row-major-tensor->dataset
  "Takes a row-major tensor and casts as a dataset with given colnames"
  ([tensor colnames]
   (ds/rename-columns (dtensor/tensor->dataset tensor)
                      (into {} (map vector (range) colnames))))
  ([tensor]
   (dtensor/tensor->dataset tensor)))

(defn np-array->dataset
  "Takes a row-major numpy tensor and casts as a dataset with given colnames"
  ([np-array colnames]
   (row-major-tensor->dataset
     (py/->jvm np-array)
     colnames))
  ([np-array]
   (row-major-tensor->dataset
     (py/->jvm np-array))))


(defn apply-umap
  [matrix {:keys [dimensions] :or {dimensions 2}}]
  (let [reducer (umap/UMAP :n_components dimensions
                           :n_neighbors 10
                           :metric umap_metric/sparsity_aware_dist2)
        np-matrix (py/->python (dtensor/dataset->tensor matrix :float64))
        embedding (np-array->dataset (py. reducer fit_transform np-matrix)
                                     [:umap1 :umap2])]
    embedding))


