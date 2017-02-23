;;;; package.lisp

(defpackage #:files-and-folders
  (:use #:cl
        #:peyton-utils
        #:alexandria)
  (:nicknames #:faf)
  (:export #:force-directory
           #:list-directory
           #:escape-shell-string
           #:merge-path
           #:merge-paths
           #:filep
           #:folderp
           #:list-all-files
           #:shorten-directory))
