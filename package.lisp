;;;; package.lisp

(defpackage #:files-and-folders
  (:use #:cl
        #:peyton-utils)
  (:nicknames #:faf)
  (:export #:list-directory
           #:merge-pathnames))
