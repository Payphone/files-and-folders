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

(defun extract-path (path)
  (remove-if #'symbolp (pathname-directory path)))

(defun merge-path (path1 path2)
  (if (null path1)
      (extract-path path2)
      (append (extract-path path1)
              (extract-path path2))))

(defun merge-paths (root &rest args)
  "Combines paths assuming all arguments are a subdirectory of root."
  (case (length args)
    (0 root)
    (1 (merge-pathnames (first args) root))
    (t (make-pathname :directory (append (pathname-directory (force-directory root))
                                         (reduce #'merge-path args))
                      :name (pathname-name (car (last args)))))))
