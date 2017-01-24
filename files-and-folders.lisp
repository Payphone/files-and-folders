;;;; files-and-folders.lisp

(in-package #:files-and-folders)

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

;; Things we need: the first and last values.
(defun merge-paths (&rest paths)
  (let ((first (first paths))
        (last (car (last paths))))
    (if (pathname-name last)
         (make-pathname
          :directory (append (pathname-directory first)
                             (remove-if #'symbolp (flatten (mapcar #'pathname-directory
                                                                   (cdr (butlast paths))))))
          :name (pathname-name last))
         (make-pathname
          :directory (append (pathname-directory first)
                             (remove-if #'symbolp (flatten (mapcar #'pathname-directory
                                                                   (cdr paths)))))))))

(defun flatten (lst &optional acc)
  (if lst
      (if (consp lst)
          (flatten (cdr lst) (cons lst acc))
          (flatten (car lst) acc))
      acc))
