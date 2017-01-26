;; files-and-folders.lisp

(in-package :files-and-folders)

(defun force-directory (foldername)
  "Explicitly sets a path to be a folder."
  (let* ((folder (pathname foldername))
         (directory (pathname-directory folder))
         (name (pathname-name folder)))
    (if  directory
        (make-pathname :directory (if name (snoc name directory) directory))
        (make-pathname :directory (list :RELATIVE name)))))

(defun force-file (filename)
  "Explicitly sets a path to be a file."
  (let ((directory (pathname-directory filename)))
    (if (pathname-name filename)
        filename
        (make-pathname :directory (butlast directory)
                       :name (car (last directory))))))

(defun list-directory (folder)
  "Returns a list of files in the directory."
  (directory
   (make-pathname :type :wild :name :wild
                  :directory (pathname-directory (force-directory folder)))))

(defun merge-path (path1 path2)
  (make-pathname
   :directory (append (pathname-directory (force-directory path1))
                      (remove-if #'symbolp (pathname-directory path2)))
   :name (pathname-name path2)
   :type (pathname-type path2)))

(defun merge-paths (&rest paths)
  (reduce #'merge-path
          paths))
