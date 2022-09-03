
(ns user
  (:require [tech.v3.dataset :as ds]
            [tech.v3.datatype :as dt]))
            ;[libpython-test.core]))
            ;[libpython-clj2.require :refer [require-python]]
            ;[libpython-clj2.python :as py :refer [py. py.. py.-]]))

(try
  (require 'libpython-test.core)
  (catch Throwable t
    (.printStackTrace t)))

