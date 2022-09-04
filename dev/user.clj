
(ns user
  (:require [tech.v3.dataset :as ds]
            [tech.v3.datatype :as dt]
            [libpython-test.test :as test]))

            ;[libpython-clj2.require :refer [require-python]]
            ;[libpython-clj2.python :as py :refer [py. py.. py.-]]))

(try
  (println "I have come round:" (test/full-circle))
  (catch Throwable t
    (.printStackTrace t)))

