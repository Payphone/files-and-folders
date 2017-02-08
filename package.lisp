;;;; package.lisp

(defpackage #:files-and-folders
  (:use #:cl
        #:peyton-utils)
  (:nicknames #:faf)
  (:export #:force-directory
           #:list-directory
           #:merge-path
           #:merge-paths
           #:filep
           #:folderp
           #:list-all-files
           #:shorten-directory))
