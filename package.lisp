;;;; package.lisp

(defpackage #:files-and-folders
  (:use #:cl)
  (:nicknames #:faf)
  (:export #:force-directory
           #:force-file
           #:list-directory
           #:merge-paths
           #:filep
           #:folderp))
