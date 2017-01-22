;;;; files-and-folders.lisp

(in-package #:files-and-folders)

(defun force-directory (folder)
  "Explicitly sets a path to be a folder."
  (let ((directory (pathname-directory folder))
        (name (pathname-name folder)))
    (if directory
        (make-pathname :directory (if name (snoc name directory) directory))
        (make-pathname :directory (list :RELATIVE name)))))

(defun list-directory (folder)
  "Returns a list of files in the directory."
  (directory
   (make-pathname :type :wild :name :wild
                  :directory (pathname-directory (force-directory folder)))))

(defun merge-paths (root &rest args)
  "Combines paths assuming all arguments are a subdirectory of root."
  (make-pathname :directory (append (pathname-directory (force-directory root))
                                    (reduce #'merge-path args :initial-value nil))))

(defun merge-path (path1 path2)
  (if (null path1)
      (remove-if #'symbolp (pathname-directory (force-directory path2)))
      (append (remove-if #'symbolp (pathname-directory (force-directory path1)))
              (remove-if #'symbolp (pathname-directory (force-directory path2))))))
