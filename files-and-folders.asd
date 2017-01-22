;;;; files-and-folders.asd

(asdf:defsystem #:files-and-folders
  :description "Making path names less painful."
  :author "Peyton Farrar <peyton@peytonfarrar.com>"
  :license "MIT"
  :serial t
  :components ((:file "package")
               (:file "files-and-folders")))
